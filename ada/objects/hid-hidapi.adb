-- 64-byte message services using the raw HID services from libhidapi

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Characters.Handling;
WITH System;

WITH Messaging;

USE TYPE System.Address;

PACKAGE BODY HID.hidapi IS

  -- Constructor

  FUNCTION Create
   (vid       : HID.Vendor  := HID.Munts.VID;
    pid       : HID.Product := HID.Munts.PID;
    serial    : String  := "";
    timeoutms : Integer := 1000) RETURN Message64.Messenger IS

    status  : Integer;
    handle  : System.Address;

    -- Convert the serial number from string to wchar_t, as needed for hidapi

    wserial : Interfaces.C.wchar_array(0 .. serial'Length) :=
      Interfaces.C.To_C(Ada.Characters.Handling.To_Wide_String(serial));

  BEGIN

    -- Validate parameters

    IF timeoutms < -1 THEN
      RAISE HID_Error WITH "timeoutms parameter is out of range";
    END IF;

    status := hid_init;

    IF status /= 0 THEN
      RAISE HID_Error WITH "hid_init() failed";
    END IF;

    IF serial = "" THEN
      -- hid_open() wants a null pointer rather than an empty string
      handle := hid_open(Interfaces.C.unsigned_short(vid),
        Interfaces.C.unsigned_short(pid), System.Null_Address);
    ELSE
      handle := hid_open(Interfaces.C.unsigned_short(vid),
        Interfaces.C.unsigned_short(pid), wserial'Address);
    END IF;

    IF handle = System.Null_Address THEN
      RAISE HID_Error WITH "hid_open() failed";
    END IF;

    RETURN NEW MessengerSubclass'(handle, timeoutms);
  END Create;

  -- Send a message

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message64.Message) IS

    outbuf : ARRAY (0 .. msg'Length) OF Message64.Byte;
    status : Integer;

  BEGIN
    -- Prepend the report ID byte

    outbuf(0) := 0;

    FOR i IN msg'Range LOOP
      outbuf(i + 1) := msg(i);
    END LOOP;

    -- Send the report

    status := hid_write(Self.handle, outbuf'Address, outbuf'Length);

    IF status /= outbuf'Length THEN
      RAISE HID_Error WITH "hid_write() failed, status =" &
        Integer'Image(status);
    END IF;
  END Send;

  -- Receive a message

  PROCEDURE Receive
   (Self : MessengerSubclass;
    msg  : OUT Message64.Message) IS

    status : Integer;
    inbuf  : ARRAY (0 .. msg'Length) OF Message64.Byte;
    offset : Natural;

  BEGIN
    status := hid_read_timeout(Self.handle, inbuf'Address, inbuf'Length,
      Self.timeout);

    -- Handle the various outcomes

    IF status = inbuf'Length THEN
      offset := 1;  -- Strip report ID byte
    ELSIF status = msg'Length THEN
      offset := 0;  -- No report ID byte
    ELSIF status = 0 THEN
      RAISE Messaging.Timeout_Error WITH "hid_read() timed out";
    ELSE
      RAISE HID_Error WITH "hid_read() failed, status =" &
        Integer'Image(status);
    END IF;

    -- Copy bytes from the input buffer to the message array

    FOR i IN msg'Range LOOP
      msg(i) := inbuf(i + offset);
    END LOOP;
  END Receive;

  -- Get HID device name string

  FUNCTION Name(Self : MessengerSubclass) RETURN String IS

  BEGIN
    RETURN Self.Manufacturer & " " & Self.Product;
  END Name;

  -- Get HID device manufacturer string

  FUNCTION Manufacturer
   (Self : MessengerSubclass) RETURN String IS

    status : Integer;
    buf    : Interfaces.C.wchar_array(0 .. 255);

  BEGIN
    status := hid_get_manufacturer_string(Self.handle, buf, buf'Length);

    IF status /= 0 THEN
      RAISE HID_Error WITH "hid_read() failed, status =" &
        Integer'Image(status);
    END IF;

    RETURN Ada.Characters.Handling.To_String(Interfaces.C.To_Ada(buf));
  END Manufacturer;

  -- Get HID device product string

  FUNCTION Product
   (Self : MessengerSubclass) RETURN String IS

    status : Integer;
    buf    : Interfaces.C.wchar_array(0 .. 255);

  BEGIN
    status := hid_get_product_string(Self.handle, buf, buf'Length);

    IF status /= 0 THEN
      RAISE HID_Error WITH "hid_read() failed, status =" &
        Integer'Image(status);
    END IF;

    RETURN Ada.Characters.Handling.To_String(Interfaces.C.To_Ada(buf));
  END Product;

  -- Get HID device serial number string

  FUNCTION SerialNumber
   (Self : MessengerSubclass) RETURN String IS

    status : Integer;
    buf    : Interfaces.C.wchar_array(0 .. 255);

  BEGIN
    status := hid_get_serial_number_string(Self.handle, buf, buf'Length);

    IF status /= 0 THEN
      RAISE HID_Error WITH "hid_read() failed, status =" &
        Integer'Image(status);
    END IF;

    RETURN Ada.Characters.Handling.To_String(Interfaces.C.To_Ada(buf));
  END SerialNumber;

END HID.hidapi;
