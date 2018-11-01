-- Fixed length message services implementing using GNAT.Sockets UDP
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

PRIVATE WITH GNAT.Sockets;

GENERIC

PACKAGE Messaging.Fixed.GNAT_UDP IS

  TYPE MessengerSubclass IS NEW MessengerInterface WITH PRIVATE;

  -- UDP client

  FUNCTION Create
   (hostname  : String;
    port      : Positive;
    timeoutms : Integer := 1000) RETURN Messenger;

  PROCEDURE Send
   (self     : MessengerSubclass;
    msg      : Message);

  PROCEDURE Receive
   (self     : MessengerSubclass;
    msg      : OUT Message);

  PROCEDURE Transaction
   (self     : MessengerSubclass;
    cmd      : IN Message;
    resp     : OUT Message);

  FUNCTION fd
   (self     : MessengerSubclass) RETURN Integer;

PRIVATE

  TYPE MessengerSubclass IS NEW MessengerInterface WITH RECORD
    socket : GNAT.Sockets.Socket_Type;
    peer   : GNAT.Sockets.Sock_Addr_type;
  END RECORD;

END Messaging.Fixed.GNAT_UDP;
