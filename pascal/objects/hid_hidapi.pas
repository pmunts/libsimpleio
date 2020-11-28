{ 64-byte message services using HIDAPI raw HID transport                     }

{ Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.             }
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

{ Allowed values for the timeout parameter:                               }
{                                                                         }
{ -1 => Receive operation blocks forever, until a report is received      }
{  0 => Receive operation never blocks at all                             }
{ >0 => Receive operation blocks for the indicated number of milliseconds }

UNIT HID_hidapi;

INTERFACE

  USES
    Message64;

  TYPE
    MessengerSubclass = CLASS(TInterfacedObject, Message64.Messenger)
      CONSTRUCTOR Create(vid : Cardinal; pid : Cardinal; serial : String = '';
        timeoutms : Integer = 1000);

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
      timeout : Integer;
    END;

IMPLEMENTATION

  { Minimal Pascal thin binding to hidapi }

  FUNCTION hid_init : Integer; CDECL; EXTERNAL;

  FUNCTION hid_open
   (vid     : Word;
    pid     : Word;
    serial  : Pointer) : Pointer; CDECL; EXTERNAL;

  PROCEDURE hid_close
   (handle  : Pointer); CDECL; EXTERNAL;

  FUNCTION hid_read_timeout
   (handle  : Pointer;
    buf     : Pointer;
    len     : Cardinal;
    timeout : Integer) : Integer; CDECL; EXTERNAL;

  FUNCTION hid_write
   (handle  : Pointer;
    buf     : Pointer;
    len     : Cardinal) : Integer; CDECL; EXTERNAL;

  FUNCTION hid_get_manufacturer_string
   (handle  : Pointer;
    VAR dst : ARRAY OF WideChar;
    len     : Cardinal) : Integer; CDECL; EXTERNAL;

  FUNCTION hid_get_product_string
   (handle  : Pointer;
    VAR dst : ARRAY OF WideChar;
    len     : Cardinal) : Integer; CDECL; EXTERNAL;

  FUNCTION hid_get_serial_number_string
   (handle  : Pointer;
    VAR dst : ARRAY OF WideChar;
    len     : Cardinal) : Integer; CDECL; EXTERNAL;
 
  CONSTRUCTOR MessengerSubclass.Create(vid : Cardinal; pid : Cardinal;
    serial : String; timeoutms : Integer = 1000);

  VAR
    status   : Integer;
    i        : Cardinal;
{$IFDEF Windows}
    wserial : ARRAY [0 .. 127] OF Word;
{$ELSE}
    wserial : ARRAY [0 .. 127] OF LongWord;
{$ENDIF}

  BEGIN
    IF Length(serial) > 126 THEN
      RAISE Message64.Error.Create('ERROR: serial number parameter is too long');

    IF timeoutms < -1 THEN
      RAISE Message64.Error.Create('ERROR: timeoutms parameter is out of range');

    status := hid_init;

    IF status <> 0 THEN
      RAISE Message64.Error.Create('ERROR: hid_init() failed');

    IF serial = '' THEN
      Self.handle := hid_open(vid, pid, Nil)
    ELSE
      BEGIN
        FillChar(wserial, SizeOf(wserial), 0);

        { Do brute force conversion from string to wide string }

        FOR i := 1 TO Length(serial) DO
          wserial[i-1] := Ord(serial[i]);

        Self.handle := hid_open(vid, pid, @wserial);
      END;

    IF handle = Nil THEN
      RAISE Message64.Error.Create('ERROR: hid_open() failed');

    Self.timeout := timeoutms;
  END;

  DESTRUCTOR MessengerSubclass.Destroy;

  BEGIN
    hid_close(Self.handle);
    INHERITED;
  END;

  PROCEDURE MessengerSubclass.Send(cmd : Message);

  VAR
    outbuf : ARRAY [0 .. Message64.Size] OF Byte;
    index  : Cardinal;
    status : Integer;

  BEGIN
    { Prepend the report ID byte }

    outbuf[0] := 0;

    FOR index := 1 TO Message64.Size DO
      outbuf[index] := cmd[index - 1];

    status := hid_write(Self.handle, Addr(outbuf), Length(outbuf));

    IF (status <> Message64.Size) AND (status <> Length(outbuf)) THEN
      RAISE Message64.Error.Create('ERROR: hid_write() failed');
  END;

  PROCEDURE MessengerSubclass.Receive(VAR resp : Message);

  VAR
    inbuf  : ARRAY [0 .. Message64.Size] OF Byte;
    status : Integer;
    offset : Cardinal;
    index  : Cardinal;

  BEGIN
    status := hid_read_timeout(Self.handle, Addr(inbuf), Length(inbuf),
      Self.timeout);

    IF status = Message64.Size THEN
      offset := 0
    ELSE IF status = Message64.Size + 1 THEN
      offset := 1
    ELSE
      RAISE Message64.Error.Create('ERROR: hid_read() failed');

    FOR index := 0 TO Message64.Size - 1 DO
      resp[index] := inbuf[index + offset];
  END;

  PROCEDURE MessengerSubclass.Transaction(cmd : Message; VAR resp : Message);

  BEGIN
    Send(cmd);
    Receive(resp);
  END;

  FUNCTION MessengerSubclass.Name : String;

  VAR
    status : Integer;
    buf    : ARRAY [0 .. 255] OF Char;

  BEGIN
    Name := Self.Manufacturer + ' ' + Self.Product;
  END;

  FUNCTION MessengerSubclass.Manufacturer : String;

  VAR
    status : Integer;
    buf    : ARRAY [0 .. 255] OF WideChar;

  BEGIN
    FillChar(buf, Sizeof(buf), 0);
    status := hid_get_manufacturer_string(Self.handle, buf, Length(buf));

    IF status <> 0 THEN
      RAISE Message64.Error.Create('ERROR: hid_get_manufacturer_string() failed');

    WideCharLenToStrVar(buf, Length(buf), Manufacturer);
  END;

  FUNCTION MessengerSubclass.Product : String;

  VAR
    status : Integer;
    buf    : ARRAY [0 .. 255] OF WideChar;

  BEGIN
    FillChar(buf, Sizeof(buf), 0);
    status := hid_get_product_string(Self.handle, buf, Length(buf));

    IF status <> 0 THEN
      RAISE Message64.Error.Create('ERROR: hid_get_product_string() failed');

    WideCharLenToStrVar(buf, Length(buf), Product);
  END;

  FUNCTION MessengerSubclass.SerialNumber : String;

  VAR
    status : Integer;
    buf    : ARRAY [0 .. 255] OF WideChar;

  BEGIN
    FillChar(buf, Sizeof(buf), 0);
    status := hid_get_serial_number_string(Self.handle, buf, Length(buf));

    IF status <> 0 THEN
      RAISE Message64.Error.Create('ERROR: hid_get_serial_number_string() failed');

    WideCharLenToStrVar(buf, Length(buf), SerialNumber);
  END;

  {$linklib hidapi}
END.
