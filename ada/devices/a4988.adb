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

WITH Ada.Numerics;

WITH Angle;
WITH GPIO;
WITH Stepper;

USE TYPE Angle.Radians;
USE TYPE GPIO.Pin;

PACKAGE BODY A4988 IS

  microseconds : CONSTANT Duration := 1.0E-6;

  -- A4988 device object constructors

  FUNCTION Create
   (NumSteps : Positive;
    Freq     : Positive;
    Step     : GPIO.Pin;
    Dir      : GPIO.Pin;
    Enable   : GPIO.Pin := NULL;
    Reset    : GPIO.Pin := NULL;
    Sleep    : GPIO.Pin := NULL) RETURN Device IS

    dev : DeviceClass;

  BEGIN
    Initialize(dev, NumSteps, Freq, Step, Dir, Enable, Reset, Sleep);
    RETURN NEW DeviceClass'(dev);
  END Create;

  FUNCTION Create
   (NumSteps : Positive;
    Freq     : Positive;
    Step     : GPIO.Pin;
    Dir      : GPIO.Pin;
    Enable   : GPIO.Pin := NULL;
    Reset    : GPIO.Pin := NULL;
    Sleep    : GPIO.Pin := NULL) RETURN Angle.Output IS

    dev : DeviceClass;

  BEGIN
    Initialize(dev, NumSteps, Freq, Step, Dir, Enable, Reset, Sleep);
    RETURN NEW DeviceClass'(dev);
  END Create;

  FUNCTION Create
   (NumSteps : Positive;
    Freq     : Positive;
    Step     : GPIO.Pin;
    Dir      : GPIO.Pin;
    Enable   : GPIO.Pin := NULL;
    Reset    : GPIO.Pin := NULL;
    Sleep    : GPIO.Pin := NULL) RETURN Stepper.Output IS

    dev : DeviceClass;

  BEGIN
    Initialize(dev, NumSteps, Freq, Step, Dir, Enable, Reset, Sleep);
    RETURN NEW DeviceClass'(dev);
  END Create;

  -- A4988 device object initializer

  PROCEDURE Initialize
   (Self     : IN OUT DeviceClass;
    NumSteps : Positive;
    Freq     : Positive;
    Step     : GPIO.Pin;
    Dir      : GPIO.Pin;
    Enable   : GPIO.Pin := NULL;
    Reset    : GPIO.Pin := NULL;
    Sleep    : GPIO.Pin := NULL) IS

    period : CONSTANT Duration := 1.0/Duration(Freq);

  BEGIN
    Self.stepsize   := Angle.Radians(2.0*Ada.Numerics.Pi/Float(NumSteps));
    Self.ontime     := 2.0*microseconds;
    Self.offtime    := period - Self.ontime;
    Self.step_pin   := Step;
    Self.enable_pin := Enable;
    Self.reset_pin  := Reset;
    Self.sleep_pin  := Sleep;

    Self.Reset;
    Self.Wakeup;
    Self.Enable;
  END Initialize;

  -- Angle methods

  PROCEDURE Put
   (Self     : IN OUT DeviceClass;
    theta    : Angle.Radians) IS

  BEGIN
    Self.Put(Stepper.Steps(theta/Self.stepsize + 0.5));
  END Put;

  -- Stepper methods

  PROCEDURE Put
   (Self     : IN OUT DeviceClass;
    numsteps : Stepper.Steps) IS

  BEGIN
    FOR n IN 1 .. numsteps LOOP
      Self.step_pin.Put(True);
      DELAY Self.ontime;
      Self.step_pin.Put(False);
      DELAY Self.offtime;
    END LOOP;
  END Put;

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
    END IF;
  END Wakeup;

END A4988;
