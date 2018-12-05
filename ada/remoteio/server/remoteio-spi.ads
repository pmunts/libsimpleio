-- Remote I/O Server Dispatcher for SPI commands

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
WITH SPI.libsimpleio;
WITH Logging;
WITH Message64;
WITH RemoteIO.Dispatch;
WITH RemoteIO.Executive;
WITH RemoteIO.Server;

PACKAGE RemoteIO.SPI IS

  TYPE DispatcherSubclass IS NEW RemoteIO.Dispatch.DispatcherInterface WITH PRIVATE;

  TYPE Dispatcher IS ACCESS DispatcherSubclass;

  FUNCTION Create
   (logger   : Logging.Logger;
    executor : IN OUT RemoteIO.Executive.Executor) RETURN Dispatcher;

  PROCEDURE Dispatch
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.Message);

  -- Register SPI slave device by device designator

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    desg : Device.Designator);

  -- Register SPI slave device by preconfigured object access

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    dev  : Standard.SPI.Device);

PRIVATE

  TYPE DeviceRec IS RECORD
    desg       : Device.Designator;
    device     : Standard.SPI.Device;
    registered : Boolean;
    configured : Boolean;
  END RECORD;

  TYPE DeviceTable IS ARRAY (ChannelNumber) OF DeviceRec;

  TYPE DispatcherSubclass IS NEW RemoteIO.Dispatch.DispatcherInterface WITH RECORD
    logger  : Logging.Logger;
    devices : DeviceTable;
  END RECORD;

  Unused : CONSTANT DeviceRec := DeviceRec'(Device.Unavailable, NULL, False, False);

END RemoteIO.SPI;
