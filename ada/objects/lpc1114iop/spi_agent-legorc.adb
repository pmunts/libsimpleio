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

WITH Interfaces;           USE Interfaces;

WITH spi_agent.commands;   USE spi_agent.commands;
WITH spi_agent.gpio;       USE spi_agent.gpio;
WITH spi_agent.messages;   USE spi_agent.messages;
WITH spi_agent.transport;

PACKAGE BODY spi_agent.legorc IS

  -- Initialize a LEGO® RC output pin

  FUNCTION Create(pin : pin_id_t) RETURN LEGORC IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN
    IF NOT IsGPIO(pin) THEN
      RAISE SpiAgentError WITH "Invalid pin for LEGO RC output";
    END IF;

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_CONFIGURE_GPIO_OUTPUT);
    cmd.pin  := pin_id_t'POS(pin);
    cmd.data := Boolean'POS(False);

    -- Configure the GPIO pin

    spi_agent.transport.command(cmd, resp, error);

    -- Check for error return from spi_agent.transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" & Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" & Integer'IMAGE(Integer(resp.error));
    END IF;

    RETURN LEGORC'(pin => pin);
  END Create;

  -- Write LEGO® RC pin

  PROCEDURE Put
   (self      : LEGORC;
    channel   : legorc_channel_t;
    motor     : legorc_motor_t;
    direction : legorc_direction_t;
    speed     : legorc_speed_t) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_PUT_LEGORC);
    cmd.pin     := pin_id_t'POS(self.pin);
    cmd.data    := Unsigned_32(speed) OR
      Shift_Left(Unsigned_32(legorc_direction_t'POS(direction)), 8) OR
      Shift_Left(Unsigned_32(legorc_motor_t'POS(motor)), 16) OR
      Shift_Left(Unsigned_32(channel), 24);

    -- Transmit the LEGO® RC command

    spi_agent.transport.command(cmd, resp, error);

    -- Check for error return from spi_agent.transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" &
        Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" &
        Integer'IMAGE(Integer(resp.error));
    END IF;
  END Put;

END spi_agent.legorc;
