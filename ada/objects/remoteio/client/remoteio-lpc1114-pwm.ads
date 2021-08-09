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

WITH PWM;

PACKAGE RemoteIO.LPC1114.PWM IS

  TYPE OutputSubclass IS NEW Standard.PWM.OutputInterface WITH PRIVATE;

  -- Configure PWM output with SPIAGENT_CMD_CONFIGURE_PWM_OUTPUT

  FUNCTION Create
   (absdev : NOT NULL RemoteIO.LPC1114.Abstract_Device.Device;
    desg   : Interfaces.Unsigned_32;
    freq   : Positive := 50;
    duty   : Standard.PWM.DutyCycle := Standard.PWM.MinimumDutyCycle)
    RETURN Standard.PWM.Output;

  -- PWM output methods

  PROCEDURE Put
   (Self   : IN OUT OutputSubclass;
    duty   : Standard.PWM.DutyCycle);

  PROCEDURE Put
   (Self   : IN OUT OutputSubclass;
    ontime : Duration);

  -- Retrieve the configured PWM pulse period

  FUNCTION GetPeriod(Self : IN OUT OutputSubclass) RETURN Duration;

PRIVATE

  TYPE OutputSubclass IS NEW Standard.PWM.OutputInterface WITH RECORD
    dev    : RemoteIO.LPC1114.Abstract_Device.Device;
    pin    : Interfaces.Unsigned_32;
    period : Duration;
  END RECORD;

END RemoteIO.LPC1114.PWM;
