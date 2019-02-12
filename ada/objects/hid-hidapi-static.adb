-- 64-byte message services using the raw HID services from libhidapi
-- without heap

-- Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

USE TYPE System.Address;

PACKAGE BODY HID.hidapi.Static IS

  -- Constructor using HID vendor and product ID's

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    vid       : HID.Vendor  := HID.Munts.VID;
    pid       : HID.Product := HID.Munts.PID;
    serial    : String  := "";
    timeoutms : Integer := 1000) IS

    handle  : System.Address;

    -- Convert the serial number from string to wchar_t, as needed for hidapi

    wserial : Interfaces.C.wchar_array(0 .. serial'Length) :=
      Interfaces.C.To_C(Ada.Characters.Handling.To_Wide_String(serial));

  BEGIN
    Self := Destroyed;

    -- Validate parameters

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

  -- Destructor

  PROCEDURE Destroy(Self : IN OUT MessengerSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    hid_close(Self.handle);

    Self := Destroyed;
  END Destroy;

END HID.hidapi.Static;
