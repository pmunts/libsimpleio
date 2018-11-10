-- 64-byte message services using the raw HID services in libhidapi

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

WITH System;
WITH Interfaces.C.Strings;

USE TYPE Interfaces.C.Strings.chars_ptr;

PACKAGE BODY HID.hidapi IS
  PRAGMA Link_With("-lhidapi");

  FUNCTION hid_init RETURN Integer;
    PRAGMA Import(C, hid_init);

  FUNCTION hid_open
   (vid : Integer;
    pid : Integer;
    ser : Interfaces.C.Strings.chars_ptr) RETURN Interfaces.C.Strings.chars_ptr;
    PRAGMA Import(C, hid_open);

  FUNCTION hid_write
   (handle : Interfaces.C.Strings.chars_ptr;
    buf    : System.Address;
    len    : Integer) RETURN Integer;
    PRAGMA Import(C, hid_write);

  FUNCTION hid_read
   (handle : Interfaces.C.Strings.chars_ptr;
    buf    : System.Address;
    len    : Integer) RETURN Integer;
    PRAGMA Import(C, hid_read);

  -- Constructor using HID vendor and product ID's

  FUNCTION Create
   (vid       : Standard.HID.Vendor;
    pid       : Standard.HID.Product;
    timeoutms : Integer := 1000) RETURN Message64.Messenger IS

    status : Integer;
    handle : Interfaces.C.Strings.chars_ptr;

  BEGIN
    status := hid_init;

    IF status /= 0 THEN
      RAISE HID_Error WITH "hid_init() failed";
    END IF;

    handle := hid_open(Integer(vid), Integer(pid), Interfaces.C.Strings.Null_Ptr);

    IF handle = Interfaces.C.Strings.Null_Ptr THEN
      RAISE HID_Error WITH "hid_open() failed";
    END IF;

    RETURN NEW MessengerSubclass'(handle => handle);
  END Create;

  -- Send a message

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message64.Message) IS

    status : Integer;

  BEGIN
    status := hid_write(Self.handle, msg'Address, msg'Length);

    IF status /= msg'Length THEN
      RAISE HID_Error WITH "hid_write() failed, status =" & Integer'Image(status);
    END IF;
  END Send;

  -- Receive a message

  PROCEDURE Receive
   (Self : MessengerSubclass;
    msg  : OUT Message64.Message) IS

    status : Integer;

  BEGIN
    status := hid_read(Self.handle, msg'Address, msg'Length);

    IF status /= msg'Length THEN
      RAISE HID_Error WITH "hid_read() failed, status =" & Integer'Image(status);
    END IF;
  END Receive;

END HID.hidapi;
