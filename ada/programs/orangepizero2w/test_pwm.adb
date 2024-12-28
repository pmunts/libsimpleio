-- Orange Pi Zero 2W PWM Output Test

-- Copyright (C)2024, Philip Munts dba Munts Technologies.
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

WITH Device;
WITH PWM.libsimpleio;
WITH OrangePiZero2W; USE OrangePiZero2W;

PROCEDURE test_pwm IS

  PWMOutputs : CONSTANT ARRAY (Positive RANGE <>) OF Device.Designator :=
   (PWM1, PWM2, PWM3, PWM4);

  num  : Natural;
  desg : Device.Designator;
  freq : Positive;

  outp : PWM.Output;

BEGIN
  Put_Line("Orange Pi Zero 2W PWM Output Test");
  New_Line;

  Put("Enter PWM output number (1 to 4): ");
  Get(num);

  Put("Enter PWM output pulse frequency: ");
  Get(freq);

  -- Create PWM output object

  desg := PWMOutputs(num);
  outp := PWM.libsimpleio.Create(desg, freq);

  -- Sweep the pulse width back and forth

  FOR d IN 0 .. 100 LOOP
    outp.Put(PWM.DutyCycle(d));
    DELAY 0.05;
  END LOOP;

  FOR d IN REVERSE 0 .. 100 LOOP
    outp.Put(PWM.DutyCycle(d));
    DELAY 0.05;
  END LOOP;
END test_pwm;
