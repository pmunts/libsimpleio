-- Test a stepper motor driven with an Allegro A4988 Stepper Motor Driver.

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

WITH A4988;
WITH Device;
WITH GPIO.libsimpleio;
WITH Stepper;

PROCEDURE test_stepper_a4988 IS

  steps    : Stepper.Steps RANGE 1 .. Stepper.Steps'Last;
  rate     : Stepper.Rate;
  StepDesg : Device.Designator;
  DirDesg  : Device.Designator;
  StepPin  : GPIO.Pin;
  DirPin   : GPIO.Pin;
  outp     : Stepper.Output;

BEGIN
  New_Line;
  Put_Line("A4988 Stepper Motor Driver Test");
  New_Line;

  Put("Enter the number of steps per rotation: ");
  Stepper.Steps_IO.Get(steps);

  Put("Enter the default step rate:            ");
  Stepper.Rate_IO.Get(rate);

  Put("Enter STEP signal GPIO chip number:     ");
  Ada.Integer_Text_IO.Get(StepDesg.chip);

  Put("Enter STEP signal GPIO channel number:  ");
  Ada.Integer_Text_IO.Get(StepDesg.chan);

  Put("Enter DIR  signal GPIO chip number:     ");
  Ada.Integer_Text_IO.Get(DirDesg.chip);

  Put("Enter DIR  signal GPIO channel number:  ");
  Ada.Integer_Text_IO.Get(DirDesg.chan);
  New_Line;

  StepPin := GPIO.libsimpleio.Create(StepDesg, GPIO.Output, False);
  DirPin  := GPIO.libsimpleio.Create(DirDesg,  GPIO.Output, False);
  outp    := A4988.Create(steps, rate, StepPin, DirPin);

  LOOP
    Put("Steps: ");
    Stepper.Steps_IO.Get(steps);
    outp.Put(steps);
  END LOOP;
END test_stepper_a4988;
