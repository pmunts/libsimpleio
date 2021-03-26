-- 64-byte message services using the raw HID services from libhidapi

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

-- Allowed values for the timeout parameter:
--
-- -1 => Receive operation blocks forever, until a report is received
--  0 => Receive operation never blocks at all
-- >0 => Receive operation blocks for the indicated number of milliseconds

WITH Message64;

PRIVATE WITH Interfaces.C;
PRIVATE WITH System;

PACKAGE HID.hidapi IS

  -- Type definitions

  TYPE MessengerSubclass IS NEW Message64.MessengerInterface WITH PRIVATE;

  Destroyed : CONSTANT MessengerSubclass;

  -- Constructor

  FUNCTION Create
   (vid       : HID.Vendor;
    pid       : HID.Product;
    serial    : String  := "";
    timeoutms : Integer := 1000) RETURN Message64.Messenger;

  -- Initializer

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    vid       : HID.Vendor;
    pid       : HID.Product;
    serial    : String  := "";
    timeoutms : Integer := 1000);

  -- Destroyer

  PROCEDURE Destroy(Self : IN OUT MessengerSubclass);

  -- Send a message

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message64.Message);

  -- Receive a message

  PROCEDURE Receive
   (Self : MessengerSubclass;
    msg  : OUT Message64.Message);

  -- Get HID device name string

  FUNCTION Name(Self : MessengerSubclass) RETURN String;

  -- Get HID device manufacturer string

  FUNCTION Manufacturer
   (Self : MessengerSubclass) RETURN String;

  -- Get HID device product string

  FUNCTION Product
   (Self : MessengerSubclass) RETURN String;

  -- Get HID device serial number string

  FUNCTION SerialNumber
   (Self : MessengerSubclass) RETURN String;

PRIVATE

  -- Check whether the HID device has been destroyed

  PROCEDURE CheckDestroyed(Self : MessengerSubclass);

  TYPE MessengerSubclass IS NEW Message64.MessengerInterface WITH RECORD
    handle  : System.Address := System.Null_Address;
    timeout : Integer        := Integer'First;
  END RECORD;

  Destroyed : CONSTANT MessengerSubclass :=
    MessengerSubclass'(System.Null_Address, Integer'First);

  -- Minimal Ada thin binding to hidapi

  FUNCTION hid_init RETURN Integer;

  FUNCTION hid_open
   (vid     : Interfaces.C.unsigned_short;
    pid     : Interfaces.C.unsigned_short;
    serial  : System.Address) RETURN System.Address;

  PROCEDURE hid_close
   (handle  : System.Address);

  FUNCTION hid_read_timeout
   (handle  : System.Address;
    buf     : System.Address;
    len     : Interfaces.C.size_t;
    timeout : Integer) RETURN Integer;

  FUNCTION hid_write
   (handle  : System.Address;
    buf     : System.Address;
    len     : Interfaces.C.size_t) RETURN Integer;

  FUNCTION hid_get_manufacturer_string
   (handle  : System.Address;
    buf     : OUT Interfaces.C.wchar_array;
    len     : Interfaces.C.size_t) RETURN Integer;

  FUNCTION hid_get_product_string
   (handle  : System.Address;
    buf     : OUT Interfaces.C.wchar_array;
    len     : Interfaces.C.size_t) RETURN Integer;

  FUNCTION hid_get_serial_number_string
   (handle  : System.Address;
    buf     : OUT Interfaces.C.wchar_array;
    len     : Interfaces.C.size_t) RETURN Integer;

  PRAGMA Import(C, hid_init);
  PRAGMA Import(C, hid_open);
  PRAGMA Import(C, hid_close);
  PRAGMA Import(C, hid_read_timeout);
  PRAGMA Import(C, hid_write);
  PRAGMA Import(C, hid_get_manufacturer_string);
  PRAGMA Import(C, hid_get_product_string);
  PRAGMA Import(C, hid_get_serial_number_string);

  PRAGMA Link_With("-lhidapi");

END HID.hidapi;
