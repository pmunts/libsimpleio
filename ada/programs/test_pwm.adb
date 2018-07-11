-- Test program PWM outputs implemented with kernel and libsimpleio support.

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

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

WITH PWM.libsimpleio;

PROCEDURE test_pwm IS

  chip    : Natural;
  channel : Natural;
  freq    : Positive;

  PWM0 : PWM.Interfaces.Output;

BEGIN
  Put_Line("PWM Output Test");
  New_Line;

  Put("Enter PWM chip number:     ");
  Get(chip);

  Put("Enter PWM channel number:  ");
  Get(channel);

  Put("Enter PWM pulse frequency: ");
  Get(freq);

  -- Create PWM output object

  PWM0 := PWM.libsimpleio.Create(chip, channel, freq);

  -- Sweep the pulse width back and forth

  FOR d IN Integer RANGE 0 .. 100 LOOP
    PWM0.Put(PWM.DutyCycle(d));
    DELAY 0.05;
  END LOOP;

  FOR d IN REVERSE Integer RANGE 0 .. 100 LOOP
    PWM0.Put(PWM.DutyCycle(d));
    DELAY 0.05;
  END LOOP;
END test_pwm;
