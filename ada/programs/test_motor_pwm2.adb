-- Motor Output Test using two PWM outputs (CW and CCW)

-- Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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
WITH Motor.PWM;
WITH PWM.libsimpleio;

PROCEDURE test_motor_pwm2 IS

  desgCW  : Device.Designator;
  desgCCW : Device.Designator;
  motor0  : Motor.Output;

BEGIN
  Put_Line("Motor Output Test");
  New_Line;

  Put("Enter PWM chip number:     ");
  Get(desgCW.chip);

  Put("Enter PWM channel number:  ");
  Get(desgCW.chan);

  Put("Enter PWM chip number:     ");
  Get(desgCCW.chip);

  Put("Enter PWM channel number:  ");
  Get(desgCCW.chan);

  -- Create motor output object

  motor0 := Motor.PWM.Create(PWM.libsimpleio.Create(desgCW, 50),
    PWM.libsimpleio.Create(desgCCW, 50));

  -- Sweep the pulse width back and forth

  FOR d IN Integer RANGE -100 .. 100 LOOP
    motor0.Put(Motor.Velocity(Float(d)/100.0));
    DELAY 0.05;
  END LOOP;

  FOR d IN REVERSE Integer RANGE -100 .. 100 LOOP
    motor0.Put(Motor.Velocity(Float(d)/100.0));
    DELAY 0.05;
  END LOOP;
END test_motor_pwm2;
