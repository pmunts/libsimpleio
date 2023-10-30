{ 64-byte message services using libusb-1.0 raw HID transport                 }

{ Copyright (C)2020-2023, Philip Munts dba Munts Technologies.                }
{                                                                             }
{ Redistribution and use in source and binary forms, with or without          }
{ modification, are permitted provided that the following conditions are met: }
{                                                                             }
{ * Redistributions of source code must retain the above copyright notice,    }
{   this list of conditions and the following disclaimer.                     }
{                                                                             }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" }
{ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   }
{ IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  }
{ ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   }
{ LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         }
{ CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        }
{ SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    }
{ INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     }
{ CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     }
{ ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  }
{ POSSIBILITY OF SUCH DAMAGE.                                                 }

{ Allowed values for the timeout parameter:                          }
{                                                                    }
{  0 => Send or receive operation blocks forever.                    }
{ >0 => Send or receive operation blocks for the indicated number of }
{       milliseconds.                                                }

UNIT HID_libusb;

INTERFACE

  USES
    Message64;

  TYPE
    MessengerSubclass = CLASS(TInterfacedObject, Message64.Messenger)
      CONSTRUCTOR Create
       (vid       : Cardinal;
        pid       : Cardinal;
        serial    : String = '';
        timeoutms : Cardinal = 1000;
        iface     : Cardinal = 0;
        epin      : Byte = $81;
        epout     : Byte = $01);

      DESTRUCTOR Destroy; OVERRIDE;

      PROCEDURE Send(cmd : Message);

      PROCEDURE Receive(VAR resp : Message);

      PROCEDURE Transaction(cmd : Message; VAR resp : Message);

      FUNCTION Name : String;

      FUNCTION Manufacturer : String;

      FUNCTION Product : String;

      FUNCTION SerialNumber : String;

    PRIVATE
      handle  : Pointer;
      epin    : Byte;
      epout   : Byte;
      timeout : Cardinal;
    END;

