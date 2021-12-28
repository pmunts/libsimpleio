-- Motor services using PWM and GPIO outputs

-- Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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

WITH PWM;
WITH GPIO;

PACKAGE Motor.PWM IS

  -- Type 1 motor outputs: Consisting of one PWM output for speed and one
  -- GPIO pin for direction control

  TYPE OutputSubclass1 IS NEW Motor.OutputInterface WITH PRIVATE;

  FUNCTION Create
   (pwmout : NOT NULL Standard.PWM.Output;
    dirout : NOT NULL GPIO.Pin;
    velo   : Velocity := 0.0) RETURN Motor.Output;

  PROCEDURE Put
   (Self : IN OUT OutputSubclass1;
    velo : Velocity);

  -- Type 2 motor outputs: Consisting of CW (clockwise) and CCW
  -- (counterclockwise) PWM outputs

  TYPE OutputSubclass2 IS NEW Motor.OutputInterface WITH PRIVATE;

  FUNCTION Create
   (cwout  : NOT NULL Standard.PWM.Output;
    ccwout : NOT NULL Standard.PWM.Output;
    velo   : Velocity := 0.0) RETURN Motor.Output;

  PROCEDURE Put
   (Self : IN OUT OutputSubclass2;
    velo : Velocity);

  -- Type 3 motor outputs: Consisting of one PWM output, driving a locked
  -- antiphase motor driver

  TYPE OutputSubclass3 IS NEW Motor.OutputInterface WITH PRIVATE;

  FUNCTION Create
   (pwmout : NOT NULL Standard.PWM.Output;
    velo : Velocity := 0.0) RETURN Motor.Output;

  PROCEDURE Put
   (Self : IN OUT OutputSubclass3;
    velo : Velocity);

PRIVATE

  TYPE OutputSubclass1 IS NEW Motor.OutputInterface WITH RECORD
    pwmout : Standard.PWM.Output;
    dirout : GPIO.Pin;
  END RECORD;

  TYPE OutputSubclass2 IS NEW Motor.OutputInterface WITH RECORD
    cwout  : Standard.PWM.Output;
    ccwout : Standard.PWM.Output;
  END RECORD;

  TYPE OutputSubclass3 IS NEW Motor.OutputInterface WITH RECORD
    pwmout : Standard.PWM.Output;
  END RECORD;

END Motor.PWM;
