-- Abstract interface for fixed length message services (e.g. raw HID)
-- Must be instantiated for each message size.

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

GENERIC

  MessageSize : Natural;

PACKAGE Messaging.Fixed IS

  TYPE MessengerInterface IS INTERFACE;

  TYPE Messenger IS ACCESS ALL MessengerInterface'Class;

  TYPE Message IS ARRAY (Natural RANGE 0 .. MessageSize -1) OF Byte;

  -- Send a message

  PROCEDURE Send
   (self      : MessengerInterface;
    msg       : IN Message) IS ABSTRACT;

  -- Receive a message

  PROCEDURE Receive
   (self      : MessengerInterface;
    msg       : OUT Message) IS ABSTRACT;

  -- Perform a command/response transaction (similar to an RPC call)

  -- Note this is NOT a primitive operation of MessageInterface and its
  -- descendants, and does NOT need to be reimplemented for those descendants

  PROCEDURE Transaction
   (self      : MessengerInterface'Class;
    cmd       : Message;
    resp      : OUT Message;
    timeoutms : Natural);

  -- Retrieve the underlying Linux file descriptor
  -- If no file descriptor is available, return -1.

  FUNCTION fd
   (self      : MessengerInterface) RETURN Integer IS ABSTRACT;

END Messaging.Fixed;
