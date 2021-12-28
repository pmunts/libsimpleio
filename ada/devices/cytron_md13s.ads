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
WITH Motor;
WITH PWM;

PACKAGE Cytron_MD13S IS

  Error : EXCEPTION;

  TYPE DeviceClass IS NEW Motor.OutputInterface WITH PRIVATE;
  TYPE Device      IS ACCESS ALL DeviceClass'Class;

  Destroyed : CONSTANT DeviceClass;

  -- Create motor driver instance

  FUNCTION Create
   (pwmout    : NOT NULL PWM.Output;
    enablepin : NOT NULL GPIO.Pin;
    velo      : Motor.Velocity := 0.0;
    enabled   : Boolean := True) RETURN Device;

  -- Create motor driver instance

  FUNCTION Create
   (pwmout    : NOT NULL PWM.Output;
    enablepin : NOT NULL GPIO.Pin;
    velo      : Motor.Velocity := 0.0;
    enabled   : Boolean := True) RETURN Motor.Output;

  -- Initialize motor driver instance

  PROCEDURE Initialize
   (Self      : IN OUT DeviceClass;
    pwmout    : NOT NULL PWM.Output;
    enablepin : NOT NULL GPIO.Pin;
    velo      : Motor.Velocity := 0.0;
    enabled   : Boolean := True);

  -- Destroy an instance

  PROCEDURE Destroy(Self : IN OUT DeviceClass);

  -- Motor output method

  PROCEDURE Put
   (Self : IN OUT DeviceClass;
    velo : Motor.Velocity);

  -- Motor enable method

  PROCEDURE Enable(Self : DeviceClass);

  -- Motor disable method

  PROCEDURE Disable(Self : DeviceClass);

PRIVATE

  -- Check whether instance has been destroyed

  PROCEDURE CheckDestroyed(Self : DeviceClass);

  TYPE DeviceClass IS NEW Motor.OutputInterface WITH RECORD
    outp   : Motor.Output := NULL;
    enable : GPIO.Pin     := NULL;
  END RECORD;

  Destroyed : CONSTANT DeviceClass := DeviceClass'(NULL, NULL);
END Cytron_MD13S;
