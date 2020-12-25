-- Remote I/O Server Command Executive Services

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

WITH Message64;
WITH RemoteIO.Dispatch;

PACKAGE RemoteIO.Executive IS

  TYPE ExecutorClass IS TAGGED PRIVATE;

  TYPE Executor IS ACCESS ExecutorClass;

  -- Constructor

  FUNCTION Create RETURN Executor;

  -- Register a command handler

  PROCEDURE Register
   (Self    : IN OUT ExecutorClass;
    msgtype : MessageTypes;
    handler : RemoteIO.Dispatch.Dispatcher);

  -- Execute a command

  PROCEDURE Execute
   (Self    : IN OUT ExecutorClass;
    cmd     : Message64.Message;
    resp    : OUT Message64.Message);

PRIVATE

  TYPE HandlerArray IS ARRAY (MessageTypes) OF RemoteIO.Dispatch.Dispatcher;

  TYPE ExecutorClass IS TAGGED RECORD
    handlers : HandlerArray;
  END RECORD;

END RemoteIO.Executive;
