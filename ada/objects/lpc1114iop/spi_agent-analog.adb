-- Raspberry Pi LPC1114 I/O Processor Expansion Board A/D converter services

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

WITH spi_agent.commands;   USE spi_agent.commands;
WITH spi_agent.messages;   USE spi_agent.messages;
WITH spi_agent.pins;       USE spi_agent.pins;
WITH spi_agent.transport;

USE TYPE lpc11xx.pin_id_t;

PACKAGE BODY spi_agent.analog IS

  -- Validate LPC1114 analog input pin number

  FUNCTION IsAnalog(pin : lpc11xx.pin_id_t) RETURN Boolean IS

  BEGIN
    RETURN (pin >= LPC1114_AD1) AND (pin <= LPC1114_AD5);
  END IsAnalog;

  -- Configure LPC1114 analog input pin

  FUNCTION Create(pin : lpc11xx.pin_id_t) RETURN ADC IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN
    IF NOT IsAnalog(pin) THEN
      RAISE SpiAgentError WITH "Invalid pin for analog input";
    END IF;

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_ANALOG_INPUT);
    cmd.pin     := lpc11xx.pin_id_t'POS(pin);
    cmd.data    := 0;

    -- Configure the analog input pin

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

    RETURN ADC'(pin => pin);
  END Create;

  -- Create from channel number

  FUNCTION Create(channel : analog_channel_t) RETURN ADC IS

  BEGIN
    RETURN Create(lpc11xx.pin_id_t'VAL(channel - 1 + lpc11xx.pin_id_t'POS(LPC1114_AD1)));
  END Create;

  -- Read from LPC1114 analog input pin

  FUNCTION Get(self : ADC) RETURN analog_voltage_t IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_GET_ANALOG);
    cmd.pin     := lpc11xx.pin_id_t'POS(self.pin);
    cmd.data    := 0;

    -- Read the analog input pin

    spi_agent.transport.command(cmd, resp, error);

    -- Check for error return from spi_agent.transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" & Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" & Integer'IMAGE(Integer(resp.error));
    END IF;

    -- Return the value of the analog input pin

    RETURN analog_voltage_t(Float(resp.data)*LPC1114_ADC_STEPSIZE);
  END Get;
END spi_agent.analog;
