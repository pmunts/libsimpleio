-- Remote I/O Server Command Executive Services

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Exceptions;

WITH errno;
WITH Logging.libsimpleio;
WITH Messaging;
WITH RemoteIO.Dispatch;

USE TYPE Messaging.Byte;
USE TYPE RemoteIO.Dispatch.Dispatcher;

PACKAGE BODY RemoteIO.Executive IS

  -- Constructor

  FUNCTION Create RETURN Executor IS

  BEGIN
    RETURN NEW ExecutorClass'(handlers => (OTHERS => NULL));
  END Create;

  -- Register a command handler

  PROCEDURE Register
   (Self    : IN OUT ExecutorClass;
    msgtype : MessageTypes;
    handler : RemoteIO.Dispatch.Dispatcher) IS

  BEGIN
    Self.handlers(msgtype) := handler;
  END Register;

  -- Execute a command

  PROCEDURE Execute
   (Self    : IN OUT ExecutorClass;
    cmd     : Message64.Message;
    resp    : OUT Message64.Message) IS

    msgtype : MessageTypes;

  BEGIN
    -- Check for compeletely out of range message type

    IF cmd(0) > MessageTypes'Pos(MessageTypes'Last) THEN
      resp := (cmd(0) + 1, cmd(1), errno.EINVAL, OTHERS => 0);
      RETURN;
    END IF;

    -- Extract message type from the command message

    msgtype := MessageTypes'Val(cmd(0));

    -- Check for unimplemented message type

    IF Self.handlers(msgtype) = NULL THEN
      resp := (cmd(0) + 1, cmd(1), errno.EINVAL, OTHERS => 0);
      RETURN;
    END IF;

    -- Dispatch the command message to the proper handler

    Self.handlers(msgtype).Dispatch(cmd, resp);

  EXCEPTION
    WHEN Error : OTHERS =>
      Logging.libsimpleio.Error("Caught exception " &
        Ada.Exceptions.Exception_Name(Error) & ": " &
        Ada.Exceptions.Exception_Message(error));

      resp := (cmd(0) + 1, cmd(1), errno.EIO, OTHERS => 0);
  END Execute;

END RemoteIO.Executive;
