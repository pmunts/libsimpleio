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

WITH Ada.Streams;
WITH GNAT.Sockets;

USE TYPE Ada.Streams.Stream_Element_Offset;
USE TYPE GNAT.Sockets.Sock_Addr_Type;

PACKAGE BODY Messaging.Fixed.GNAT_UDP IS

  -- UDP client

  FUNCTION Create
   (hostname  : String;
    port      : Positive;
    timeoutms : Integer := 1000) RETURN Messenger IS

    socket  : GNAT.Sockets.Socket_Type;
    peer    : GNAT.Sockets.Sock_Addr_Type;

  BEGIN
    BEGIN
      peer.Addr := GNAT.Sockets.Inet_Addr(hostname);
    EXCEPTION
      WHEN GNAT.Sockets.Socket_Error =>
        peer.Addr :=
          GNAT.Sockets.Addresses(GNAT.Sockets.Get_Host_By_Name(hostname));
    END;

    peer.Port := GNAT.Sockets.Port_Type(port);

    GNAT.Sockets.Create_Socket(socket, GNAT.Sockets.Family_Inet,
      GNAT.Sockets.Socket_Datagram);

    IF timeoutms > 0 THEN
      GNAT.Sockets.Set_Socket_Option(socket, GNAT.Sockets.Socket_Level,
        (GNAT.Sockets.Receive_Timeout, Timeout => Duration(timeoutms)/1000.0));
    END IF;

    RETURN NEW MessengerSubclass'(socket, peer);
  END Create;

  PROCEDURE Send(self : MessengerSubclass; msg : Message) IS

    Data : Ada.Streams.Stream_Element_Array(0 .. Message'Length - 1);
    Last : Ada.Streams.Stream_Element_Offset;

  BEGIN
    FOR i IN Data'Range LOOP
      Data(i) := Ada.Streams.Stream_Element(msg(Integer(i)));
    END LOOP;

    GNAT.Sockets.Send_Socket(self.socket, Data, Last, self.peer);
  END Send;

  PROCEDURE Receive(self : MessengerSubclass; msg : OUT Message) IS

    Data : Ada.Streams.Stream_Element_Array(0 .. Message'Length - 1);
    Last : Ada.Streams.Stream_Element_Offset;
    From : GNAT.Sockets.Sock_Addr_Type;

  BEGIN
    GNAT.Sockets.Receive_Socket(self.socket, Data, Last, From);

    IF From /= self.peer THEN
      RAISE GNAT.Sockets.Socket_Error WITH "Message not from peer node";
    END IF;

    FOR i IN Data'Range LOOP
      msg(Integer(i)) := Byte(Data(i));
    END LOOP;
  END Receive;

  FUNCTION fd(self : MessengerSubclass) RETURN Integer IS

  BEGIN
    RETURN GNAT.Sockets.To_C(self.socket);
  END fd;

BEGIN
  GNAT.Sockets.Initialize;
END Messaging.Fixed.GNAT_UDP;
