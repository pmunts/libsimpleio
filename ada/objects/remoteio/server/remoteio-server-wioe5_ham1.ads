-- Remote I/O Server Services using Wio_E5.Ham1 transport

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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
WITH Wio_E5.Ham1;

PACKAGE RemoteIO.Server.WioE5_Ham1 IS

  PACKAGE driver IS NEW Wio_E5.Ham1(Message64.Message'Length);

  TYPE InstanceSubclass IS NEW InstanceInterface WITH PRIVATE;

  -- Constructors

  FUNCTION Create
   (exec : NOT NULL RemoteIO.Executive.Executor;
    name : String := "Wio-E5 Ham1";
    dev  : NOT NULL driver.Device := driver.Create) RETURN Instance;

PRIVATE

  TASK TYPE MessageHandlerTask IS
    ENTRY SetName(name : String);
    ENTRY SetExecutor(exec : RemoteIO.Executive.Executor);
    ENTRY SetDevice(dev : driver.Device);
  END MessageHandlerTask;

  TYPE MessageHandlerAccess IS ACCESS MessageHandlerTask;

  TYPE InstanceSubclass IS NEW InstanceInterface WITH RECORD
    MessageHandler : MessageHandlerAccess;
  END RECORD;

END RemoteIO.Server.WioE5_Ham1;
