-- Remote I/O Server Dispatcher for I2C commands

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

WITH Device;
WITH I2C.libsimpleio;
WITH Logging;
WITH Message64;
WITH RemoteIO.Dispatch;
WITH RemoteIO.Executive;
WITH RemoteIO.Server;

PACKAGE RemoteIO.I2C IS

  TYPE DispatcherSubclass IS NEW RemoteIO.Dispatch.DispatcherInterface WITH PRIVATE;

  TYPE Dispatcher IS ACCESS DispatcherSubclass;

  FUNCTION Create
   (logger   : Logging.Logger;
    executor : IN OUT RemoteIO.Executive.Executor) RETURN Dispatcher;

  PROCEDURE Dispatch
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.Message);

  -- Register I2C bus by device node name

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    name : String);

  -- Register I2C bus by object access

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    bus  : Standard.I2C.Bus);

PRIVATE

  TYPE BusRec IS RECORD
    bus        : Standard.I2C.Bus;
    registered : Boolean;
  END RECORD;

  TYPE BusArray IS ARRAY (ChannelNumber) OF BusRec;

  TYPE DispatcherSubclass IS NEW RemoteIO.Dispatch.DispatcherInterface WITH RECORD
    logger : Logging.Logger;
    buses  : BusArray;
  END RECORD;

  Unused : CONSTANT BusRec :=
    BusRec'(NULL, False);

END RemoteIO.I2C;
