-- Raspberry Pi LPC1114 I/O Processor Expansion Board GPIO services

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

PACKAGE BODY spi_agent.gpio IS

  -- Validate a GPIO pin

  FUNCTION IsGPIO(pin : pin_id_t) RETURN Boolean IS

  BEGIN
    RETURN ((pin >= LPC1114_GPIO0) AND (pin <= LPC1114_GPIO5)) OR ((pin >= LPC1114_GPIO6) AND (pin <= LPC1114_GPIO7));
  END IsGPIO;

  -- Initialize a GPIO pin, given direction and initial state

  FUNCTION Create
   (pin    : pin_id_t;
    dir    : gpio_direction_t;
    state  : Boolean) RETURN GPIO IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    IF dir = GPIO_INPUT THEN
      cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_GPIO_INPUT);
    ELSE
      cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_GPIO_OUTPUT);
    END IF;

    cmd.pin  := pin_id_t'POS(pin);
    cmd.data := Boolean'POS(state);

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

    -- Initialize the GPIO pin object

    RETURN GPIO'(pin => pin);
  END Create;

  -- Initialize a GPIO pin, given configuration mode

  FUNCTION Create
   (pin   : pin_id_t;
    iocfg : gpio_mode_t) RETURN GPIO IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_GPIO);
    cmd.pin     := pin_id_t'POS(pin);
    cmd.data    := gpio_mode_t'POS(iocfg);

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

    -- Initialize the GPIO pin object

    RETURN GPIO'(pin => pin);
  END Create;

  -- (Re)confgure a GPIO pin's I/O mode

  PROCEDURE ConfigureMode
   (self  : GPIO;
    iocfg : gpio_mode_t) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_GPIO);
    cmd.pin  := pin_id_t'POS(self.pin);
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
   (self   : GPIO;
    intcfg : gpio_interrupt_config_t) IS

    cmd    : SPIAGENT_COMMAND_MSG_t;
    resp   : SPIAGENT_RESPONSE_MSG_t;
    error  : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_GPIO_INTERRUPT);
    cmd.pin     := pin_id_t'POS(self.pin);
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

  FUNCTION Get(self : GPIO) RETURN Boolean IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_GET_GPIO);
    cmd.pin     := pin_id_t'POS(self.pin);
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

  PROCEDURE Put(self : GPIO; state : Boolean) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_PUT_GPIO);
    cmd.pin     := pin_id_t'POS(self.pin);
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

  PROCEDURE Configure
   (self   : GPIO;
    iocfg  : gpio_mode_t;
    intcfg : gpio_interrupt_config_t := GPIO_INTERRUPT_DISABLED) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI agent command message

    cmd.command  := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_GPIO);
    cmd.pin      := pin_id_t'POS(self.pin);
    cmd.data     := gpio_mode_t'POS(iocfg);

    -- Configure the GPIO pin

    spi_agent.transport.command(cmd, resp, error);

    -- Check for error return from spi_agent.transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" & Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI agent firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" & Integer'IMAGE(Integer(resp.error));
    END IF;

    -- Also configure the interrupt mode for input pins

    IF (iocfg >= GPIO_MODE_INPUT) AND (iocfg <= GPIO_MODE_INPUT_PULLUP) THEN
      cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_GPIO_INTERRUPT);
      cmd.pin     := pin_id_t'POS(self.pin);
      cmd.data    := gpio_interrupt_config_t'POS(intcfg);

      -- Configure the GPIO pin

      spi_agent.transport.command(cmd, resp, error);

      -- Check for error return from spi_agent.transport.command()

      IF error /= 0 THEN
        RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" & Integer'IMAGE(error);
      END IF;

      -- Check for error from the SPI agent firmware

      IF Integer(resp.error) /= 0 THEN
        RAISE SpiAgentError WITH "SPI Agent Firmware returned error" & Integer'IMAGE(Integer(resp.error));
      END IF;
    END IF;
  END Configure;

END spi_agent.gpio;
