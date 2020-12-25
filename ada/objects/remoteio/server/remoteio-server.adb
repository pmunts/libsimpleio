-- Remote I/O Server Services using Message64 transport (e.g. raw HID)

-- Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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
WITH Ada.Strings.Fixed;

WITH Logging.libsimpleio;
WITH Message64;
WITH Messaging;

USE TYPE Message64.Byte;

PACKAGE BODY RemoteIO.Server IS

  TASK BODY MessageHandlerTask IS

    myname    : String(1 .. 80);
    messenger : Message64.Messenger;
    executor  : RemoteIO.Executive.Executor;
    cmd       : Message64.Message;
    resp      : Message64.Message;

  BEGIN

    -- Get objects from the constructor

    ACCEPT SetName(name : String) DO
      Ada.Strings.Fixed.Move(name, myname, Ada.Strings.Right);
    END SetName;

    ACCEPT SetMessenger(msg : Message64.Messenger) DO
      messenger := msg;
    END SetMessenger;

    ACCEPT SetExecutor(exec : RemoteIO.Executive.Executor) DO
      executor := exec;
    END SetExecutor;

    -- Message loop follows

    Logging.libsimpleio.Note(Ada.Strings.Fixed.Trim(myname, Ada.Strings.Right) &
      " Server ready");

    LOOP
      BEGIN
        messenger.Receive(cmd);
        executor.Execute(cmd, resp);
        messenger.Send(resp);

      EXCEPTION
        WHEN Messaging.Timeout_Error =>
          NULL;

        WHEN Error : OTHERS =>
          Logging.libsimpleio.Error("Caught exception " &
            Ada.Exceptions.Exception_Name(Error) & ": " &
            Ada.Exceptions.Exception_Message(error));
      END;
    END LOOP;
  END MessageHandlerTask;

  FUNCTION Create
   (name      : String;
    messenger : Message64.Messenger;
    executor  : RemoteIO.Executive.Executor) RETURN Device IS

    dev : Device;

  BEGIN
    -- Create the message handler task

    dev := Device'(MessageHandler => NEW MessageHandlerTask);

    -- Pass objects to the message handler task

    dev.MessageHandler.SetName(name);
    dev.MessageHandler.SetMessenger(messenger);
    dev.MessageHandler.SetExecutor(executor);

    RETURN dev;
  END Create;

END RemoteIO.Server;
