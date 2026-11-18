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

WITH Interfaces.C;

WITH Discrete_To_Unsigned;
WITH Real_To_Float;

WITH lpc11xx;              USE lpc11xx;
WITH spi_agent.gpio;
WITH spi_agent.pins;       USE spi_agent.pins;

USE TYPE Interfaces.C.int;

PACKAGE BODY spi_agent.pwm IS

  -- Thin binding to libsimpleio.so

  PROCEDURE spiagent_pwm_configure
   (pin    : Interfaces.C.unsigned;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_pwm_configure);

  PROCEDURE spiagent_pwm_set_frequency
   (freq   : Interfaces.C.unsigned;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_pwm_set_frequency);

  PROCEDURE spiagent_pwm_put
   (pin    : Interfaces.C.unsigned;
    duty   : Interfaces.C.C_float;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_pwm_put);

  PROCEDURE spiagent_servo_configure
   (pin    : Interfaces.C.unsigned;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_servo_configure);

  PROCEDURE spiagent_servo_put
   (pin    : Interfaces.C.unsigned;
    posi   : Interfaces.C.C_float;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_servo_put);

  PROCEDURE spiagent_motor_configure
   (pwmpin : Interfaces.C.unsigned;
    dirpin : Interfaces.C.unsigned;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_motor_configure);

  PROCEDURE spiagent_motor_put
   (pwmpin : Interfaces.C.unsigned;
    dirpin : Interfaces.C.unsigned;
    speed  : Interfaces.C.C_float;
    error  : OUT Interfaces.C.int);

  PRAGMA Import(C, spiagent_motor_put);

  -- Type transfer functions

  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(lpc11xx.pin_id_t);

  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(pwm_frequency_t);

  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(servo_frequency_t);

  FUNCTION To_Float    IS NEW Real_To_Float(Standard.PWM.DutyCycle);

  FUNCTION To_Float    IS NEW Real_To_Float(Standard.Servo.Position);

  FUNCTION To_Float    IS NEW Real_To_Float(Standard.Motor.Velocity);

  -- Validate LPC1114 PWM output pin

  FUNCTION IsPWM(pin : lpc11xx.pin_id_t) RETURN Boolean IS

  BEGIN
    RETURN ((pin >= LPC1114_PWM1) AND (pin <= LPC1114_PWM3)) OR (pin = LPC1114_PWM4);
  END IsPWM;

  -- PWM output object constructor

  FUNCTION Create
   (pwmpin    : lpc11xx.pin_id_t;
    frequency : pwm_frequency_t;
    dutycycle : Standard.PWM.DutyCycle := 0.0) RETURN Standard.PWM.Output IS

    self : PWMOutputClass;

  BEGIN
    self.Initialize(pwmpin, frequency, dutycycle);
    RETURN NEW PWMOutputClass'(self);
  END Create;

  -- PWM output object initializer

  PROCEDURE Initialize
   (self      : OUT PWMOutputClass;
    pwmpin    : lpc11xx.pin_id_t;
    frequency : pwm_frequency_t;
    dutycycle : Standard.PWM.DutyCycle := 0.0) IS

    error : Interfaces.C.int;

  BEGIN
    IF NOT IsPWM(pwmpin) THEN
      RAISE SpiAgentError WITH "Invalid pin for PWM output";
    END IF;

    spiagent_pwm_set_frequency(To_Unsigned(frequency), error);

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spiagent_pwm_set_frequency() failed, error" & error'Image;
    END IF;

    spiagent_pwm_configure(To_Unsigned(pwmpin), error);

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spiagent_pwm_configure() failed, error" & error'Image;
    END IF;

    spiagent_pwm_put(To_Unsigned(pwmpin), To_Float(dutycycle), error);

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spiagent_pwm_put() failed, error" & error'Image;
    END IF;

    self.pwmpin := pwmpin;
    self.freq   := frequency;
  END Initialize;

  -- Set PWM output duty cycle

  PROCEDURE Put(self : IN OUT PWMOutputClass; dutycycle : Standard.PWM.Dutycycle) IS

    error : Interfaces.C.int;

  BEGIN
    spiagent_pwm_put(To_Unsigned(self.pwmpin), To_Float(dutycycle), error);

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spiagent_pwm_put() failed, error" & error'Image;
    END IF;
  END Put;

  -- Set PWM output duration

  PROCEDURE Put
   (self      : IN OUT PWMOutputClass;
    duration  : Standard.Duration) IS

  BEGIN
    RAISE SpiAgentError WITH "This method is not implemented.";
  END Put;

  -- Get PWM pulse period

  FUNCTION GetPeriod(self : IN OUT PWMOutputClass) RETURN Duration IS

  BEGIN
    RETURN 1.0/Duration(self.freq);
  END GetPeriod;

  -- Servo output object constructor

  FUNCTION Create
   (pwmpin    : lpc11xx.pin_id_t;
    frequency : servo_frequency_t := 50;
    position  : Standard.Servo.Position := 0.0) RETURN Standard.Servo.Output IS

    self : ServoOutputClass;

  BEGIN
    self.Initialize(pwmpin, frequency, position);
    RETURN NEW ServoOutputClass'(self);
  END Create;

  -- Servo output object initializer

  PROCEDURE Initialize
   (self      : OUT ServoOutputClass;
    pwmpin    : lpc11xx.pin_id_t;
    frequency : servo_frequency_t := 50;
    position  : Standard.Servo.Position := 0.0) IS

    error : Interfaces.C.int;

  BEGIN
    IF NOT IsPWM(pwmpin) THEN
      RAISE SpiAgentError WITH "Invalid pin for PWM output";
    END IF;

    spiagent_pwm_set_frequency(To_Unsigned(frequency), error);

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spiagent_pwm_set_frequency() failed, error" & error'Image;
    END IF;

    spiagent_servo_configure(To_Unsigned(pwmpin), error);

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spiagent_servo_configure() failed, error" & error'Image;
    END IF;

    spiagent_servo_put(To_Unsigned(pwmpin), To_Float(position), error);

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spiagent_servo_put() failed, error" & error'Image;
    END IF;

    self.pwmpin := pwmpin;
    self.freq   := frequency;
  END Initialize;

  -- Set servo position

  PROCEDURE Put
   (self      : IN OUT ServoOutputClass;
    position  : Standard.Servo.Position) IS

    error : Interfaces.C.int;

  BEGIN
    spiagent_servo_put(To_Unsigned(self.pwmpin), To_Float(position), error);

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spiagent_servo_put() failed, error" & error'Image;
    END IF;
  END Put;

  -- Motor driver output object constructor

  FUNCTION Create
   (pwmpin    : lpc11xx.pin_id_t;
    dirpin    : lpc11xx.pin_id_t;
    frequency : pwm_frequency_t;
    velocity  : Standard.Motor.Velocity  := 0.0) RETURN Standard.Motor.Output IS

    self : MotorOutputClass1;

  BEGIN
    self.Initialize(pwmpin, dirpin, frequency, velocity);
    RETURN NEW MotorOutputClass1'(self);
  END Create;

  -- Motor driver output object initializer

  PROCEDURE Initialize
   (self      : OUT MotorOutputClass1;
    pwmpin    : lpc11xx.pin_id_t;
    dirpin    : lpc11xx.pin_id_t;
    frequency : pwm_frequency_t;
    velocity  : Standard.Motor.Velocity  := 0.0) IS

    error : Interfaces.C.int;

  BEGIN
    IF NOT IsPWM(pwmpin) THEN
      RAISE SpiAgentError WITH "Invalid pin for PWM output";
    END IF;

    IF NOT spi_agent.gpio.IsGPIO(dirpin) THEN
      RAISE SpiAgentError WITH "Invalid pin for direction output";
    END IF;

    IF pwmpin = dirpin THEN
      RAISE SpiAgentError WITH "PWM and direction pins cannot be the same";
    END IF;

    spiagent_pwm_set_frequency(To_Unsigned(frequency), error);

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spiagent_pwm_set_frequency() failed, error" & error'Image;
    END IF;

    spiagent_motor_configure(To_Unsigned(pwmpin), To_Unsigned(dirpin), error);

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spiagent_motor_configure() failed, error" & error'Image;
    END IF;

    spiagent_motor_put(To_Unsigned(pwmpin), To_Unsigned(dirpin), To_Float(velocity), error);

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spiagent_motor_put() failed, error" & error'Image;
    END IF;

    self.dirpin := dirpin;
    self.pwmpin := pwmpin;
  END Initialize;

  -- Motor driver output object put method

  PROCEDURE Put
   (self      : IN OUT MotorOutputClass1;
    velocity  : Standard.Motor.Velocity) IS

    error : Interfaces.C.int;

  BEGIN
    spiagent_motor_put(To_Unsigned(self.pwmpin), To_Unsigned(self.dirpin),
      To_Float(velocity), error);

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spiagent_motor_put() failed, error" & error'Image;
    END IF;
  END Put;

END spi_agent.pwm;
