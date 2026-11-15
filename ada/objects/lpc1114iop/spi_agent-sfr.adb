-- Raspberry Pi LPC1114 I/O Processor Expansion Board SFR services

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

WITH spi_agent.commands;   USE spi_agent.commands;
WITH spi_agent.exceptions; USE spi_agent.exceptions;
WITH spi_agent.messages;   USE spi_agent.messages;
WITH spi_agent.transport;  USE spi_agent.transport;

PACKAGE BODY spi_agent.sfr IS

  -- Create an LPC1114 special function register instance

  FUNCTION Create(address : sfr_address) RETURN SFR IS

  BEGIN
    IF ((address >= 16#40000000#) AND (address <= 16#4007FFFF#)) OR
       ((address >= 16#50000000#) AND (address <= 16#501FFFFF#)) THEN
      RETURN SFR'(address => address);
    ELSE
      RAISE SpiAgentError WITH "Illegal SFR address";
    END IF;
  END Create;

  -- Read from LPC1114 special function register

  FUNCTION Get(reg : SFR) RETURN sfr_data IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_GET_SFR);
    cmd.pin     := Interfaces.Unsigned_32(reg.address);
    cmd.data    := 0;

    -- Issue the command to the LPC1114 SPI Firmware Agent

    spi_agent.transport.command(cmd, resp, error);

    -- Check for error return from spi_agent.transport.command()

    IF error /= 0 THEN
      RAISE SpiAgentError WITH "spi_agent.transport.command() failed, error" & Integer'IMAGE(error);
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF Integer(resp.error) /= 0 THEN
      RAISE SpiAgentError WITH "SPI Agent Firmware returned error" & Integer'IMAGE(Integer(resp.error));
    END IF;

    RETURN sfr_data(resp.data);
  END Get;

  -- Write to LPC1114 special function register

  PROCEDURE Put(reg : SFR; data : sfr_data) IS

    cmd   : SPIAGENT_COMMAND_MSG_t;
    resp  : SPIAGENT_RESPONSE_MSG_t;
    error : Integer;

  BEGIN

    -- Build the SPI Agent Firmware command message

    cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_PUT_SFR);
    cmd.pin     := Interfaces.Unsigned_32(reg.address);
    cmd.data    := Interfaces.Unsigned_32(data);

    -- Issue the command to the LPC1114 SPI Firmware Agent

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
END spi_agent.sfr;
