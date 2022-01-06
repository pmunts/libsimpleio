-- Portable 64-byte message services using services from the Posix package

-- Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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
--  0 => Receive operation blocks forever, until a report is received
-- >0 => Receive operation blocks for the indicated number of milliseconds

WITH Message64;

PACKAGE HID.Posix IS

  TYPE MessengerSubclass IS NEW Message64.MessengerInterface WITH PRIVATE;

  Destroyed : CONSTANT MessengerSubclass;

  -- Constructor using raw HID device node name

  FUNCTION Create
   (name      : String;
    timeoutms : Natural := 1000) RETURN Message64.Messenger;

  -- Constructor using HID vendor and product ID's

  FUNCTION Create
   (vid       : HID.Vendor;
    pid       : HID.Product;
    serial    : String := "";
    timeoutms : Natural := 1000) RETURN Message64.Messenger;

  -- Initializer using raw HID device node name

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    name      : String;
    timeoutms : Natural := 1000);

  -- Initializer using HID vendor and product ID's

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    vid       : HID.Vendor;
    pid       : HID.Product;
    serial    : String := "";
    timeoutms : Natural := 1000);

  -- Destructor

  PROCEDURE Destroy(Self : IN OUT MessengerSubclass);

  -- Send a message

  PROCEDURE Send
   (Self      : MessengerSubclass;
    msg       : IN Message64.Message);

  -- Receive a message

  PROCEDURE Receive
   (Self      : MessengerSubclass;
    msg       : OUT Message64.Message);

PRIVATE

  -- Check whether the HID device has been destroyed

  PROCEDURE CheckDestroyed(Self : MessengerSubclass);

  TYPE MessengerSubclass IS NEW Message64.MessengerInterface WITH RECORD
    fd        : Integer := Integer'First;
    timeoutms : Integer := Integer'First;
  END RECORD;

  Destroyed : CONSTANT MessengerSubclass :=
    MessengerSubclass'(Integer'First, Integer'First);

END HID.Posix;
