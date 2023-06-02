-- Continuous Rotation Servo Test

-- Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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

WITH Motor.Servo;
WITH PWM.RemoteIO;
WITH RemoteIO.Client.hidapi;
WITH Servo.PWM;

PROCEDURE test_motor_servo IS

  remdev  : RemoteIO.Client.Device;
  pwmchan : RemoteIO.ChannelNumber;
  outp    : Motor.Output;

BEGIN
  Put_Line("Continuous Rotation Servo Test");
  New_Line;

  -- Open the remote I/O device

  remdev := RemoteIO.Client.hidapi.Create;

  Put("Enter PWM channel number: ");
  Get(pwmchan);

  -- Create motor object

  outp := Motor.Servo.Create(Servo.PWM.Create(PWM.RemoteIO.Create(remdev, pwmchan, 50)));

  -- Sweep the motor velocity back and forth

  FOR d IN Integer RANGE -100 .. 100 LOOP
    outp.Put(Motor.Velocity(Float(d)/100.0));
    DELAY 0.05;
  END LOOP;

  FOR d IN REVERSE Integer RANGE -100 .. 100 LOOP
    outp.Put(Motor.Velocity(Float(d)/100.0));
    DELAY 0.05;
  END LOOP;
END test_motor_servo;
