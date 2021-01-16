-- ZeroMQ (https://zeromq.org) Messaging Services

-- Copyright (C)2020-2021, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Strings.Fixed;
WITH Interfaces.C;
WITH System;

WITH libzmq;
WITH ZeroMQ.Context;

USE TYPE Interfaces.C.int;
USE TYPE System.Address;
USE TYPE ZeroMQ.Context.Context;

PACKAGE BODY ZeroMQ.Sockets IS

  -- Create a new dynamically allocated ZeroMQ socket object

  FUNCTION Create
   (ctx       : ZeroMQ.Context.Context;
    kind      : Kinds;
    timeoutms : Natural := 0) RETURN Socket IS

    addr : System.Address;

  BEGIN
    IF ctx = ZeroMQ.Context.Null_Context THEN
      RAISE Error WITH "Context parameter is NULL";
    END IF;

    addr := libzmq.zmq_socket(ctx.Pointer, Kinds'Pos(kind));

    IF addr = System.Null_Address THEN
      RAISE Error WITH "zmq_socket() failed, " & libzmq.strerror;
    END IF;

    RETURN NEW Socket_Class'(addr, timeoutms);
  END Create;

  -- Initialize a ZeroMQ socket object

  PROCEDURE Initialize
   (Self      : IN OUT Socket_Class;
    ctx       : ZeroMQ.Context.Context;
    kind      : Kinds;
    timeoutms : Natural := 0) IS

  BEGIN
    Self.Destroy;

    IF ctx = ZeroMQ.Context.Null_Context THEN
      RAISE Error WITH "Context parameter is NULL";
    END IF;

    Self.addr := libzmq.zmq_socket(ctx.Pointer, Kinds'Pos(kind));

    IF Self.addr = System.Null_Address THEN
      RAISE Error WITH "zmq_socket() failed, " & libzmq.strerror;
    END IF;

    Self.timeout := timeoutms;
  END Initialize;

  -- Destroy a ZeroMQ socket object

  PROCEDURE Destroy
   (Self      : IN OUT Socket_Class) IS

  BEGIN
    IF Self.addr = System.Null_Address THEN
      Self.timeout := 0;
      RETURN;
    END IF;

    IF libzmq.zmq_close(Self.addr) /= 0 THEN
      RAISE Error WITH "zmq_close() failed, " & libzmq.strerror;
    END IF;

    Self.addr    := System.Null_Address;
    Self.timeout := 0;
  END Destroy;

  -- Start a ZeroMQ message server

 PROCEDURE Bind
   (Self      : Socket_Class;
    endpoint  : String) IS

  BEGIN

    -- Validate parameters

    IF Self.addr = System.Null_Address THEN
      RAISE Error WITH "Socket parameter is NULL";
    END IF;

    IF endpoint = "" THEN
      RAISE Error WITH "Endpoint parameter is empty";
    END IF;

    -- Bind the socket

    IF libzmq.zmq_bind(Self.addr, endpoint & ASCII.Nul) /= 0 THEN
      RAISE Error WITH "zmq_bind() failed, " & libzmq.strerror;
    END IF;
  END Bind;

  -- Connect to a ZeroMQ message server

  PROCEDURE Connect
   (Self      : Socket_Class;
    endpoint  : String) IS

  BEGIN

    -- Validate parameters

    IF Self.addr = System.Null_Address THEN
      RAISE Error WITH "Socket parameter is NULL";
    END IF;

    IF endpoint = "" THEN
      RAISE Error WITH "Endpoint parameter is empty";
    END IF;

    -- Connect to the server

    IF libzmq.zmq_connect(Self.addr, endpoint & ASCII.Nul) /= 0 THEN
      RAISE Error WITH "zmq_connect() failed, " & libzmq.strerror;
    END IF;
  END Connect;

  -- Receive a message

  PROCEDURE Receive
   (Self      : Socket_Class;
    buf       : System.Address;
    len       : Natural;
    count     : OUT Natural) IS

    ret : Interfaces.C.Int;

  BEGIN

    -- Validate parameters

    IF Self.addr = System.Null_Address THEN
      RAISE Error WITH "Socket parameter is NULL";
    END IF;

    IF buf = System.Null_Address THEN
      RAISE Error WITH "Destination buffer paramter is NULL";
    END IF;

    IF len = 0 THEN
      RAISE Error WITH "Destination buffer length parameter is zero";
    END IF;

    -- Receive a message

    ret := libzmq.zmq_recv(Self.addr, buf, Interfaces.C.size_t(len));

    IF ret < 0 THEN
      RAISE Error WITH "zmq_recv() failed, " & libzmq.strerror;
    END IF;

    count := Natural(ret);
  END Receive;

  -- Send a message

  PROCEDURE Send
   (Self      : Socket_Class;
    buf       : System.Address;
    len       : Natural;
    count     : OUT Natural) IS

    ret : Interfaces.C.int;

  BEGIN

    -- Validate parameters

    IF Self.addr = System.Null_Address THEN
      RAISE Error WITH "Socket parameter is NULL";
    END IF;

    IF buf = System.Null_Address THEN
      RAISE Error WITH "Destination buffer paramter is NULL";
    END IF;

    IF len = 0 THEN
      RAISE Error WITH "Destination buffer length parameter is zero";
    END IF;

    -- Send the message

    ret := libzmq.zmq_send(Self.addr, buf, Interfaces.C.size_t(len));

    IF ret < 0 THEN
      RAISE Error WITH "zmq_send() failed, " & libzmq.strerror;
    END IF;

    count := Natural(ret);
  END Send;

  FUNCTION To_Endpoint
   (addr      : String;
    port      : Positive;
    transport : String := "tcp") RETURN String IS

  BEGIN
    RETURN transport & "://" & addr & ":" &
      Ada.Strings.Fixed.Trim(Positive'Image(port), Ada.Strings.Both);
  END To_Endpoint;

END ZeroMQ.Sockets;
