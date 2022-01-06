-- 64-byte message services using the raw HID services from liblibusb

-- Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

WITH Interfaces.C;
WITH Interfaces.C.Pointers;
WITH System;

WITH Messaging;

USE TYPE Interfaces.C.unsigned_char;
USE TYPE System.Address;

PACKAGE BODY HID.libusb IS

  -- Constructor

  FUNCTION Create
   (vid       : HID.Vendor;
    pid       : HID.Product;
    serial    : String := "";
    timeoutms : Natural := 1000;
    iface     : Natural := 0;
    epin      : Natural := 16#81#;
    epout     : Natural := 16#01#) RETURN Message64.Messenger IS

    Self : MessengerSubclass;

  BEGIN
    Self.Initialize(vid, pid, serial, timeoutms, iface, epin, epout);
    RETURN NEW MessengerSubclass'(Self);
  END Create;

  -- Initializer

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    vid       : HID.Vendor;
    pid       : HID.Product;
    serial    : String := "";
    timeoutms : Natural := 1000;
    iface     : Natural := 0;
    epin      : Natural := 16#81#;
    epout     : Natural := 16#01#) IS

    TYPE DeviceArray IS ARRAY (Natural RANGE <>) OF ALIASED System.Address;

    PACKAGE DevicePointers IS NEW Interfaces.C.Pointers(Natural,
      System.Address, DeviceArray, System.Null_Address);

    status    : Integer;
    devlistp  : DevicePointers.Pointer;
    devhandle : System.Address := System.Null_Address;

  BEGIN
    Self.Destroy;

    -- Validate parameters

    IF serial'Length > 126 THEN
      RAISE HID_Error WITH "serial number parameter is too long";
    END IF;

    -- Initialize the libusb internals.  It is safe to call libusb_init()
    -- multiple times.

    IF libusb_init(System.Null_Address) /= LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_init() failed";
    END IF;

    -- Fetch the list of USB devices.

    IF libusb_get_device_list(System.Null_Address, devlistp'Address) < 0 THEN
      RAISE HID_Error WITH "libusb_get_device_list() failed";
    END IF;

    -- Iterate over the list of USB devices, looking for matching VID, PID,
    -- and serial number.

    DECLARE
      devlist   : CONSTANT DeviceArray := DevicePointers.Value(devlistp);
      devdesc   : DeviceDescriptor;
      devvid    : HID.Vendor;
      devpid    : HID.Product;
      devserial : Interfaces.c.char_array(0 .. 255);

    BEGIN
      FOR dev OF devlist LOOP

        -- Check for the end of the list of USB devices (i.e. NULL).

        IF dev = System.Null_Address THEN
          libusb_free_device_list(devlistp.ALL'Address, 1);
          RAISE HID_Error WITH "Unable to find matching device";
        END IF;

        -- Get the device descriptor for this candidate USB device.

        IF libusb_get_device_descriptor(dev, devdesc) = LIBUSB_SUCCESS THEN

          -- Extract the vendor ID from the device descriptor.

          devvid := HID.Vendor(devdesc(idVendor+1))*256 +
            HID.Vendor(devdesc(idVendor));

          -- Extract the product ID from the device descriptor.

          devpid := HID.Product(devdesc(idProduct+1))*256 +
            HID.Product(devdesc(idProduct));

          -- Check for matching VID and PID.

          IF (VID = devvid) AND (PID = devpid) THEN

            -- Try to open this candidate USB device.  Not an error if this
            -- fails (we might not have permission, or the device may not be
            -- available).

            IF libusb_open(dev, devhandle) = LIBUSB_SUCCESS THEN

              -- If no specific serial number was requested, we are done.

              IF serial = "" THEN
                EXIT;
              END IF;

              -- We *MUST* match the requested serial number.

              IF devdesc(iSerialNumber) /= 0 THEN

                -- This candidate USB device does indeed have a serial number,
                -- so fetch it.

                status := libusb_get_string_descriptor_ascii(devhandle,
                  devdesc(iSerialNumber), devserial, devserial'Length);

                -- If we have a matching serial number, we are done.

                IF serial = Interfaces.C.To_Ada(devserial) THEN
                  EXIT;
                END IF;
              END IF;

              -- This candidate USB device didn't match, for whatever reason,
              -- so close it and try again with the next device on the list.

              libusb_close(devhandle);
            END IF;
          END IF;
        END IF;
      END LOOP;
    END;

    libusb_free_device_list(devlistp.ALL'Address, 1);

    status := libusb_set_auto_detach_kernel_driver(devhandle, 1);

    IF (status /= LIBUSB_SUCCESS) AND (status /= LIBUSB_ERROR_NOT_SUPPORTED) THEN
      RAISE HID_Error WITH "libusb_set_auto_detach_kernel_driver() failed";
    END IF;

    status := libusb_claim_interface(devhandle, iface);

    IF status /= LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_claim_interface() failed";
    END IF;

    Self := MessengerSubclass'(devhandle, Interfaces.C.unsigned_char(epin),
      Interfaces.c.unsigned_char(epout), Interfaces.C.unsigned(timeoutms));
  END Initialize;

  -- Destructor

  PROCEDURE Destroy(Self : IN OUT MessengerSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libusb_close(Self.handle);

    Self := Destroyed;
  END Destroy;

  -- Check whether the HID device has been destroyed

  PROCEDURE CheckDestroyed(Self : MessengerSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE HID_Error WITH "HID device has been destroyed";
    END IF;
  END CheckDestroyed;

  -- Send a message

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message64.Message) IS

    status : Integer;
    count  : Integer;

  BEGIN
    Self.CheckDestroyed;

    status := libusb_interrupt_transfer(Self.handle, Self.epout, msg'Address,
      msg'Length, count, Self.timeout);

    -- Handle error conditions

    IF status = LIBUSB_ERROR_TIMEOUT THEN
      RAISE Messaging.Timeout_Error WITH "libusb_interrupt_transfer() timed out";
    ELSIF status < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_interrupt_transfer() failed";
    ELSIF (count /= msg'Length) AND (count /= msg'Length + 1) THEN
      RAISE Messaging.Length_Error WITH "Incorrect send byte count," &
        Integer'Image(count);
    END IF;
  END Send;

  -- Receive a message

  PROCEDURE Receive
   (Self : MessengerSubclass;
    msg  : OUT Message64.Message) IS

    status : Integer;
    count  : Integer;

  BEGIN
    Self.CheckDestroyed;

    status := libusb_interrupt_transfer(Self.handle, Self.epin, msg'Address,
      msg'Length, count, Self.timeout);

    -- Handle error conditions

    IF status = LIBUSB_ERROR_TIMEOUT THEN
      RAISE Messaging.Timeout_Error WITH "libusb_interrupt_transfer() timed out";
    ELSIF status < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_interrupt_transfer() failed";
    ELSIF count /= msg'Length THEN
      RAISE Messaging.Length_Error WITH "Incorrect receive byte count," &
        Integer'Image(count);
    END IF;
  END Receive;

  -- Get HID device name string

  FUNCTION Name(Self : MessengerSubclass) RETURN String IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.Manufacturer & " " & Self.Product;
  END Name;

  -- Get HID device manufacturer string

  FUNCTION Manufacturer
   (Self : MessengerSubclass) RETURN String IS

    status : Integer;
    desc   : DeviceDescriptor;
    data   : Interfaces.c.char_array(0 .. 255);

  BEGIN
    Self.CheckDestroyed;

    status := libusb_get_device_descriptor(libusb_get_device(Self.handle), desc);

    IF status < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_get_device_descriptor() failed";
    END IF;

    IF desc(iManufacturer) = 0 THEN
      RETURN "";
    END IF;

    status := libusb_get_string_descriptor_ascii(Self.handle,
      desc(iManufacturer), data, data'Length);

    IF status < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_get_string_descriptor_ascii() failed";
    END IF;

    IF status = 0 THEN
      RETURN "";
    END IF;

    RETURN Interfaces.C.To_Ada(data);
  END Manufacturer;

  -- Get HID device product string

  FUNCTION Product
   (Self : MessengerSubclass) RETURN String IS

    status : Integer;
    desc   : DeviceDescriptor;
    data   : Interfaces.c.char_array(0 .. 255);

  BEGIN
    Self.CheckDestroyed;

    status := libusb_get_device_descriptor(libusb_get_device(Self.handle), desc);

    IF status < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_get_device_descriptor() failed";
    END IF;

    IF desc(iProduct) = 0 THEN
      RETURN "";
    END IF;

    status := libusb_get_string_descriptor_ascii(Self.handle,
      desc(iProduct), data, data'Length);

    IF status < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_get_string_descriptor_ascii() failed";
    END IF;

    IF status = 0 THEN
      RETURN "";
    END IF;

    RETURN Interfaces.C.To_Ada(data);
  END Product;

  -- Get HID device serial number string

  FUNCTION SerialNumber
   (Self : MessengerSubclass) RETURN String IS

    status : Integer;
    desc   : DeviceDescriptor;
    data   : Interfaces.c.char_array(0 .. 255);

  BEGIN
    Self.CheckDestroyed;

    status := libusb_get_device_descriptor(libusb_get_device(Self.handle), desc);

    IF status < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_get_device_descriptor() failed";
    END IF;

    IF desc(iSerialNumber) = 0 THEN
      RETURN "";
    END IF;

    status := libusb_get_string_descriptor_ascii(Self.handle,
      desc(iSerialNumber), data, data'Length);

    IF status < LIBUSB_SUCCESS THEN
      RAISE HID_Error WITH "libusb_get_string_descriptor_ascii() failed";
    END IF;

    IF status = 0 THEN
      RETURN "";
    END IF;

    RETURN Interfaces.C.To_Ada(data);
  END SerialNumber;

END HID.libusb;
