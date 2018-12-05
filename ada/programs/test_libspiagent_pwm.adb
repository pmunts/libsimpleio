-- Raspberry Pi LPC1114 I/O Processor Expansion Board PMW output test

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

-- NOTE: The button input has the internal pullup resistor enabled, so the
-- switch should be connected from GPIO0 to ground.

WITH Ada.Integer_Text_IO;
WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Interfaces;

WITH errno;
WITH libspiagent;
WITH LPC11xx;
WITH GPIO.libspiagent;
WITH PWM;
WITH PWM.libspiagent;

USE TYPE Interfaces.Integer_32;

PROCEDURE test_libspiagent_pwm IS

  Pins : CONSTANT ARRAY (1 .. 4) OF LPC11xx.pin_id_t :=
    (PWM.libspiagent.PWM1, PWM.libspiagent.PWM2,
     PWM.libspiagent.PWM3, PWM.libspiagent.PWM4);

  error   : Interfaces.Integer_32;
  outputs : ARRAY (Pins'Range) OF PWM.Interfaces.Output;
  freq    : PWM.libspiagent.Frequency;
  index   : Natural RANGE 0 .. Pins'Last;
  duty    : PWM.DutyCycle;

BEGIN
  Put_Line("Raspberry Pi LPC1114 I/O Processor Expansion Board PWM Output Test");
  New_Line;

  -- Open libspiagent

  libspiagent.Open(libspiagent.Localhost, error);

  IF error /= 0 THEN
    RAISE Program_Error WITH "spiagent_open() failed, " &
      errno.strerror(Integer(error));
  END IF;

  -- Configure the PWM pulse frequency

  Put("PWM pulse frequency (50 to 50000):    ");
  PWM.libspiagent.Frequency_IO.Get(freq);
  New_Line;

  PWM.libspiagent.SetFrequency(freq);

  -- Configure PWM outputs

  FOR i IN outputs'RANGE LOOP
    outputs(i) := PWM.libspiagent.Create(Pins(i));
  END LOOP;

  LOOP
    Put("Enter PWM output index (1 to 4):     ");
    Ada.Integer_Text_IO.Get(index);

    EXIT WHEN index = 0;

    Put("Enter PWM duty cycle (0.0 to 100.0): ");
    PWM.DutyCycle_IO.Get(duty);

    outputs(index).Put(duty);
  END LOOP;
END test_libspiagent_pwm;
