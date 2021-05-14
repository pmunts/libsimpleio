-- Test a stepper motor driven with a Grove TB6612 Motor Driver

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

WITH Ada.Command_Line;
WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

WITH I2C.libsimpleio;
WITH Grove_TB6612.Stepper;
WITH Stepper;

USE TYPE Stepper.Steps;

PROCEDURE test_grove_tb6612_stepper_spin IS

  bus   : I2C.Bus;
  dev   : Grove_TB6612.Device;
  outp  : Grove_TB6612.Stepper.OutputClass;
  rate  : Stepper.Rate;

BEGIN
  New_Line;
  Put_Line("Grove TB6612 Stepper Motor Spin Test");
  New_Line;

  IF Ada.Command_Line.Argument_Count /= 2 THEN
    Put_Line("Usage: test_grove_tb6612_stepper_spin <bus> <addr>");
    New_Line;
    RETURN;
  END IF;

  -- Create I2C bus object

  bus := I2C.libsimpleio.Create(Ada.Command_Line.Argument(1));

  -- Create Grove TB6612 device object

  dev := Grove_TB6612.Create(bus, I2C.Address'Value(Ada.Command_Line.Argument(2)));

  -- Initialize Grove TB6612 stepper motor object

  outp.Initialize(dev, 100, 100.0);

  LOOP
    Put("Rate: ");
    Stepper.Rate_IO.Get(rate);
    outp.Spin(rate);
  END LOOP;
END test_grove_tb6612_stepper_spin;
