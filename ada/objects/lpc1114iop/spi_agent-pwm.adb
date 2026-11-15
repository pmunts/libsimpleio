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

WITH spi_agent.commands;
USE spi_agent.commands;

WITH spi_agent.exceptions;
USE spi_agent.exceptions;

WITH spi_agent.messages;
USE spi_agent.messages;

WITH spi_agent.pins;
USE spi_agent.pins;

WITH spi_agent.transport;
USE spi_agent.transport;

PACKAGE BODY spi_agent.pwm IS

  ChannelToPin : CONSTANT ARRAY (pwm_channel_t) OF pin_id_t :=
    (LPC1114_PWM1, LPC1114_PWM2, LPC1114_PWM3, LPC1114_PWM4);

  -- Validate LPC1114 PWM output pin

  FUNCTION IsPWM(pin : pin_id_t) RETURN Boolean IS

  BEGIN
    RETURN ((pin >= LPC1114_PWM1) AND (pin <= LPC1114_PWM3)) OR (pin = LPC1114_PWM4);
  END IsPWM;

  -- Configure LPC1114 PWM output pin

  FUNCTION Create(pin : pin_id_t;
    freq : pwm_frequency_t := 100) RETURN PWM IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN
    IF NOT IsPWM(pin) THEN
      RAISE SpiAgentError WITH "Invalid pin for PWM output";
    END IF;

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_PWM_OUTPUT);
    cmd.pin     := pin_id_t'POS(pin);
    cmd.data    := Unsigned_32(freq);

    -- Configure the PWM output pin

    spi_agent.transport.command(cmd, resp, error);

    -- Check for error return from spi_agent.transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" & Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" & Integer'IMAGE(Integer(resp.error));
    END IF;

    -- Allocate the pin structure

    RETURN PWM'(pin => pin);
  END Create;

  -- Configure LPC1114 PWM output pin

  FUNCTION Create(channel : pwm_channel_t;
    freq : pwm_frequency_t := 100) RETURN PWM IS

  BEGIN
    RETURN Create(ChannelToPin(channel), freq);
  END Create;

  -- Set LPC1114 PWM output duty cycle

  PROCEDURE Put(self : PWM; dutycycle : pwm_dutycycle_t) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_PUT_PWM);
    cmd.pin     := pin_id_t'POS(self.pin);
    cmd.data    := Unsigned_32(655.35*dutycycle);

    -- Issue command

    spi_agent.transport.command(cmd, resp, error);

    -- Check for error return from spi_agent.transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" & Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" & Integer'IMAGE(Integer(resp.error));
    END IF;
  END Put;

  -- Configure LPC1114 servo output pin

  FUNCTION Create(pin : pin_id_t;
    freq : pwm_frequency_t := 50) RETURN Servo IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN
    IF freq > 400 THEN
      RAISE SpiAgentError WITH "PWM frequency is too high for servos";
    END IF;

    IF NOT IsPWM(pin) THEN
      RAISE SpiAgentError WITH "Invalid pin for PWM output";
    END IF;

    -- Configure the PWM output pin

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_PWM_OUTPUT);
    cmd.pin     := pin_id_t'POS(pin);
    cmd.data    := Unsigned_32(freq);

    spi_agent.transport.command(cmd, resp, error);

    -- Check for error return from spi_agent.transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" & Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" & Integer'IMAGE(Integer(resp.error));
    END IF;

    -- Allocate the pin structure

    RETURN Servo'(pin, freq);
  END Create;

  -- Configure LPC1114 servo output pin

  FUNCTION Create(channel : pwm_channel_t;
    freq : pwm_frequency_t := 50) RETURN Servo IS

  BEGIN
    RETURN Create(ChannelToPin(channel), freq);
  END Create;

  -- Set servo position

  PROCEDURE Put(self : Servo; position : servo_position_t) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_PUT_PWM);
    cmd.pin     := pin_id_t'POS(self.pin);
    cmd.data    := Unsigned_32(655.35*(0.5E-1*float(position) + 1.5E-1)*float(self.freq));

    -- Issue command

    spi_agent.transport.command(cmd, resp, error);

    -- Check for error return from spi_agent.transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" & Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" & Integer'IMAGE(Integer(resp.error));
    END IF;
  END Put;

  -- Configure H-bridge motor driver outputs

  FUNCTION Create(pwmpin : pin_id_t; dirpin : dir_pin_id_t;
    freq : pwm_frequency_t := 100) RETURN Motor IS

  BEGIN
    IF NOT IsPWM(pwmpin) THEN
      RAISE SpiAgentError WITH "Invalid pin for PWM output";
    END IF;

    IF NOT IsGPIO(dirpin) THEN
      RAISE SpiAgentError WITH "Invalid pin for direction output";
    END IF;

    IF pwmpin = dirpin THEN
      RAISE SpiAgentError WITH "PWM and direction pins cannot be the same";
    END IF;

    RETURN Motor'(Create(pwmpin, freq), Create(dirpin, GPIO_MODE_OUTPUT));
  END Create;

  -- Set H-bridge motor driver output speed

  PROCEDURE Put(self : Motor; speed : motor_speed_t) IS

  BEGIN
    IF speed < 0.0 THEN
      self.dirpin.Put(False);
      self.pwmpin.Put(pwm_dutycycle_t(-100.0*speed));
    ELSE
      self.dirpin.Put(True);
      self.pwmpin.Put(pwm_dutycycle_t(100.0*speed));
    END IF;
  END;

END spi_agent.pwm;
