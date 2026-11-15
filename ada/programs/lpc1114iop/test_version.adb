-- Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
-- version test

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

WITH Ada.Command_Line;      USE Ada.Command_Line;
WITH Ada.Strings.Unbounded; USE Ada.Strings.Unbounded;
WITH Ada.Text_IO;           USE Ada.Text_IO;
WITH Interfaces;            USE Interfaces;

WITH spi_agent.messages;    USE spi_agent.messages;
WITH spi_agent.commands;    USE spi_agent.commands;
WITH spi_agent.transport;

PROCEDURE test_version IS

  servername : Unbounded_String;
  error      : Integer;
  cmd        : SPIAGENT_COMMAND_MSG_t;
  resp       : SPIAGENT_RESPONSE_MSG_t;

  PACKAGE int_io IS NEW Integer_IO(Integer);
  USE int_io;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor Expansion Board Firmware Version Test");
  New_Line;

  -- Analyze command line parameters

  IF Argument_Count = 0 THEN
    servername := To_Unbounded_String("localhost");
  ELSIF Argument_Count = 1 THEN
    servername := To_Unbounded_String(Argument(1));
  ELSE
    Put_Line("Usage: " & Command_Name & " [hostname]");
    RETURN;
  END IF;

  -- Initialize the SPI Agent Firmware transport library

  spi_agent.transport.open(To_String(servername) & ASCII.NUL, error);

  IF error /= 0 THEN
    RAISE spi_agent.SpiAgentError WITH
      "spi_agent.transport.open() failed, error:" & Integer'IMAGE(error);
  END IF;

  -- Issue NOP command to the SPI Agent Firmware

  cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_NOP);
  cmd.pin     := 0;
  cmd.data    := 0;

  spi_agent.transport.command(cmd, resp, error);

  IF error /= 0 THEN
    RAISE spi_agent.SpiAgentError WITH
      "spi_agent.transport.command() failed, error:" & Integer'IMAGE(error);
  END IF;

  IF resp.error /= 0 THEN
    RAISE spi_agent.SpiAgentError WITH
      "SPI Agent Firmware returned error:" &
      Unsigned_32'IMAGE(resp.error);
  END IF;

  -- Display results

  Put_Line("The SPI Agent Firmware version number is" &
    Integer'IMAGE(Integer(resp.data)));

  -- Issue GET_SFR command to the SPI Agent Firmware

  cmd.command := SPIAGENT_COMMAND_t'POS(SPIAGENT_CMD_GET_SFR);
  cmd.pin     := 16#400483F4#;
  cmd.data    := 0;

  spi_agent.transport.command(cmd, resp, error);

  IF error /= 0 THEN
    RAISE spi_agent.SpiAgentError WITH
      "spi_agent.transport.command() failed, error:" & Integer'IMAGE(error);
  END IF;

  IF resp.error /= 0 THEN
    RAISE spi_agent.SpiAgentError WITH
      "SPI Agent Firmware returned error:" &
      Unsigned_32'IMAGE(resp.error);
  END IF;

  -- Display results

  Put("The LPC1114 device ID is ");
  Put(Integer(resp.data), Base => 16);
  New_Line(2);

  -- Deinitialize the SPI Agent Firmware transport library

  spi_agent.transport.close(error);

  IF error /= 0 THEN
    RAISE spi_agent.SpiAgentError WITH
      "spi_agent.transport.close() failed, error:" & Integer'IMAGE(error);
  END IF;
END test_version;
