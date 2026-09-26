-- MUNTS-0021 River Tech Motor Driver board services

-- Copyright (C)2026, Philip Munts dba Munts Technologies.
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

-- NOTE: A Raspberry Pi cannot drive motor outputs C and D.

WITH Device;
WITH GPIO.libsimpleio;
WITH Motor.PWM;
WITH PWM.libsimpleio;
WITH RaspberryPi;

PACKAGE BODY MUNTS_0021 IS

  -- Map motor output channel to direction output pin

  dirpins : CONSTANT ARRAY (OutputChannels) OF Device.Designator :=
   (RaspberryPi.GPIO19, RaspberryPi.GPIO6);

  -- Map motor output channel to PWM output pin

  pwmpins : CONSTANT ARRAY (OutputChannels) OF Device.Designator :=
   (RaspberryPi.PWM1, RaspberryPi.PWM0);

  FUNCTION Create_Motor_Output
   (channel   : OutputChannels;
    frequency : Positive;
    velocity  : Motor.Velocity := 0.0) RETURN Motor.Output IS

    dirout : GPIO.Pin;
    pwmout : PWM.Output;

  BEGIN
    dirout := GPIO.libsimpleio.Create(dirpins(channel), GPIO.Output);
    pwmout := PWM.libsimpleio.Create(pwmpins(channel), frequency);
    RETURN Motor.PWM.Create(pwmout, dirout, velocity);
  END Create_Motor_Output;

END MUNTS_0021;
