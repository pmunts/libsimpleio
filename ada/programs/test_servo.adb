-- Test program servo outputs implemented with kernel and libsimpleio support.

-- Copyright (C)2019-2023, Philip Munts dba Munts Technologies.
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
WITH Servo.PWM;

PROCEDURE test_servo IS

  desg   : Device.Designator;
  Servo0 : Servo.Output;

BEGIN
  Put_Line("Servo Output Test");
  New_Line;

  Put("Enter PWM chip number:     ");
  Get(desg.chip);

  Put("Enter PWM channel number:  ");
  Get(desg.chan);

  -- Create servo output object

  Servo0 := Servo.PWM.Create(PWM.libsimpleio.Create(desg, 50));

  -- Sweep the servo back and forth

  FOR d IN -100 .. 100 LOOP
    Servo0.Put(Servo.Position(Float(d)/100.0));
    DELAY 0.05;
  END LOOP;

  FOR d IN REVERSE -100 .. 100 LOOP
    Servo0.Put(Servo.Position(Float(d)/100.0));
    DELAY 0.05;
  END LOOP;
END test_servo;
