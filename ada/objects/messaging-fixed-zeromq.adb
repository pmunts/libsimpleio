-- Fixed length message services implementing using ZeroMQ messaging services
-- Must be instantiated for each message size.

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

WITH ZeroMQ.Sockets;

PACKAGE BODY Messaging.Fixed.ZeroMQ IS

  -- Initialize a client messenger object

  PROCEDURE Initialize_Client
   (Self      : IN OUT MessengerSubclass;
    ctx       : Standard.ZeroMQ.Context;
    endpoint  : String;
    timeoutms : Natural := 1000) IS

  BEGIN
    Self.sock.Destroy;
    Self.sock.Initialize(ctx, Standard.ZeroMQ.Sockets.Req, timeoutms);
    Self.sock.Connect(endpoint);
  END Initialize_Client;

  -- Initialize a server messenger object

  PROCEDURE Initialize_Server
   (Self      : IN OUT MessengerSubclass;
    ctx       : Standard.ZeroMQ.Context;
    endpoint  : String;
    timeoutms : Natural := 1000) IS

  BEGIN
    Self.sock.Destroy;
    Self.sock.Initialize(ctx, Standard.ZeroMQ.Sockets.Rep, timeoutms);
    Self.sock.bind(endpoint);
  END Initialize_Server;

  -- Destroy a messenger object

  PROCEDURE Destroy
   (Self : IN OUT MessengerSubclass) IS

  BEGIN
    Self.sock.Destroy;
  END Destroy;

  -- Send a message

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message) IS

    count : Natural;

  BEGIN
    Self.sock.Send(msg'Address, msg'Length, count);
  END Send;

  -- Receive a message

  PROCEDURE Receive
   (Self : MessengerSubclass;
    msg  : OUT Message) IS

    count : Natural;

  BEGIN
    Self.sock.Receive(msg'Address, msg'Length, count);
  END Receive;

END Messaging.Fixed.ZeroMQ;
