-- PWM output services using the Remote I/O Protocol

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

USE TYPE Message64.Byte;

PACKAGE BODY PWM.RemoteIO IS

  -- Configure PWM output

  FUNCTION Create
   (dev  : Standard.RemoteIO.Client.Device;
    num  : Standard.RemoteIO.ChannelNumber;
    freq : Positive := 50;
    duty : DutyCycle := MinimumDutyCycle) RETURN PWM.Interfaces.Output IS

    period : CONSTANT Positive := 1000000000/freq;
    cmd    : Message64.Message;
    resp   : Message64.Message;
    self   : PWM.Interfaces.Output;

  BEGIN

    -- Configure the PWM output channel

    cmd    := (OTHERS => 0);
    cmd(0) := Message64.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.PWM_CONFIGURE_REQUEST));
    cmd(2) := Message64.Byte(num);

    cmd(3) := Message64.Byte(period/16777216);
    cmd(4) := Message64.Byte(period/65536 MOD 256);
    cmd(5) := Message64.Byte(period/256 MOD 256);
    cmd(6) := Message64.Byte(period MOD 256);

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
    cmd(0) := Message64.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.PWM_WRITE_REQUEST));
    cmd(2) := Message64.Byte(Self.num);
    cmd(3) := Message64.Byte(ontime/16777216);
    cmd(4) := Message64.Byte(ontime/65536 MOD 256);
    cmd(5) := Message64.Byte(ontime/256 MOD 256);
    cmd(6) := Message64.Byte(ontime MOD 256);

    Self.dev.Transaction(cmd, resp);
  END Put;

END PWM.RemoteIO;
