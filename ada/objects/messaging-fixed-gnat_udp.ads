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

  -- UDP client (initiator) services

  FUNCTION Create
   (server    : String;
    port      : Positive;
    timeoutms : Integer := 1000) RETURN Messaging.Fixed.Messenger;

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message);

  PROCEDURE Receive
   (Self : MessengerSubclass;
    msg  : OUT Message);

  -- UDP server (responder) services

  TYPE PeerIdentifier IS PRIVATE;

  PROCEDURE Initialize_Server
   (Self      : IN OUT MessengerSubclass;
    netiface  : String := "0.0.0.0"; -- Bind to all available network interfaces
    port      : Positive;
    timeoutms : Integer := 1000);

  PROCEDURE Send_Server
   (Self : MessengerSubclass;
    dst  : PeerIdentifier;
    msg  : Message);

  PROCEDURE Receive_Server
   (Self : MessengerSubclass;
    src  : OUT PeerIdentifier;
    msg  : OUT Message);

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd
   (Self : MessengerSubclass) RETURN Integer;

PRIVATE

  TYPE PeerIdentifier IS NEW GNAT.Sockets.Sock_Addr_type;

  TYPE MessengerSubclass IS NEW MessengerInterface WITH RECORD
    socket : GNAT.Sockets.Socket_Type;
    peer   : GNAT.Sockets.Sock_Addr_type;
  END RECORD;

END Messaging.Fixed.GNAT_UDP;
