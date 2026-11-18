-- Raspberry Pi LPC1114 I/O Processor Expansion Board GPIO services

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

WITH GPIO;
WITH lpc11xx;

WITH spi_agent.commands;   USE  spi_agent.commands;
WITH spi_agent.messages;   USE  spi_agent.messages;
WITH spi_agent.pins;       USE  spi_agent.pins;
WITH spi_agent.transport;

USE TYPE Standard.GPIO.Direction;
USE TYPE lpc11xx.pin_id_t;

PACKAGE BODY spi_agent.gpio IS

  -- Validate a GPIO pin

  FUNCTION IsGPIO(pin : lpc11xx.pin_id_t) RETURN Boolean IS

  BEGIN
    RETURN ((pin >= LPC1114_GPIO0) AND (pin <= LPC1114_GPIO5)) OR
           ((pin >= LPC1114_GPIO6) AND (pin <= LPC1114_GPIO7));
  END IsGPIO;

  -- Create a GPIO pin object instance, given direction and initial state

  FUNCTION Create
   (pin    : lpc11xx.pin_id_t;
    dir    : Standard.GPIO.Direction;
    state  : Boolean := False) RETURN Standard.GPIO.Pin IS

    self : PinSubclass;

  BEGIN
    self.Initialize(pin, dir, state);
    RETURN NEW PinSubclass'(self);
  END Create;

  -- Create a GPIO pin object instance, given configuration and initial state

  FUNCTION Create
   (pin    : lpc11xx.pin_id_t;
    iocfg  : gpio_mode_t;
    intcfg : gpio_interrupt_config_t := GPIO_INTERRUPT_DISABLED;
    state  : Boolean := False) RETURN Standard.GPIO.Pin IS

    self : PinSubclass;

  BEGIN
    self.Initialize(pin, iocfg, intcfg, state);
    RETURN NEW PinSubclass'(self);
  END Create;

  -- GPIO pin object initializer

  PROCEDURE Initialize
   (self   : OUT PinSubclass;
    pin    : lpc11xx.pin_id_t;
    dir    : Standard.GPIO.Direction;
    state  : Boolean := False) IS

  BEGIN
    self.pin := pin;

    IF dir = Standard.GPIO.Input THEN
      self.ConfigureMode(GPIO_MODE_INPUT);
      self.ConfigureInterrupt(GPIO_INTERRUPT_DISABLED);
    ELSE
      self.ConfigureMode(GPIO_MODE_OUTPUT);
      self.Put(state);
    END IF;
  END Initialize;

  -- GPIO pin object initializer

  PROCEDURE Initialize
   (self   : OUT PinSubclass;
    pin    : lpc11xx.pin_id_t;
    iocfg  : gpio_mode_t;
    intcfg : gpio_interrupt_config_t := GPIO_INTERRUPT_DISABLED;
    state  : Boolean := False) IS

  BEGIN
    self.pin := pin;

    self.ConfigureMode(iocfg);

    IF iocfg < GPIO_MODE_OUTPUT THEN
      self.ConfigureInterrupt(intcfg);
    ELSE
      self.Put(state);
    END IF;
  END Initialize;

  PROCEDURE ConfigureMode
   (self  : PinSubclass;
    iocfg : gpio_mode_t) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN
    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_GPIO);
    cmd.pin  := lpc11xx.pin_id_t'POS(self.pin);
    cmd.data := gpio_mode_t'POS(iocfg);

    -- Issue the command

    spi_agent.transport.command(cmd, resp, error);

    -- Check for error return from spi_agent.transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" & Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" & Integer'IMAGE(Integer(resp.error));
    END IF;
  END ConfigureMode;

  -- Configure GPIO pin interrupt

  PROCEDURE ConfigureInterrupt
   (self   : PinSubclass;
    intcfg : gpio_interrupt_config_t) IS

    cmd    : SPIAGENT_COMMAND_MSG_t;
    resp   : SPIAGENT_RESPONSE_MSG_t;
    error  : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_GPIO_INTERRUPT);
    cmd.pin     := lpc11xx.pin_id_t'POS(self.pin);
    cmd.data    := gpio_interrupt_config_t'POS(intcfg);

    -- Issue the command

    spi_agent.transport.command(cmd, resp, error);

    -- Check for error return from spi_agent.transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" & Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI agent firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" & Integer'IMAGE(Integer(resp.error));
    END IF;
  END ConfigureInterrupt;

  -- Read from LPC1114 GPIO pin

  FUNCTION Get(self : IN OUT PinSubclass) RETURN Boolean IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_GET_GPIO);
    cmd.pin     := lpc11xx.pin_id_t'POS(self.pin);
    cmd.data    := 0;

    -- Read the GPIO pin

    spi_agent.transport.command(cmd, resp, error);

    -- Check for error return from spi_agent.transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" & Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" & Integer'IMAGE(Integer(resp.error));
    END IF;

    -- Return the state of the GPIO pin

    RETURN Boolean'VAL(resp.data);
  END Get;

  -- Write to LPC1114 GPIO pin

  PROCEDURE Put(self : IN OUT PinSubclass; state : Boolean) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_PUT_GPIO);
    cmd.pin     := lpc11xx.pin_id_t'POS(self.pin);
    cmd.data    := Boolean'POS(state);

    -- Write the GPIO pin

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

END spi_agent.gpio;
