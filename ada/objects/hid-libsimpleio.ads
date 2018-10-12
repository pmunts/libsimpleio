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

  -- Type definitions

  TYPE MessengerSubclass IS NEW Message64.MessengerInterface WITH PRIVATE;

  -- Constructor using raw HID device node name

  FUNCTION Create
   (name      : String;
    timeoutms : Integer := 1000) RETURN Message64.Messenger;

  -- Constructor using HID vendor and product ID's

  FUNCTION Create
   (vid       : Standard.HID.Vendor;
    pid       : Standard.HID.Product;
    timeoutms : Integer := 1000) RETURN Message64.Messenger;

  -- Send a message (i.e. report) to a HID device

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message64.Message);

  -- Receive a message (i.e. report) from a HID device

  PROCEDURE Receive
   (Self : MessengerSubclass;
    msg  : OUT Message64.Message);

  -- Perform a command/response transaction (similar to an RPC call)

  PROCEDURE Transaction
   (Self      : MessengerSubclass;
    cmd       : IN Message64.Message;
    resp      : OUT Message64.Message);

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd
   (Self : MessengerSubclass) RETURN Integer;

PRIVATE

  TYPE MessengerSubclass IS NEW Message64.MessengerInterface WITH RECORD
    fd      : Integer;
    timeout : Integer;
  END RECORD;

END HID.libsimpleio;
