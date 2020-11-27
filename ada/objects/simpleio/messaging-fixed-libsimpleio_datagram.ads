-- Fixed length message services using libsimpleio file I/O
-- Must be instantiated for each message size.

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

GENERIC

PACKAGE Messaging.Fixed.libsimpleio_datagram IS

  -- Type definitions

  TYPE MessengerSubclass IS NEW MessengerInterface WITH PRIVATE;

  -- Constructor

  FUNCTION Create
   (fd        : Integer;
    timeoutms : Integer := 1000) RETURN Messenger;

  -- Send a message

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message);

  -- Receive a message

  PROCEDURE Receive
   (Self : MessengerSubclass;
    msg  : OUT Message);

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd
   (Self : MessengerSubclass) RETURN Integer;

PRIVATE

  TYPE MessengerSubclass IS NEW MessengerInterface WITH RECORD
    fd        : Integer;
    timeoutms : Integer;
  END RECORD;

END Messaging.Fixed.libsimpleio_datagram;
