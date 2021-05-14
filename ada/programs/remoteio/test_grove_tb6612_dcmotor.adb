-- Test a DC motor driven with a Grove TB6612 Motor Driver

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

WITH Grove_TB6612.Motor;
WITH I2C.RemoteIO;
WITH Motor;
WITH RemoteIO.Client.hidapi;

PROCEDURE test_grove_tb6612_dcmotor IS

  bus  : I2C.Bus;
  dev  : Grove_TB6612.Device;
  outp : Motor.Output;

BEGIN
  New_Line;
  Put_Line("Grove TB6612 DC Motor Test");
  New_Line;

  -- Create I2C bus object

  bus := I2C.RemoteIO.Create(RemoteIO.Client.hidapi.Create, 0);

  -- Create Grove TB6612 device object

  dev := Grove_TB6612.Create(bus);

  -- Create motor output object

  outp := Grove_TB6612.Motor.Create(dev, Grove_TB6612.Motor.ChannelA);

  -- Ramp the motor speed up and down

  FOR d IN Integer RANGE 0 .. 255 LOOP
    outp.Put(Motor.Velocity(Float(d)/255.0));
    DELAY 0.05;
  END LOOP;

  FOR d IN REVERSE Integer RANGE -255 .. 255 LOOP
    outp.Put(Motor.Velocity(Float(d)/255.0));
    DELAY 0.05;
  END LOOP;

  FOR d IN Integer RANGE -255 .. 0 LOOP
    outp.Put(Motor.Velocity(Float(d)/255.0));
    DELAY 0.05;
  END LOOP;
END test_grove_tb6612_dcmotor;
