-- Remote I/O Server Services using Message64 transport (e.g. raw HID)

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

WITH Message64;
WITH RemoteIO.Executive;

PACKAGE RemoteIO.Server IS

  SUBTYPE ResponseString IS String(1 .. 61);

  -- Define a tagged type for remote I/O server devices

  TYPE Device IS TAGGED PRIVATE;

  -- Constructors

  FUNCTION Create
   (messenger    : Message64.Messenger;
    executor     : RemoteIO.Executive.Executor) RETURN Device;

PRIVATE

  TASK TYPE MessageHandlerTask IS
    ENTRY SetMessenger(msg : Message64.Messenger);
    ENTRY SetExecutor(exec : RemoteIO.Executive.Executor);
  END MessageHandlerTask;

  TYPE MessageHandlerAccess IS ACCESS MessageHandlerTask;

  TYPE Device IS TAGGED RECORD
    MessageHandler : MessageHandlerAccess;
  END RECORD;

END RemoteIO.Server;
