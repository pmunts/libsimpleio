-- Fixed length message services implementing using ZeroMQ messaging services
-- Must be instantiated for each message size.

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

WITH ZeroMQ.Sockets;

USE TYPE ZeroMQ.Sockets.Socket;

PACKAGE BODY Messaging.Fixed.ZeroMQ IS

  -- Create a messenger object

  FUNCTION Create
   (sock : NOT NULL Standard.ZeroMQ.Sockets.Socket) RETURN Messaging.Fixed.Messenger IS

  BEGIN
    RETURN NEW MessengerSubclass'(sock => sock);
  END Create;

  -- Initialize a messenger object

  PROCEDURE Initialize
   (Self : IN OUT MessengerSubclass;
    sock : NOT NULL Standard.ZeroMQ.Sockets.Socket) IS

  BEGIN
    Self.Destroy;
    Self.sock := sock;
  END Initialize;

  -- Destroy a messenger object

  PROCEDURE Destroy
   (Self : IN OUT MessengerSubclass) IS

  BEGIN
    IF Self.sock /= NULL THEN
      Self.sock.Destroy;
      Self.sock := NULL;
    END IF;
  END Destroy;

  -- Send a message

  PROCEDURE Send
   (Self : MessengerSubclass;
    msg  : Message) IS

    count : Natural;

  BEGIN
    Self.sock.Send(msg'Address, msg'Length, count);

    IF count /= msg'Length THEN
      RAISE Messaging.Length_Error WITH "Incorrect send byte count";
    END IF;
  END Send;

  -- Receive a message

  PROCEDURE Receive
   (Self : MessengerSubclass;
    msg  : OUT Message) IS

    count : Natural;

  BEGIN
    Self.sock.Receive(msg'Address, msg'Length, count);

    IF count /= msg'Length THEN
      RAISE Messaging.Length_Error WITH "Incorrect receive byte count";
    END IF;
  END Receive;

END Messaging.Fixed.ZeroMQ;
