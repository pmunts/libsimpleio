-- Motor Output Test using PWM (speed) and GPIO (direction) outputs

-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH GPIO.RemoteIO;
WITH Motor.PWM;
WITH PWM.RemoteIO;
WITH RemoteIO.Client.hidapi;

PROCEDURE test_motor_pwm1 IS

  FREQ       : CONSTANT Natural := 10000;
  VELOCITIES : CONSTANT Integer := 500;

  remdev   : RemoteIO.Client.Device;
  pwmchan  : RemoteIO.ChannelNumber;
  gpiochan : RemoteIO.ChannelNumber;
  motor0   : Motor.Output;

BEGIN
  Put_Line("Motor Output Test");
  New_Line;

  -- Open the remote I/O device

  remdev := RemoteIO.Client.hidapi.Create;

  Put("Enter PWM channel number:  ");
  Get(pwmchan);

  Put("Enter GPIO channel number: ");
  Get(gpiochan);

  -- Create motor output object

  motor0 := Motor.PWM.Create(PWM.RemoteIO.Create(remdev, pwmchan, FREQ),
    GPIO.RemoteIO.Create(remdev, gpiochan, GPIO.Output));

  -- Sweep the motor velocity up and down

  FOR v IN Integer RANGE 0 .. VELOCITIES LOOP
    motor0.Put(Motor.Velocity(Float(v)/Float(VELOCITIES)));
    DELAY 0.05;
  END LOOP;

  FOR v IN REVERSE Integer RANGE -VELOCITIES .. VELOCITIES LOOP
    motor0.Put(Motor.Velocity(Float(v)/Float(VELOCITIES)));
    DELAY 0.05;
  END LOOP;

  FOR v IN Integer RANGE -VELOCITIES .. 0 LOOP
    motor0.Put(Motor.Velocity(Float(v)/Float(VELOCITIES)));
    DELAY 0.05;
  END LOOP;
END test_motor_pwm1;
