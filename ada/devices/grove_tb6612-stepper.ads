-- Grove I2C Motor Driver TB6612 Stepper Motor Services

-- Copyright (C)2021-2023, Philip Munts, President, Munts AM Corp.
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

-- See also: https://wiki.seeedstudio.com/Grove-I2C_Motor_Driver-TB6612FNG

-- NOTE: The Grove I2C TB6612 Motor Driver does *NOT* maintain power to the
-- NOTE: stepper motor field windings after a motion command.  This means it is
-- NOTE: *NOT* suitable for applications that require the stepper motor to hold
-- NOTE: a load at the current position!

WITH Stepper;

USE TYPE Stepper.Rate;
USE TYPE Stepper.Steps;

PACKAGE Grove_TB6612.Stepper IS

  -- Grove TB6612 firmware implementation imposed limits

  MAX_STEPS : CONSTANT Standard.Stepper.Steps := +32767;
  MIN_STEPS : CONSTANT Standard.Stepper.Steps := -32767;
  MIN_RATE  : CONSTANT Standard.Stepper.Rate  := 0.01525902;
  MAX_RATE  : CONSTANT Standard.Stepper.Rate  := 1000.0;
  MIN_MSECS : CONSTANT Natural                := 1;
  MAX_MSECS : CONSTANT Natural                := 65535;

  -- NOTE: The Arduino sample code for the Grove I2C TB6612 Motor Driver
  -- NOTE: recommends motion rates less than 150 RPM (500 steps per second for
  -- NOTE: a standard 200-step motor) to avoid skipping steps.  But the board
  -- NOTE: does not seem to *actually* support motion rates faster than about
  -- NOTE: 90 steps per second (27 RPM for a standard 200-step motor).

  -- Grove TB6612 stepper motor modes

  TYPE Modes IS (Full_Step, Wave_Drive, Half_Step, Micro_Stepping);

  -- NOTE: Only Full_Step and Half_Step are recommended.  Wave_Drive is not
  -- NOTE: very useful and Micro_Stepping is not very accurate.

  -- Grove TB6612 rotation directions (nominal, depends on wiring)

  TYPE Directions IS (Clockwise, CounterClockwise);

  -- NOTE: The direction of rotation is nominal, and depends on how the
  -- NOTE: stepper motor field windings are wired.  If the actual direction
  -- NOTE: is backwards, you can just reverse one winding to correct it.

  -- Grove TB6612 stepper motor output type

  TYPE OutputClass IS NEW Standard.Stepper.OutputInterface WITH PRIVATE;

  -- Grove TB6612 stepper motor output output constructor

  FUNCTION Create
   (dev   : NOT NULL Device;
    steps : Standard.Stepper.Steps;
    rate  : Standard.Stepper.Rate;
    mode  : Modes := Full_Step) RETURN Standard.Stepper.Output;

  -- Grove TB6612 stepper motor output initializer

  PROCEDURE Initialize
   (Self  : IN OUT OutputClass;
    dev   : NOT NULL Device;
    steps : Standard.Stepper.Steps;
    rate  : Standard.Stepper.Rate;
    mode  : Modes := Full_Step);

  -- Stepper interface methods

  PROCEDURE Put
   (Self  : IN OUT OutputClass;
    steps : Standard.Stepper.Steps);

  PROCEDURE Put
   (Self  : IN OUT OutputClass;
    steps : Standard.Stepper.Steps;
    rate  : Standard.Stepper.Rate);

  FUNCTION StepsPerRotation(Self : IN OUT OutputClass) RETURN Standard.Stepper.Steps;

  -- Additional methods

  PROCEDURE Spin  -- Begin continuous rotation
   (Self  : OutputClass;
    rate  : Standard.Stepper.Rate);

  PROCEDURE Stop  -- End continuous rotation
   (Self  : OutputClass);

PRIVATE

  TYPE OutputClass IS NEW Standard.Stepper.OutputInterface WITH RECORD
    dev   : Device;
    mode  : Modes;
    steps : Standard.Stepper.Steps;
    rate  : Standard.Stepper.Rate;
  END RECORD;

END Grove_TB6612.Stepper;
