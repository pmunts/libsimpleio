-- Services for the Allegro A4988 Stepper Motor Driver

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

-- NOTE: This package bit-bangs the step signal to the A4988 driver.  For more
-- accurate timing, you should generate the step signal from some kind of
-- dedicated hardware, such as a microcontroller.

WITH Angle;
WITH GPIO;
WITH Stepper;

PACKAGE A4988 IS

  TYPE DeviceClass IS NEW Angle.OutputInterface AND Stepper.OutputInterface WITH PRIVATE;

  TYPE Device IS ACCESS ALL DeviceClass'Class;

  -- A4988 device object constructors

  FUNCTION Create
   (NumSteps : Positive;
    Freq     : Positive;
    Step     : GPIO.Pin;
    Dir      : GPIO.Pin;
    Enable   : GPIO.Pin := NULL;
    Reset    : GPIO.Pin := NULL;
    Sleep    : GPIO.Pin := NULL) RETURN Device;

  FUNCTION Create
   (NumSteps : Positive;
    Freq     : Positive;
    Step     : GPIO.Pin;
    Dir      : GPIO.Pin;
    Enable   : GPIO.Pin := NULL;
    Reset    : GPIO.Pin := NULL;
    Sleep    : GPIO.Pin := NULL) RETURN Angle.Output;

  FUNCTION Create
   (NumSteps : Positive;
    Freq     : Positive;
    Step     : GPIO.Pin;
    Dir      : GPIO.Pin;
    Enable   : GPIO.Pin := NULL;
    Reset    : GPIO.Pin := NULL;
    Sleep    : GPIO.Pin := NULL) RETURN Stepper.Output;

  -- A4988 device object initializer

  PROCEDURE Initialize
   (Self     : IN OUT DeviceClass;
    NumSteps : Positive;
    Freq     : Positive;
    Step     : GPIO.Pin;
    Dir      : GPIO.Pin;
    Enable   : GPIO.Pin := NULL;
    Reset    : GPIO.Pin := NULL;
    Sleep    : GPIO.Pin := NULL);

  -- Angle methods

  PROCEDURE Put
   (Self     : IN OUT DeviceClass;
    theta    : Angle.Radians);

  -- Stepper methods

  PROCEDURE Put
   (Self     : IN OUT DeviceClass;
    numsteps : Stepper.Steps);

  -- Other methods

  PROCEDURE Enable(Self : DeviceClass);

  PROCEDURE Disable(Self : DeviceClass);

  PROCEDURE Reset(Self : DeviceClass);

  PROCEDURE Sleep(Self : DeviceClass);

  PROCEDURE Wakeup(Self : DeviceClass);

PRIVATE

  TYPE DeviceClass IS NEW Angle.OutputInterface AND Stepper.OutputInterface WITH RECORD
    stepsize   : Angle.Radians;
    ontime     : Duration;
    offtime    : Duration;
    step_pin   : GPIO.Pin;
    dir_pin    : GPIO.Pin;
    enable_pin : GPIO.Pin;
    reset_pin  : GPIO.Pin;
    sleep_pin  : GPIO.Pin;
  END RECORD;

END A4988;
