-- DAC output services using the Remote I/O Protocol

-- Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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
WITH Messaging;
WITH Message64;

USE TYPE Analog.Sample;
USE TYPE Messaging.Byte;

PACKAGE BODY DAC.RemoteIO IS

  -- DAC output pin object constructor

  FUNCTION Create
   (dev  : NOT NULL Standard.RemoteIO.Client.Device;
    num  : Standard.RemoteIO.ChannelNumber) RETURN Analog.Output IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN

    -- Configure the DAC output channel

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.DAC_CONFIGURE_REQUEST));
    cmd(2) := Messaging.Byte(num);

    dev.Transaction(cmd, resp);

    RETURN NEW OutputSubclass'(dev, num, Positive(resp(3)));
  END Create;

  -- Write DAC output pin

  PROCEDURE Put
   (Self : IN OUT OutputSubclass;
    data : Analog.Sample) IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.DAC_WRITE_REQUEST));
    cmd(2) := Messaging.Byte(Self.num);

    cmd(3) := Messaging.Byte(data/16777216);
    cmd(4) := Messaging.Byte(data/65536 MOD 256);
    cmd(5) := Messaging.Byte(data/256 MOD 256);
    cmd(6) := Messaging.Byte(data MOD 256);

    Self.dev.Transaction(cmd, resp);
  END Put;

  -- Retrieve the DAC output resolution

  FUNCTION GetResolution(Self : IN OUT OutputSubclass) RETURN Positive IS

  BEGIN
    RETURN Self.resolution;
  END GetResolution;

END DAC.RemoteIO;
