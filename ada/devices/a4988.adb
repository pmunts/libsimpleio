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
-- dedicated real-time hardware, such as a microcontroller.

WITH Ada.Calendar;

WITH GPIO;
WITH Stepper;

USE TYPE Ada.Calendar.Time;
USE TYPE GPIO.Pin;
USE TYPE Stepper.Rate;
USE TYPE Stepper.Steps;

PACKAGE BODY A4988 IS

  microseconds : CONSTANT Duration := 1.0E-6;
  milliseconds : CONSTANT Duration := 1.0E-3;

  -- A4988 device object constructors

  FUNCTION Create
   (Steps  : Stepper.Steps; -- Number of steps per rotation
    Rate   : Stepper.Rate;  -- Default step rate (Hertz)
    Step   : NOT NULL GPIO.Pin;
    Dir    : NOT NULL GPIO.Pin;
    Enable : GPIO.Pin := NULL;
    Reset  : GPIO.Pin := NULL;
    Sleep  : GPIO.Pin := NULL) RETURN Device IS

    dev : DeviceClass;

  BEGIN
    Initialize(dev, Steps, Rate, Step, Dir, Enable, Reset, Sleep);
    RETURN NEW DeviceClass'(dev);
  END Create;

  FUNCTION Create
   (Steps  : Stepper.Steps; -- Number of steps per rotation
    Rate   : Stepper.Rate;  -- Default step rate (Hertz)
    Step   : NOT NULL GPIO.Pin;
    Dir    : NOT NULL GPIO.Pin;
    Enable : GPIO.Pin := NULL;
    Reset  : GPIO.Pin := NULL;
    Sleep  : GPIO.Pin := NULL) RETURN Stepper.Output IS

    dev : DeviceClass;

  BEGIN
    Initialize(dev, Steps, Rate, Step, Dir, Enable, Reset, Sleep);
    RETURN NEW DeviceClass'(dev);
  END Create;

  -- A4988 device object initializer

  PROCEDURE Initialize
   (Self   : IN OUT DeviceClass;
    Steps  : Stepper.Steps; -- Number of steps per rotation
    Rate   : Stepper.Rate;  -- Default step rate (Hertz)
    Step   : NOT NULL GPIO.Pin;
    Dir    : NOT NULL GPIO.Pin;
    Enable : GPIO.Pin := NULL;
    Reset  : GPIO.Pin := NULL;
    Sleep  : GPIO.Pin := NULL) IS

  BEGIN
    -- Validate parameters

    IF Steps < 1 THEN
      RAISE Stepper.Error WITH "Invalid number of steps per rotation";
    END IF;

    IF Rate <= 0.0 THEN
      RAISE Standard.Stepper.Error WITH "Invalid value for rate";
    END IF;

    Step.Put(False);
    Dir.Put(False);

    Self.numsteps   := Steps;
    Self.steprate   := Rate;
    Self.step_pin   := Step;
    Self.dir_pin    := Dir;
    Self.enable_pin := Enable;
    Self.reset_pin  := Reset;
    Self.sleep_pin  := Sleep;

    Self.Reset;
    Self.Disable;
    Self.Sleep;
    Self.Wakeup;
    Self.Enable;
  END Initialize;

  -- Stepper interface methods

  PROCEDURE Put
   (Self     : IN OUT DeviceClass;
    steps    : Stepper.Steps) IS

  BEGIN
    Put(Self, steps, Self.steprate);
  END Put;

  PROCEDURE Put
   (Self     : IN OUT DeviceClass;
    steps    : Stepper.Steps;
    rate     : Stepper.Rate) IS

    interval : CONSTANT Duration := 1.0/Duration(rate);
    nexttime : Ada.Calendar.Time := Ada.Calendar.Clock;

  BEGIN
    -- Validate parameters

    IF Rate <= 0.0 THEN
      RAISE Standard.Stepper.Error WITH "Invalid value for rate";
    END IF;

    IF steps > 0 THEN
      Self.dir_pin.Put(True);  -- Forward (nominal, depends on motor wiring)
    ELSIF steps < 0 THEN
      Self.dir_pin.Put(False); -- Reverse (nominal, depends on motor wiring)
    ELSE
      RETURN;
    END IF;

    -- NOTE: Exact timing for the step pulse train will be determined by the
    -- resolution of the DELAY statement on the target platform.

    FOR n IN 1 .. ABS steps LOOP
      Self.step_pin.Put(True);
      DELAY 2.0*microseconds;  -- Datasheet typical minimum is 1 microsecond
      Self.step_pin.Put(False);

      nexttime := nexttime + interval;
      DELAY nexttime - Ada.Calendar.Clock;
    END LOOP;
  END Put;

  FUNCTION StepsPerRotation(Self : IN OUT DeviceClass) RETURN Stepper.Steps IS

  BEGIN
    RETURN Self.numsteps;
  END StepsPerRotation;

  -- Other methods

  PROCEDURE Enable(Self : DeviceClass) IS

  BEGIN
    IF Self.enable_pin /= NULL THEN
      Self.enable_pin.Put(False);
    END IF;
  END Enable;

  PROCEDURE Disable(Self : DeviceClass) IS

  BEGIN
    IF Self.enable_pin /= NULL THEN
      Self.enable_pin.Put(True);
    END IF;
  END Disable;

  PROCEDURE Reset(Self : DeviceClass) IS

  BEGIN
    IF Self.reset_pin /= NULL THEN
      Self.reset_pin.Put(False);
      DELAY 1.0*microseconds;
      Self.reset_pin.Put(True);
      DELAY 1.0*microseconds;
    END IF;
  END Reset;

  PROCEDURE Sleep(Self : DeviceClass) IS

  BEGIN
    IF Self.sleep_pin /= NULL THEN
      Self.sleep_pin.Put(False);
    END IF;
  END Sleep;

  PROCEDURE Wakeup(Self : DeviceClass) IS

  BEGIN
    IF Self.sleep_pin /= NULL THEN
      Self.sleep_pin.Put(True);
      DELAY 1.0*milliseconds; -- Wait for charge pump to stabilize
    END IF;
  END Wakeup;

END A4988;
