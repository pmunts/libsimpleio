-- LPC1114 I/O Processor PWM output services

-- Copyright (C)2019-2021, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY RemoteIO.LPC1114.PWM IS

  -- Configure PWM output with SPIAGENT_CMD_CONFIGURE_PWM_OUTPUT

  FUNCTION Create
   (absdev : NOT NULL RemoteIO.LPC1114.Abstract_Device.Device;
    desg   : Interfaces.Unsigned_32;
    freq   : Positive := 50;
    duty   : Standard.PWM.DutyCycle := Standard.PWM.MinimumDutyCycle)
    RETURN Standard.PWM.Output IS

    cmd  : SPIAGENT_COMMAND_MSG_t;
    resp : SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    cmd.Command := RemoteIO.LPC1114.SPIAGENT_CMD_CONFIGURE_PWM_OUTPUT;
    cmd.Pin     := desg;
    cmd.Data    := Interfaces.Unsigned_32(freq);

    absdev.Operation(cmd, resp);

    cmd.Command := RemoteIO.LPC1114.SPIAGENT_CMD_PUT_PWM;
    cmd.Pin     := desg;
    cmd.Data    := Interfaces.Unsigned_32(655.35*Float(duty));

    absdev.Operation(cmd, resp);

    RETURN NEW OutputSubclass'(absdev, desg, Duration(1.0/Float(freq)));
  END Create;

  -- PWM output methods

  PROCEDURE Put
   (Self   : IN OUT OutputSubclass;
    duty   : Standard.PWM.DutyCycle) IS

    cmd  : SPIAGENT_COMMAND_MSG_t;
    resp : SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    cmd.Command := RemoteIO.LPC1114.SPIAGENT_CMD_PUT_PWM;
    cmd.Pin     := Self.pin;
    cmd.Data    := Interfaces.Unsigned_32(655.35*Float(duty));

    Self.dev.Operation(cmd, resp);
  END Put;

  PROCEDURE Put
   (Self   : IN OUT OutputSubclass;
    ontime : Duration) IS

    cmd  : SPIAGENT_COMMAND_MSG_t;
    resp : SPIAGENT_RESPONSE_MSG_t;

  BEGIN
    cmd.Command := RemoteIO.LPC1114.SPIAGENT_CMD_PUT_PWM;
    cmd.Pin     := Self.pin;
    cmd.Data    :=
      Interfaces.Unsigned_32(Float(ontime)/Float(Self.period)*65535.0);

    Self.dev.Operation(cmd, resp);
  END Put;

  -- Retrieve the configured PWM pulse period

  FUNCTION GetPeriod(Self : IN OUT OutputSubclass) RETURN Duration IS

  BEGIN
    RETURN Self.period;
  END GetPeriod;

END RemoteIO.LPC1114.PWM;
