-- 64-byte message services using the raw HID services from libhidapi

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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
   (vid       : HID.Vendor;
    pid       : HID.Product;
    serial    : String  := "";
    timeoutms : Integer := 1000) RETURN Message64.Messenger IS

    m : MessengerSubclass;

  BEGIN
    Initialize(m, vid, pid, serial, timeoutms);
    RETURN NEW MessengerSubclass'(m);
  END Create;

  -- Initializer

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    vid       : HID.Vendor;
    pid       : HID.Product;
    serial    : String  := "";
    timeoutms : Integer := 1000) IS

    handle  : System.Address;

    -- Convert the serial number from string to wchar_t, as needed for hidapi

    wserial : Interfaces.C.wchar_array(0 .. serial'Length) :=
      Interfaces.C.To_C(Ada.Characters.Handling.To_Wide_String(serial));

  BEGIN
    Self.Destroy;

    -- Validate parameters

    IF serial'Length > 126 THEN
      RAISE HID_Error WITH "serial number parameter is too long";
    END IF;

    IF timeoutms < -1 THEN
      RAISE HID_Error WITH "timeoutms parameter is out of range";
    END IF;

    -- Initialize hidapi library

    IF hid_init /= 0 THEN
      RAISE HID_Error WITH "hid_init() failed";
    END IF;

    -- Open device

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

    Self := MessengerSubclass'(handle, timeoutms);
  END Initialize;

  -- Destroyer

  PROCEDURE Destroy(Self : IN OUT MessengerSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    hid_close(Self.handle);

    Self := Destroyed;
  END Destroy;

  -- Send a message

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message64.Message) IS

    outbuf : Messaging.Buffer(0 .. msg'Length);
    status : Integer;

  BEGIN
    Self.CheckDestroyed;

    -- Prepend the report ID byte

    outbuf(0) := 0;
    outbuf(1 .. msg'Length) := msg;

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
    inbuf  : Messaging.Buffer(0 .. msg'Length);

  BEGIN
    Self.CheckDestroyed;

    status := hid_read_timeout(Self.handle, inbuf'Address, inbuf'Length,
      Self.timeout);

    -- Handle the various outcomes

    IF status = inbuf'Length THEN
      msg := inbuf(1 .. msg'Length);
    ELSIF status = msg'Length THEN
      msg := inbuf(0 .. msg'Length - 1);
    ELSIF status = 0 THEN
      RAISE Messaging.Timeout_Error WITH "hid_read_timeout() timed out";
    ELSE
      RAISE HID_Error WITH "hid_read_timeout() failed, status =" &
        Integer'Image(status);
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
    buf    : Interfaces.C.wchar_array(0 .. 255);

  BEGIN
    Self.CheckDestroyed;

    status := hid_get_manufacturer_string(Self.handle, buf, buf'Length);

    IF status /= 0 THEN
      RAISE HID_Error WITH "hid_get_manufacturer_string() failed, status =" &
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
    Self.CheckDestroyed;

    status := hid_get_product_string(Self.handle, buf, buf'Length);

    IF status /= 0 THEN
      RAISE HID_Error WITH "hid_get_product_string() failed, status =" &
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
    Self.CheckDestroyed;

    status := hid_get_serial_number_string(Self.handle, buf, buf'Length);

    IF status /= 0 THEN
      RAISE HID_Error WITH "hid_get_serial_number_string() failed, status =" &
        Integer'Image(status);
    END IF;

    RETURN Ada.Characters.Handling.To_String(Interfaces.C.To_Ada(buf));
  END SerialNumber;

  -- Check whether the HID device has been destroyed

  PROCEDURE CheckDestroyed(Self : MessengerSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE HID_Error WITH "HID device has been destroyed";
    END IF;
  END CheckDestroyed;

END HID.hidapi;
