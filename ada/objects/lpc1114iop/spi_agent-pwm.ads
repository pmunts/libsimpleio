-- Raspberry Pi LPC1114 I/O Processor Expansion Board PWM services

-- Copyright (C)2013-2018, Philip Munts, President, Munts AM Corp.
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

WITH spi_agent.pins; USE spi_agent.pins;
WITH spi_agent.gpio; USE spi_agent.gpio;

PACKAGE spi_agent.pwm IS

  -- PWM output types

  TYPE PWM IS TAGGED PRIVATE;

  TYPE pwm_channel_t IS NEW Natural RANGE 1 .. 4;

  TYPE pwm_frequency_t IS NEW Natural RANGE 50 .. 50000;	-- Hertz

  TYPE pwm_dutycycle_t IS NEW Float RANGE 0.0 .. 100.0;		-- Percent

  PWM_OFF : pwm_dutycycle_t := 0.0;				-- Minimum power
  PWM_ON  : pwm_dutycycle_t := 100.0;				-- Maximum power

  -- Validate PWM output pin

  FUNCTION IsPWM(pin : pin_id_t) RETURN Boolean;

  -- PWM output operations

  FUNCTION Create(pin : pin_id_t;
    freq : pwm_frequency_t := 100) RETURN PWM;

  FUNCTION Create(channel : pwm_channel_t;
    freq : pwm_frequency_t := 100) RETURN PWM;

  PROCEDURE Put(self : PWM; dutycycle : pwm_dutycycle_t);

  -- Servo output types

  TYPE Servo is TAGGED PRIVATE;

  TYPE servo_position_t IS NEW Float RANGE -1.0 .. 1.0;		-- Normalized position

  SERVO_NEUTRAL : servo_position_t := 0.0;			-- Midpoint/neutral/null/zero position

  -- Servo output operations

  FUNCTION Create(pin : pin_id_t;
    freq : pwm_frequency_t := 50) RETURN Servo;

  FUNCTION Create(channel : pwm_channel_t;
    freq : pwm_frequency_t := 50) RETURN Servo;

  PROCEDURE Put(self : Servo; position : servo_position_t);

  -- H-bridge motor driver output types

  TYPE Motor IS TAGGED PRIVATE;

  SUBTYPE dir_pin_id_t IS pin_id_t RANGE LPC1114_GPIO0 .. LPC1114_GPIO7;

  TYPE motor_speed_t IS NEW Float RANGE -1.0 .. 1.0;		-- Normalized velocity

  MOTOR_FORWARD : motor_speed_t := 1.0;				-- Full speed forward direction
  MOTOR_REVERSE : motor_speed_t := -1.0;			-- Full speed reverse direction
  MOTOR_STOP    : motor_speed_t := 0.0;				-- Motor stopped

  -- H-bridge motor driver output operations

  FUNCTION Create(pwmpin : pin_id_t; dirpin : dir_pin_id_t;
    freq : pwm_frequency_t := 100) RETURN Motor;

  PROCEDURE Put(self : Motor; speed : motor_speed_t);

PRIVATE
  TYPE PWM IS TAGGED RECORD
    pin : pin_id_t;
  END RECORD;

  TYPE Servo IS TAGGED RECORD
    pin  : pin_id_t;
    freq : pwm_frequency_t;
  END RECORD;

  TYPE Motor IS TAGGED RECORD
    pwmpin : PWM;
    dirpin : GPIO.GPIO;
  END RECORD;
END spi_agent.pwm;
