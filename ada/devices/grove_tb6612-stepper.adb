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

PACKAGE BODY Grove_TB6612.Stepper IS

  -- Grove TB6612 stepper motor output constructor

  FUNCTION Create
   (dev   : NOT NULL Device;
    steps : Standard.Stepper.Steps;
    rate  : Standard.Stepper.Rate;
    mode  : Modes := Full_Step) RETURN Standard.Stepper.Output IS

    Self : OutputClass;

  BEGIN
    Self.Initialize(dev, steps, rate, mode);
    RETURN NEW OutputClass'(Self);
  END Create;

  -- Grove TB6612 stepper motor output initializer

  PROCEDURE Initialize
   (Self  : IN OUT OutputClass;
    dev   : NOT NULL Device;
    steps : Standard.Stepper.Steps;
    rate  : Standard.Stepper.Rate;
    mode  : Modes := Full_Step) IS

    msecs : Natural;

  BEGIN
    -- Validate parameters

    IF steps < 1 THEN
      RAISE Standard.Stepper.Error WITH "Invalid value for steps per rotation";
    END IF;

    IF rate < MIN_RATE OR rate > MAX_RATE THEN
      RAISE Standard.Stepper.Error WITH "Invalid value for rate";
    END IF;

    msecs := Natural(MAX_RATE/rate);

    IF msecs < MIN_MSECS OR msecs > MAX_MSECS THEN
      RAISE Standard.Stepper.Error WITH "Invalid value for rate";
    END IF;

    Self.dev   := dev;
    Self.mode  := mode;
    Self.steps := steps;
    Self.rate  := rate;
    Self.dev.Enable;
  END Initialize;

  -- Stepper interface methods

  PROCEDURE Put
   (Self  : IN OUT OutputClass;
    steps : Standard.Stepper.Steps) IS

  BEGIN
    Self.Put(steps, Self.rate);
  END Put;

  PROCEDURE Put
   (Self  : IN OUT OutputClass;
    steps : Standard.Stepper.Steps;
    rate  : Standard.Stepper.Rate) IS

    msecs : Natural;
    cmd   : I2C.Command(0 .. 6);

  BEGIN
    IF steps = 0 THEN
      Self.Stop;
      RETURN;
    END IF;

    -- Validate parameters

    IF steps < MIN_STEPS OR steps > MAX_STEPS THEN
      RAISE Standard.Stepper.Error WITH "Invalid value for steps";
    END IF;

    IF rate < MIN_RATE OR rate > MAX_RATE THEN
      RAISE Standard.Stepper.Error WITH "Invalid value for rate";
    END IF;

    msecs := Natural(MAX_RATE/rate);

    IF msecs < MIN_MSECS OR msecs > MAX_MSECS THEN
      RAISE Standard.Stepper.Error WITH "Invalid value for rate";
    END IF;

    -- Build command message

    cmd(0) := CMD_STEPPER_MOVE;
    cmd(1) := I2C.Byte(Modes'Pos(Self.mode));
    cmd(2) := I2C.Byte(IF steps > 0 THEN 1 ELSE 0);
    cmd(3) := I2C.Byte(ABS steps MOD 256);
    cmd(4) := I2C.Byte(ABS steps / 256);
    cmd(5) := I2C.Byte(msecs MOD 256);
    cmd(6) := I2C.Byte(msecs / 256);

    -- Execute command

    Self.dev.Command(cmd);
  END Put;

  FUNCTION StepsPerRotation
   (Self : IN OUT OutputClass) RETURN Standard.Stepper.Steps IS

  BEGIN
    RETURN Self.steps;
  END StepsPerRotation;

  -- Additional methods

  PROCEDURE Spin  -- Continuous rotation
   (Self  : OutputClass;
    rate  : Standard.Stepper.Rate) IS

    msecs : Natural;
    cmd   : I2C.Command(0 .. 4);

  BEGIN
    IF rate = 0.0 THEN
      Self.Stop;
      RETURN;
    END IF;

    -- Validate parameters

    IF ABS rate < MIN_RATE OR ABS rate > MAX_RATE THEN
      RAISE Standard.Stepper.Error WITH "Invalid value for rate";
    END IF;

    msecs := Natural(MAX_RATE/(ABS rate));

    IF msecs < MIN_MSECS OR msecs > MAX_MSECS THEN
      RAISE Standard.Stepper.Error WITH "Invalid value for rate";
    END IF;

    -- Build command message

    cmd(0) := CMD_STEPPER_SPIN;
    cmd(1) := I2C.Byte(Modes'Pos(Self.mode));
    cmd(2) := I2C.Byte(IF rate < 0.0 THEN 4 ELSE 5);
    cmd(3) := I2C.Byte(msecs MOD 256);
    cmd(4) := I2C.Byte(msecs / 256);

    -- Execute command

    Self.dev.Command(cmd);
  END Spin;

  PROCEDURE Stop  -- End continuous rotation
   (Self  : OutputClass) IS

    cmd : I2C.Command(0 .. 0);

  BEGIN
    cmd(0) := CMD_STEPPER_STOP;

    Self.dev.Command(cmd);
  END Stop;

END Grove_TB6612.Stepper;
