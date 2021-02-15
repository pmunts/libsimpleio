-- Remote I/O Server Dispatcher for DAC commands

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

WITH Analog;
WITH Device;
WITH Message64;
WITH RemoteIO.Dispatch;
WITH RemoteIO.Executive;

PRIVATE WITH DAC.libsimpleio;

PACKAGE RemoteIO.DAC IS

  TYPE DispatcherSubclass IS NEW RemoteIO.Dispatch.DispatcherInterface WITH PRIVATE;

  TYPE Dispatcher IS ACCESS DispatcherSubclass;

  FUNCTION Create
   (executor : NOT NULL RemoteIO.Executive.Executor) RETURN Dispatcher;

  -- Register DAC output by device designator

  PROCEDURE Register
   (Self       : IN OUT DispatcherSubclass;
    num        : ChannelNumber;
    desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution);

  -- Register DAC output by preconfigured object access

  PROCEDURE Register
   (Self   : IN OUT DispatcherSubclass;
    num    : ChannelNumber;
    output : NOT NULL Analog.Output);

  PROCEDURE Dispatch
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.Message);

PRIVATE

  TYPE OutputRec IS RECORD
    registered  : Boolean;
    configured  : Boolean;
    desg        : Device.Designator;
    obj         : ALIASED Standard.DAC.libsimpleio.OutputSubclass;
    output      : Analog.Output;
    resolution  : Natural;
  END RECORD;

  TYPE OutputTable IS ARRAY (ChannelNumber) OF OutputRec;

  TYPE DispatcherSubclass IS NEW RemoteIO.Dispatch.DispatcherInterface WITH RECORD
    outputs : OutputTable;
  END RECORD;

  Unused : CONSTANT OutputRec :=
    OutputRec'(False, False, Device.Unavailable,
    Standard.DAC.libsimpleio.Destroyed, NULL, 0);

END RemoteIO.DAC;
