-- 64-byte message services using the raw HID services in libsimpleio

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

WITH Message64;

PACKAGE HID.libsimpleio IS

  TYPE MessengerSubclass IS NEW Message64.MessengerInterface WITH PRIVATE;

  TYPE Messenger IS ACCESS MessengerSubclass;

  Destroyed : CONSTANT MessengerSubclass;

  -- Constructor using raw HID device node name

  FUNCTION Create
   (name      : String;
    timeoutms : Integer := 1000) RETURN Message64.Messenger;

  -- Constructor using HID vendor and product ID's

  FUNCTION Create
   (vid       : HID.Vendor;
    pid       : HID.Product;
    timeoutms : Integer := 1000) RETURN Message64.Messenger;

  -- Constructor using open file descriptor

  FUNCTION Create
   (fd        : Integer;
    timeoutms : Integer := 1000) RETURN Message64.Messenger;

  -- Send a message

  PROCEDURE Send
   (Self      : MessengerSubclass;
    msg       : IN Message64.Message);

  -- Receive a message

  PROCEDURE Receive
   (Self      : MessengerSubclass;
    msg       : OUT Message64.Message);

  -- Get HID device name string

  FUNCTION Name(Self : MessengerSubclass) RETURN String;

  -- Get HID device bus type

  FUNCTION BusType(Self : MessengerSubclass) RETURN Natural;

  -- Get HID device vendor ID

  FUNCTION Vendor(Self : MessengerSubclass) RETURN HID.Vendor;

  -- Get HID device product ID

  FUNCTION Product(Self : MessengerSubclass) RETURN HID.Product;

PRIVATE

  TYPE MessengerSubclass IS NEW Message64.MessengerInterface WITH RECORD
    fd        : Integer;
    timeoutms : Integer;
  END RECORD;

  Destroyed : CONSTANT MessengerSubclass := MessengerSubclass'(-1, -1);

END HID.libsimpleio;