IMPLEMENTATION

  { Minimal Pascal thin binding to libusb }

  CONST
    LIBUSB_SUCCESS             = 0;
    LIBUSB_ERROR_IO            = -1;
    LIBUSB_ERROR_INVALID_PARAM = -2;
    LIBUSB_ERROR_ACCESS        = -3;
    LIBUSB_ERROR_NO_DEVICE     = -4;
    LIBUSB_ERROR_NOT_FOUND     = -5;
    LIBUSB_ERROR_BUSY          = -6;
    LIBUSB_ERROR_TIMEOUT       = -7;
    LIBUSB_ERROR_OVERFLOW      = -8;
    LIBUSB_ERROR_PIPE          = -9;
    LIBUSB_ERROR_INTERRUPTED   = -10;
    LIBUSB_ERROR_NO_MEM        = -11;
    LIBUSB_ERROR_NOT_SUPPORTED = -12;
    LIBUSB_ERROR_OTHER         = -99;

  TYPE
    DeviceDescriptor = RECORD
      bLength            : Byte;
      bDescriptorTYpe    : Byte;
      bcdUSB             : Word;
      bDeviceClass       : Byte;
      bDeviceSubClass    : Byte;
      bDeviceProtocol    : Byte;
      bMaxPacketSize0    : Byte;
      idVendor           : Word;
      idProduct          : Word;
      bcdDevice          : Word;
      iManufacturer      : Byte;
      iProduct           : Byte;
      iSerialNumber      : Byte;
      bNumConfigurations : Byte;
    END;

  FUNCTION libusb_init
   (context    : Pointer) : Integer; CDECL; EXTERNAL;

  FUNCTION libusb_get_device_list
   (context    : Pointer;
    list       : Pointer) : Integer; CDECL; EXTERNAL;

  PROCEDURE libusb_free_device_list
   (list       : Pointer;
    unref      : Integer); CDECL; EXTERNAL;

  FUNCTION libusb_open
   (dev        : Pointer;
    VAR handle : Pointer) : Integer; CDECL; EXTERNAL ;

  PROCEDURE libusb_close
   (handle     : Pointer); CDECL; EXTERNAL ;

  FUNCTION libusb_set_auto_detach_kernel_driver
   (handle     : Pointer;
    enable     : Integer) : Integer; CDECL; EXTERNAL;

  FUNCTION libusb_claim_interface
   (handle     : Pointer;
    num        : Integer) : Integer; CDECL; EXTERNAL;

  FUNCTION libusb_interrupt_transfer
   (handle     : Pointer;
    endpoint   : Byte;
    data       : Pointer;
    length     : Integer;
    VAR count  : Integer;
    timeout    : Cardinal) : Integer; CDECL; EXTERNAL;

  FUNCTION libusb_get_device
   (handle     : Pointer) : Pointer; CDECL; EXTERNAL;

  FUNCTION libusb_get_device_descriptor
   (handle     : Pointer;
    VAR data   : DeviceDescriptor) : Integer; CDECL; EXTERNAL;

  FUNCTION libusb_get_string_descriptor_ascii
   (handle     : Pointer;
    index      : Byte;
    VAR data   : ARRAY OF Char;
    length     : Integer) : Integer; CDECL; EXTERNAL;

  CONSTRUCTOR MessengerSubclass.Create
   (vid        : Cardinal;
    pid        : Cardinal;
    serial     : String;
    timeoutms  : Cardinal = 1000;
    iface      : Cardinal = 0;
    epin       : Byte = $81;
    epout      : Byte = $01);

  VAR
    status    : Integer;
    devlist   : ^Pointer;
    devcount  : Integer;
    devindex  : Cardinal;
    dev       : Pointer;
    devdesc   : DeviceDescriptor;
    devhandle : Pointer;
    devserial : ARRAY [0 .. 255] OF Char;

  BEGIN
    Self.handle := Nil;

    IF Length(serial) > 126 THEN
      RAISE Message64.Error.Create('ERROR: serial number parameter is too long');

    { Initialize the libusb internals.  It is safe to call libusb_init() }
    { multiple times.                                                    }

    status := libusb_init(Nil);

    IF status <> LIBUSB_SUCCESS THEN
      RAISE Message64.Error.Create('ERROR: libusb_init() failed');

    { Fetch the list of USB devices }

    devcount := libusb_get_device_list(Nil, @devlist);

    IF devcount < 0 THEN
      RAISE Message64.Error.Create('ERROR: libusb_get_device_list() failed');

    { Iterate over the list of USB devices, looking for matching VID, PID, }
    { and serial number.                                                   }

    devhandle := Nil;

    FOR devindex := 0 TO devcount - 1 DO
      BEGIN
        dev := devlist[devindex];

        { Try to get the device descriptor for this candidate USB device. }

        IF libusb_get_device_descriptor(dev, devdesc) <> LIBUSB_SUCCESS THEN
          CONTINUE;

        { Check for matching VID and PID. }

        IF (vid <> devdesc.idVendor) OR (pid <> devdesc.idProduct) THEN
          CONTINUE;

        { Try to open this candidate USB device.  Not an error if this  }
        { fails (we might not have permission, or the device may not be }
        { available).                                                   }

        IF libusb_open(dev, devhandle) <> LIBUSB_SUCCESS THEN
          CONTINUE;

        { IF no specific serial number was requested, we are done. }

        IF serial = '' THEN
          BREAK;

        { Check whether this candidate USB device has a serial number. }
        { We *MUST* match the requested serial number.                 }

        IF devdesc.iSerialNumber = 0 THEN
          BEGIN
            libusb_close(devhandle);
            devhandle := Nil;
            CONTINUE;
          END;

        { This candidate USB device does indeed have a serial number, }
        { so fetch it.                                                }

        status := libusb_get_string_descriptor_ascii(devhandle,
          devdesc.iSerialNumber, devserial, SizeOf(devserial));

        IF status < 0 THEN
          BEGIN
            libusb_close(devhandle);
            devhandle := Nil;
            CONTINUE;
          END;

        { Check for matching serial number }

        IF serial = devserial THEN
          BREAK;

        { This candidate USB device didn't match, so close it and try again }
        { with the next device on the list.  }

        libusb_close(devhandle);
        devhandle := Nil;
      END;

    libusb_free_device_list(devlist, 1);

    IF devhandle = Nil THEN
      RAISE Message64.Error.Create('ERROR: Unable to find matching device');

    status := libusb_set_auto_detach_kernel_driver(devhandle, 1);

    IF (status <> LIBUSB_SUCCESS) AND (status <> LIBUSB_ERROR_NOT_SUPPORTED) THEN
      RAISE Message64.Error.Create('ERROR: libusb_set_auto_detach_kernel_driver() failed');

    status := libusb_claim_interface(devhandle, iface);

    IF status <> LIBUSB_SUCCESS THEN
      RAISE Message64.Error.Create('libusb_claim_interface() failed');

    Self.handle  := devhandle;
    Self.epin    := epin;
    Self.epout   := epout;
    Self.timeout := timeoutms;
  END;

  DESTRUCTOR MessengerSubclass.Destroy;

  BEGIN
    IF Self.handle <> Nil THEN
      libusb_close(Self.handle);

    INHERITED;
  END;

  PROCEDURE MessengerSubclass.Send(cmd : Message);

  VAR
    status : Integer;
    count  : Integer;

  BEGIN
    status := libusb_interrupt_transfer(Self.handle, Self.epout, @cmd,
      Message64.Size, count, Self.timeout);

    { Handler error conditions }

    IF status = LIBUSB_ERROR_TIMEOUT THEN
      RAISE Message64.Error.Create('ERROR: libusb_interrupt_transfer() timed out')
    ELSE IF status < LIBUSB_SUCCESS THEN
      RAISE Message64.Error.Create('ERROR: libusb_interrupt_transfer() failed')
    ELSE IF (count <> Message64.Size) AND (count <> Message64.Size + 1) THEN
      RAISE Message64.Error.Create('ERROR: Incorrect sent byte count');
  END;

  PROCEDURE MessengerSubclass.Receive(VAR resp : Message);

  VAR
    status : Integer;
    count  : Integer;

  BEGIN
    status := libusb_interrupt_transfer(Self.handle, Self.epin, @resp,
      Message64.Size, count, Self.timeout);

    { Handler error conditions }

    IF status = LIBUSB_ERROR_TIMEOUT THEN
      RAISE Message64.Error.Create('ERROR: libusb_interrupt_transfer() timed out')
    ELSE IF status < LIBUSB_SUCCESS THEN
      RAISE Message64.Error.Create('ERROR: libusb_interrupt_transfer() failed')
    ELSE IF (count <> Message64.Size) AND (count <> Message64.Size + 1) THEN
      RAISE Message64.Error.Create('ERROR: Incorrect received byte count');
  END;

  PROCEDURE MessengerSubclass.Transaction(cmd : Message; VAR resp : Message);

  BEGIN
    Send(cmd);
    Receive(resp);
  END;

  FUNCTION MessengerSubclass.Name : String;

  BEGIN
    Name := Self.Manufacturer + ' ' + Self.Product;
  END;

  FUNCTION MessengerSubclass.Manufacturer : String;

  VAR
    status : Integer;
    desc   : DeviceDescriptor;
    buf    : ARRAY [0 .. 255] OF Char;

  BEGIN
    status := libusb_get_device_descriptor(libusb_get_device(Self.handle), desc);

    IF status <> LIBUSB_SUCCESS THEN
      RAISE Message64.Error.Create('ERROR: libusb_get_device_descriptor() failed');

    IF desc.iManufacturer = 0 THEN
      BEGIN
        Manufacturer := '';
        EXIT;
      END;

    status := libusb_get_string_descriptor_ascii(Self.handle,
      desc.iManufacturer, buf, Length(buf));

    IF status < LIBUSB_SUCCESS THEN
      RAISE Message64.Error.Create('ERROR: libusb_get_string_descriptor_ascii() failed');

    Manufacturer := buf;
  END;

  FUNCTION MessengerSubclass.Product : String;

  VAR
    status : Integer;
    desc   : DeviceDescriptor;
    buf    : ARRAY [0 .. 255] OF Char;

  BEGIN
    status := libusb_get_device_descriptor(libusb_get_device(Self.handle), desc);

    IF status <> LIBUSB_SUCCESS THEN
      RAISE Message64.Error.Create('ERROR: libusb_get_device_descriptor() failed');

    IF desc.iProduct = 0 THEN
      BEGIN
        Product := '';
        EXIT;
      END;

    status := libusb_get_string_descriptor_ascii(Self.handle,
      desc.iProduct, buf, Length(buf));

    IF status < LIBUSB_SUCCESS THEN
      RAISE Message64.Error.Create('ERROR: libusb_get_string_descriptor_ascii() failed');

    Product := buf;
  END;

  FUNCTION MessengerSubclass.SerialNumber : String;

  VAR
    status : Integer;
    desc   : DeviceDescriptor;
    buf    : ARRAY [0 .. 255] OF Char;

  BEGIN
    status := libusb_get_device_descriptor(libusb_get_device(Self.handle), desc);

    IF status <> LIBUSB_SUCCESS THEN
      RAISE Message64.Error.Create('ERROR: libusb_get_device_descriptor() failed');

    IF desc.iSerialNumber = 0 THEN
      BEGIN
        SerialNumber := '';
        EXIT;
      END;

    status := libusb_get_string_descriptor_ascii(Self.handle,
      desc.iSerialNumber, buf, Length(buf));

    IF status < LIBUSB_SUCCESS THEN
      RAISE Message64.Error.Create('ERROR: libusb_get_string_descriptor_ascii() failed');

    SerialNumber := buf;
  END;

{$ifdef Windows}
{$linklib libusb-1.0.dll}
{$else}
{$linklib libusb-1.0}
{$endif}
END.
