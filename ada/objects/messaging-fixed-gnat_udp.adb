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

  -- UDP client (initiator) constructor

  FUNCTION Create
   (server    : String;
    port      : Positive;
    timeoutms : Integer := 1000) RETURN Messaging.Fixed.Messenger IS

    socket  : GNAT.Sockets.Socket_Type;
    peer    : GNAT.Sockets.Sock_Addr_Type;

  BEGIN
    BEGIN
      peer.Addr := GNAT.Sockets.Inet_Addr(server);
    EXCEPTION
      WHEN GNAT.Sockets.Socket_Error =>
        peer.Addr :=
          GNAT.Sockets.Addresses(GNAT.Sockets.Get_Host_By_Name(server));
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

  -- UDP client (initiator) transmit service

  PROCEDURE Send(Self : MessengerSubclass; msg : Message) IS

    Data : Ada.Streams.Stream_Element_Array(0 .. Message'Length - 1);
    Last : Ada.Streams.Stream_Element_Offset;

  BEGIN
    IF Self.peer = GNAT.Sockets.No_Sock_Addr THEN
      RAISE GNAT.Sockets.Socket_Error WITH "Cannot call this method from server";
    END IF;

    FOR i IN Data'Range LOOP
      Data(i) := Ada.Streams.Stream_Element(msg(Integer(i)));
    END LOOP;

    GNAT.Sockets.Send_Socket(Self.socket, Data, Last, Self.peer);
  END Send;

  -- UDP client (initiator) receive service

  PROCEDURE Receive(Self : MessengerSubclass; msg : OUT Message) IS

    Data : Ada.Streams.Stream_Element_Array(0 .. Message'Length - 1);
    Last : Ada.Streams.Stream_Element_Offset;
    From : GNAT.Sockets.Sock_Addr_Type;

  BEGIN
    IF Self.peer = GNAT.Sockets.No_Sock_Addr THEN
      RAISE GNAT.Sockets.Socket_Error WITH "Cannot call this method from server";
    END IF;

    GNAT.Sockets.Receive_Socket(Self.socket, Data, Last, From);

    IF From /= Self.peer THEN
      RAISE GNAT.Sockets.Socket_Error WITH "Message not from server node";
    END IF;

    FOR i IN Data'Range LOOP
      msg(Integer(i)) := Byte(Data(i));
    END LOOP;
  END Receive;

  -- UDP server (responder) constructor

  FUNCTION Create_Server
   (netiface  : String  := "0.0.0.0"; -- Bind to available network interfaces
    port      : Positive;
    timeoutms : Integer := 1000) RETURN Messenger IS

    iface  : GNAT.Sockets.Sock_Addr_Type;
    socket : GNAT.Sockets.Socket_Type;

  BEGIN
    iface.Addr := GNAT.Sockets.Inet_Addr(netiface);
    iface.Port := GNAT.Sockets.Port_Type(port);

    GNAT.Sockets.Create_Socket(socket, GNAT.Sockets.Family_Inet,
      GNAT.Sockets.Socket_Datagram);

    -- Bind the server socket to network interface(s)

    GNAT.Sockets.Bind_Socket(socket, iface);

    -- Set receive timeout, if requested

    IF timeoutms > 0 THEN
      GNAT.Sockets.Set_Socket_Option(socket, GNAT.Sockets.Socket_Level,
        (GNAT.Sockets.Receive_Timeout, Timeout => Duration(timeoutms)/1000.0));
    END IF;

    RETURN NEW MessengerSubclass'(socket, GNAT.Sockets.No_Sock_Addr);
  END Create_Server;

  -- UDP server (responder) transmit service

  PROCEDURE Send
   (Self : MessengerSubclass;
    dst  : PeerIdentifier;
    msg  : Message) IS

    Data : Ada.Streams.Stream_Element_Array(0 .. Message'Length - 1);
    Last : Ada.Streams.Stream_Element_Offset;
    To   : GNAT.Sockets.Sock_Addr_Type;

  BEGIN
    To := GNAT.Sockets.Sock_Addr_type(dst);

    FOR i IN Data'Range LOOP
      Data(i) := Ada.Streams.Stream_Element(msg(Integer(i)));
    END LOOP;

    GNAT.Sockets.Send_Socket(Self.socket, Data, Last, To);
  END Send;

  -- UDP server (responder) receive service

  PROCEDURE Receive
   (Self : MessengerSubclass;
    src  : OUT PeerIdentifier;
    msg  : OUT Message) IS

    Data : Ada.Streams.Stream_Element_Array(0 .. Message'Length - 1);
    Last : Ada.Streams.Stream_Element_Offset;
    From : GNAT.Sockets.Sock_Addr_Type;

  BEGIN
    GNAT.Sockets.Receive_Socket(Self.socket, Data, Last, From);

    FOR i IN Data'Range LOOP
      msg(Integer(i)) := Byte(Data(i));
    END LOOP;

    src := PeerIdentifier(From);
  END Receive;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : MessengerSubclass) RETURN Integer IS

  BEGIN
    RETURN GNAT.Sockets.To_C(Self.socket);
  END fd;

BEGIN
  GNAT.Sockets.Initialize;
END Messaging.Fixed.GNAT_UDP;
