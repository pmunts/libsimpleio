-- A/D input services using the Remote I/O Protocol

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

WITH Interfaces;

WITH Messaging;
WITH Message64;

USE TYPE Interfaces.Unsigned_32;
USE TYPE Messaging.Byte;

PACKAGE BODY ADC.RemoteIO IS

  -- A/D input pin object constructor

  FUNCTION Create
   (dev  : NOT NULL Standard.RemoteIO.Client.Device;
    num  : Standard.RemoteIO.ChannelNumber) RETURN Analog.Input IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN

    -- Configure the A/D input channel

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.ADC_CONFIGURE_REQUEST));
    cmd(2) := Messaging.Byte(num);

    dev.Transaction(cmd, resp);

    RETURN NEW InputSubclass'(dev, num, Positive(resp(3)));
  END Create;

  -- Read A/D input pin

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Analog.Sample IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.ADC_READ_REQUEST));
    cmd(2) := Messaging.Byte(Self.num);

    Self.dev.Transaction(cmd, resp);

    RETURN Analog.Sample
     (Standard.Interfaces.Shift_Left(Standard.Interfaces.Unsigned_32(resp(3)), 24) +
      Standard.Interfaces.Shift_Left(Standard.Interfaces.Unsigned_32(resp(4)), 16) +
      Standard.Interfaces.Shift_Left(Standard.Interfaces.Unsigned_32(resp(5)),  8) +
      Standard.Interfaces.Unsigned_32(resp(6)));
  END Get;

  -- Retrieve the A/D input resolution

  FUNCTION GetResolution(Self : IN OUT InputSubclass) RETURN Positive IS

  BEGIN
    RETURN Self.resolution;
  END GetResolution;

END ADC.RemoteIO;
