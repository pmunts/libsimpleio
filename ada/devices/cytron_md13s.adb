-- Cytron MD13S (https://www.cytron.io/p-13amp-6v-30v-dc-motor-driver)
-- Locked Antiphase Motor Driver Support

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

WITH GPIO;
WITH Motor.PWM;

USE TYPE GPIO.Pin;

PACKAGE BODY Cytron_MD13S IS

  -- Create motor driver instance

  FUNCTION Create
   (pwmout    : NOT NULL PWM.Output;
    enablepin : NOT NULL GPIO.Pin;
    velo      : Motor.Velocity := 0.0;
    enabled   : Boolean := True) RETURN Device IS

    Self : DeviceClass;

  BEGIN
    Self.Initialize(pwmout, enablepin, velo, enabled);
    RETURN NEW DeviceClass'(Self);
  END Create;

  -- Create motor driver instance

  FUNCTION Create
   (pwmout    : NOT NULL PWM.Output;
    enablepin : NOT NULL GPIO.Pin;
    velo      : Motor.Velocity := 0.0;
    enabled   : Boolean := True) RETURN Motor.Output IS

    Self : DeviceClass;

  BEGIN
    Self.Initialize(pwmout, enablepin, velo, enabled);
    RETURN NEW DeviceClass'(Self);
  END Create;

  -- Initialize motor driver instance

  PROCEDURE Initialize
   (Self      : IN OUT DeviceClass;
    pwmout    : NOT NULL PWM.Output;
    enablepin : NOT NULL GPIO.Pin;
    velo      : Motor.Velocity := 0.0;
    enabled   : Boolean := True) IS

  BEGIN
    Self.Destroy;

    Self.outp   := Motor.PWM.Create(pwmout);
    Self.enable := enablepin;
    Self.enable.Put(enabled);
    Self.outp.Put(velo);
  END Initialize;

  -- Destroy an instance

  PROCEDURE Destroy(Self : IN OUT DeviceClass) IS

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    Self.outp   := NULL;
    Self.enable := NULL;
  END Destroy;

  -- Check whether instance has been destroyed

  PROCEDURE CheckDestroyed(Self : DeviceClass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE Error WITH "This instance has been destroyed.";
    END IF;
  END CheckDestroyed;

  -- Motor output method

  PROCEDURE Put
   (Self : IN OUT DeviceClass;
    velo : Motor.Velocity) IS

  BEGIN
    Self.CheckDestroyed;
    Self.outp.Put(velo);
  END Put;

  -- Motor enable method

  PROCEDURE Enable(Self : DeviceClass) IS

  BEGIN
    Self.CheckDestroyed;
    Self.enable.Put(True);
  END Enable;

  -- Motor disable method

  PROCEDURE Disable(Self : DeviceClass) IS

  BEGIN
    Self.CheckDestroyed;
    Self.enable.Put(False);
  END Disable;

END Cytron_MD13S;
