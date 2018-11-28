-- Test program for the Mikroelektronika PWM Click

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

WITH ClickBoard.PWM_Click.libsimpleio;
WITH GPIO;
WITH PCA9685;
WITH PCA9685.GPIO;
WITH PCA9685.PWM;
WITH PCA9685.Servo;
WITH PWM;
WITH Servo;

PROCEDURE test_clickboard_pwm IS

  device  : PCA9685.Device;
  PWM0    : PWM.Interfaces.Output;
  Servo1  : Servo.Interfaces.Output;
  GPIO2   : GPIO.Pin;

BEGIN
  Put_Line("Mikroelektronika PWM Click Test");
  New_Line;

  -- Create PCA9685 device object

  device := ClickBoard.PWM_Click.libsimpleio.Create(socknum => 1,
    frequency => 50);

  -- Create some outputs

  PWM0   := PCA9685.PWM.Create(device, 0);
  Servo1 := PCA9685.Servo.Create(device, 1);
  GPIO2  := PCA9685.GPIO.Create(device, 2);

  -- Sweep back and forth

  FOR d IN Integer RANGE 0 .. 100 LOOP
    PWM0.Put(PWM.DutyCycle(d));
    Servo1.Put(Servo.Position(Float(d - 50)/50.0));
    GPIO2.Put(NOT GPIO2.Get);
    DELAY 0.05;
  END LOOP;

  FOR d IN REVERSE Integer RANGE 0 .. 100 LOOP
    PWM0.Put(PWM.DutyCycle(d));
    Servo1.Put(Servo.Position(Float(d - 50)/50.0));
    GPIO2.Put(NOT GPIO2.Get);
    DELAY 0.05;
  END LOOP;

  Servo1.Put(Servo.NeutralPosition);
END test_clickboard_pwm;
