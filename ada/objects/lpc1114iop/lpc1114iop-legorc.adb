-- Raspberry Pi LPC1114 I/O Processor Expansion Board
-- LEGO® Power Functions Remote Control services

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

WITH GPIO;
WITH Motor;
WITH Discrete_To_Unsigned;
WITH libspiagent;
WITH LPC1114IOP.GPIO;

USE TYPE Interfaces.C.int;
USE TYPE Interfaces.C.unsigned;
USE TYPE Motor.Velocity;

PACKAGE BODY LPC1114IOP.LEGORC IS

  -- Type transfer functions

  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(Boolean);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(Natural);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(Standard.GPIO.Direction);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(legorc_channel_t);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(legorc_motor_t);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(legorc_direction_t);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(legorc_speed_t);
  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(lpc11xx.pin_id_t);

  -- Initialize an IRED output driver

  PROCEDURE Initialize(pin : lpc11xx.pin_id_t) IS

    error : Interfaces.C.int;

  BEGIN
    IF NOT LPC1114IOP.GPIO.IsGPIO(pin) THEN
      RAISE LPC1114IOP.Error WITH "Invalid pin for IRED driver output";
    END IF;

    libspiagent.spiagent_gpio_configure(To_Unsigned(pin),
      To_Unsigned(Standard.GPIO.Output), To_Unsigned(False), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_gpio_configure() failed, error" &
        error'Image;
    END IF;
  END Initialize;

  -- Transmit a LEGO® Power Functions Remote Control command

  PROCEDURE Transmit
   (pin       : lpc11xx.pin_id_t;
    channel   : legorc_channel_t;
    motorID   : legorc_motor_t;
    direction : legorc_direction_t;
    speed     : legorc_speed_t) IS

    error : Interfaces.C.int;

  BEGIN
    IF NOT LPC1114IOP.GPIO.IsGPIO(pin) THEN
      RAISE LPC1114IOP.Error WITH "Invalid pin for IRED driver output";
    END IF;

    libspiagent.spiagent_legorc_put(To_Unsigned(pin), To_Unsigned(channel),
      To_Unsigned(motorID), To_Unsigned(direction), To_Unsigned(speed), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_legorc_put() failed, error" &
        error'Image;
    END IF;
  END Transmit;

  -- Motor driver output object constructor

  FUNCTION Create
   (pin       : lpc11xx.pin_id_t;
    channel   : legorc_channel_t;
    motorID   : legorc_motor_t;
    velocity  : Standard.Motor.Velocity  := 0.0) RETURN Standard.Motor.Output IS

    self : MotorOutputClass;

  BEGIN
    self.Initialize(pin, channel, motorID, velocity);
    RETURN NEW MotorOutputClass'(self);
  END Create;

  -- Motor driver output object initializer

  PROCEDURE Initialize
   (self      : OUT MotorOutputClass;
    pin       : lpc11xx.pin_id_t;
    channel   : legorc_channel_t;
    motorID   : legorc_motor_t;
    velocity  : Standard.Motor.Velocity  := 0.0) IS

  BEGIN
    IF NOT LPC1114IOP.GPIO.IsGPIO(pin) THEN
      RAISE LPC1114IOP.Error WITH "Invalid pin for IRED driver output";
    END IF;

    IF motorID < MotorA OR motorID > MotorB THEN
      RAISE Constraint_Error;
    END IF;

    self.pin     := pin;
    self.channel := channel;
    self.motorID := motorID;
    self.Put(velocity);
  END Initialize;

  FUNCTION velocity_to_speed(velocity : Motor.Velocity) RETURN Natural IS

    num_steps : CONSTANT Natural := 8;
    step_size : CONSTANT Float   := 1.0/8.0;

  BEGIN
    FOR i IN 1 .. num_steps LOOP
      IF abs(Float(velocity)) < Float(i)*step_size THEN
        RETURN i - 1;
      END IF;
    END LOOP;

    RETURN 7;
  END velocity_to_speed;

  -- Motor driver output object put method

  PROCEDURE Put
   (self      : IN OUT MotorOutputClass;
    velocity  : Standard.Motor.Velocity) IS

    direction : legorc_direction_t :=
     (IF velocity < 0.0 THEN DIRECTION_REVERSE ELSE DIRECTION_FORWARD);
    speed     : Natural := velocity_to_speed(velocity);
    error     : Interfaces.C.int;

  BEGIN
      libspiagent.spiagent_legorc_put(To_Unsigned(self.pin),
        To_Unsigned(self.channel), To_Unsigned(self.motorID),
        To_Unsigned(direction), To_Unsigned(speed), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_legorc_put() failed, error" &
        error'Image;
    END IF;
  END Put;

END LPC1114IOP.LEGORC;
