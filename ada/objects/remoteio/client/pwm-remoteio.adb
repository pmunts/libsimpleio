-- PWM output services using the Remote I/O Protocol

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

WITH Messaging;
WITH Message64;

USE TYPE Messaging.Byte;

PACKAGE BODY PWM.RemoteIO IS

  -- Configure PWM output

  FUNCTION Create
   (dev  : NOT NULL Standard.RemoteIO.Client.Device;
    num  : Standard.RemoteIO.ChannelNumber;
    freq : Positive := 50;
    duty : DutyCycle := MinimumDutyCycle) RETURN PWM.Output IS

    period : CONSTANT Positive := 1000000000/freq;
    cmd    : Message64.Message;
    resp   : Message64.Message;
    self   : PWM.Output;

  BEGIN

    -- Configure the PWM output channel

    cmd    := (OTHERS => 0);
    cmd(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.PWM_CONFIGURE_REQUEST));
    cmd(2) := Messaging.Byte(num);

    cmd(3) := Messaging.Byte(period/16777216);
    cmd(4) := Messaging.Byte(period/65536 MOD 256);
    cmd(5) := Messaging.Byte(period/256 MOD 256);
    cmd(6) := Messaging.Byte(period MOD 256);

    dev.Transaction(cmd, resp);

    -- Set initial PWM output duty cycle

    self := NEW OutputSubclass'(dev, num, period);
    self.Put(duty);

    RETURN self;
  END Create;

  -- Set PWM output duty cycle

  PROCEDURE Put
   (Self : IN OUT OutputSubclass;
    duty : DutyCycle) IS

    cmd    : Message64.Message;
    resp   : Message64.Message;
    ontime : Natural;

  BEGIN
    ontime := Natural(Long_Float(duty/100.0)*Long_Float(Self.period));

    cmd    := (OTHERS => 0);
    cmd(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.PWM_WRITE_REQUEST));
    cmd(2) := Messaging.Byte(Self.num);
    cmd(3) := Messaging.Byte(ontime/16777216);
    cmd(4) := Messaging.Byte(ontime/65536 MOD 256);
    cmd(5) := Messaging.Byte(ontime/256 MOD 256);
    cmd(6) := Messaging.Byte(ontime MOD 256);

    Self.dev.Transaction(cmd, resp);
  END Put;

  -- Set PWM output pulse width

  PROCEDURE Put
   (Self   : IN OUT OutputSubclass;
    ontime : Duration) IS

    cmd    : Message64.Message;
    resp   : Message64.Message;

  BEGIN
    cmd    := (OTHERS => 0);
    cmd(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.PWM_WRITE_REQUEST));
    cmd(2) := Messaging.Byte(Self.num);
    cmd(3) := Messaging.Byte(Natural(ontime*1E9)/16777216);
    cmd(4) := Messaging.Byte(Natural(ontime*1E9)/65536 MOD 256);
    cmd(5) := Messaging.Byte(Natural(ontime*1E9)/256 MOD 256);
    cmd(6) := Messaging.Byte(Natural(ontime*1E9) MOD 256);

    Self.dev.Transaction(cmd, resp);
  END Put;

  -- Get PWM output pulse period

  FUNCTION GetPeriod
   (Self : IN OUT OutputSubclass) RETURN Duration IS

  BEGIN
    RETURN Duration(Self.period)/1E9;
  END GetPeriod;

END PWM.RemoteIO;
