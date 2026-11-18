-- Raspberry Pi LPC1114 I/O Processor Expansion Board PWM services

-- Copyright (C)2013-2026, Philip Munts, President, Munts AM Corp.
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

WITH lpc11xx;
WITH PWM;
WITH Servo;
WITH Motor;

USE PWM;

PACKAGE spi_agent.pwm IS

  -- PWM output types

  TYPE PWMOutputClass  IS NEW Standard.PWM.OutputInterface WITH PRIVATE;
  TYPE pwm_frequency_t IS NEW Positive RANGE 50 .. 50000; -- Hertz

  -- Validate PWM output pin

  FUNCTION IsPWM(pin : lpc11xx.pin_id_t) RETURN Boolean;

  -- PWM output object constructor

  FUNCTION Create
   (pwmpin    : lpc11xx.pin_id_t;
    frequency : pwm_frequency_t;
    dutycycle : Standard.PWM.DutyCycle := 0.0) RETURN Standard.PWM.Output;

  -- PWM output object initializer

  PROCEDURE Initialize
   (self      : OUT PWMOutputClass;
    pwmpin    : lpc11xx.pin_id_t;
    frequency : pwm_frequency_t;
    dutycycle : Standard.PWM.DutyCycle := 0.0);

  -- PWM output object methods

  PROCEDURE Put
   (self      : IN OUT PWMOutputClass;
    dutycycle : Standard.PWM.DutyCycle);

  PROCEDURE Put
   (self      : IN OUT PWMOutputClass;
    duration  : Standard.Duration);

  FUNCTION GetPeriod(self : IN OUT PWMOutputClass) RETURN Duration;

  -- Servo output types

  TYPE ServoOutputClass  IS NEW Servo.OutputInterface WITH PRIVATE;
  TYPE servo_frequency_t IS NEW Positive RANGE 50 .. 400; -- Hertz

  -- Servo output object constructor

  FUNCTION Create
   (pwmpin    : lpc11xx.pin_id_t;
    frequency : servo_frequency_t := 50;
    position  : Standard.Servo.Position := 0.0) RETURN Standard.Servo.Output;

  -- Servo output object initializer

  PROCEDURE Initialize
   (self      : OUT ServoOutputClass;
    pwmpin    : lpc11xx.pin_id_t;
    frequency : servo_frequency_t := 50;
    position  : Standard.Servo.Position := 0.0);

  -- Servo output object put method

  PROCEDURE Put
   (self      : IN OUT ServoOutputClass;
    position  : Standard.Servo.Position);

  -- Motor driver output type

  TYPE MotorOutputClass1 IS NEW Motor.OutputInterface WITH PRIVATE;

  -- Motor driver output object constructor

  FUNCTION Create
   (pwmpin    : lpc11xx.pin_id_t;
    dirpin    : lpc11xx.pin_id_t;
    frequency : pwm_frequency_t;
    velocity  : Standard.Motor.Velocity  := 0.0) RETURN Standard.Motor.Output;

  -- Motor driver output object initializer

  PROCEDURE Initialize
   (self      : OUT MotorOutputClass1;
    pwmpin    : lpc11xx.pin_id_t;
    dirpin    : lpc11xx.pin_id_t;
    frequency : pwm_frequency_t;
    velocity  : Standard.Motor.Velocity  := 0.0);

  -- Motor driver output object put method

  PROCEDURE Put
   (self      : IN OUT MotorOutputClass1;
    velocity  : Standard.Motor.Velocity);

PRIVATE
  TYPE PWMOutputClass IS NEW Standard.PWM.OutputInterface WITH RECORD
    pwmpin : lpc11xx.pin_id_t;
    freq   : pwm_frequency_t;
  END RECORD;

  TYPE ServoOutputClass IS NEW Standard.Servo.OutputInterface WITH RECORD
    pwmpin : lpc11xx.pin_id_t;
    freq   : servo_frequency_t;
  END RECORD;

  TYPE MotorOutputClass1 IS NEW Standard.Motor.OutputInterface WITH RECORD
    dirpin : lpc11xx.pin_id_t;
    pwmpin : lpc11xx.pin_id_t;
  END RECORD;
END spi_agent.pwm;
