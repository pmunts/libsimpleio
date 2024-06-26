-- DAC output services using the Remote I/O Protocol

-- Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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
WITH RemoteIO.Client;

PACKAGE DAC.RemoteIO IS

  TYPE OutputSubclass IS NEW Analog.OutputInterface WITH PRIVATE;

  -- DAC output pin object constructor

  FUNCTION Create
   (dev  : NOT NULL Standard.RemoteIO.Client.Device;
    num  : Standard.RemoteIO.ChannelNumber) RETURN Analog.Output;

  -- Write DAC output pin

  PROCEDURE Put
   (Self : IN OUT OutputSubclass;
    data : Analog.Sample);

  -- Retrieve DAC output resolution

  FUNCTION GetResolution(Self : IN OUT OutputSubclass) RETURN Positive;

PRIVATE

  TYPE OutputSubclass IS NEW Analog.OutputInterface WITH RECORD
    dev         : Standard.RemoteIO.Client.Device;
    num         : Standard.RemoteIO.ChannelNumber;
    resolution  : Positive;
  END RECORD;

END DAC.RemoteIO;
