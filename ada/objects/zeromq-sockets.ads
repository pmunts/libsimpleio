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

WITH System;

WITH ZeroMQ.Context;

PACKAGE ZeroMQ.Sockets IS

  Error : EXCEPTION;

  TYPE Kinds IS (Pair, Pub, Sub, Req, Rep, Dealer, Router, Pull, Push, XPub,
    XSub, Stream, Server, Client, Radio, Dish, Gather, Scatter, Datagram);

  TYPE Socket_Class IS TAGGED PRIVATE;

  TYPE Socket IS ACCESS ALL Socket_Class'Class;

  -- Create a new dynamically allocated ZeroMQ socket object

  FUNCTION Create
   (ctx       : ZeroMQ.Context.Context;
    kind      : Kinds;
    timeoutms : Natural := 0) RETURN Socket;

  -- Initialize a ZeroMQ socket object

  PROCEDURE Initialize
   (Self      : IN OUT Socket_Class;
    ctx       : ZeroMQ.Context.Context;
    kind      : Kinds;
    timeoutms : Natural := 0);

  -- Destroy a ZeroMQ socket object

  PROCEDURE Destroy
   (Self      : IN OUT Socket_Class);

  -- Start a ZeroMQ message server

  PROCEDURE Bind
   (Self      : Socket_Class;
    endpoint  : String);

  -- Connect to a ZeroMQ message server

  PROCEDURE Connect
   (Self      : Socket_Class;
    endpoint  : String);

  -- Receive a message

  PROCEDURE Receive
   (Self      : Socket_Class;
    buf       : System.Address;
    len       : Natural;
    count     : OUT Natural);

  -- Send a message

  PROCEDURE Send
   (Self      : Socket_Class;
    buf       : System.Address;
    len       : Natural;
    count     : OUT Natural);

  FUNCTION To_Endpoint
   (addr      : String;
    port      : Positive;
    transport : String := "tcp") RETURN String;

PRIVATE

  TYPE Socket_Class IS TAGGED RECORD
    addr    : System.Address := System.Null_Address;
    timeout : Natural := 0;
  END RECORD;

END ZeroMQ.Sockets;
