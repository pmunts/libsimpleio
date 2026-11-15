-- Raspberry Pi LPC1114 I/O Processor SPI Agent Firmware Transport Services
-- using libspiagent

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

WITH spi_agent.messages; USE spi_agent.messages;

PACKAGE spi_agent.transport IS
  pragma Link_With("-lspiagent");
  pragma Elaborate_Body;

  -- Initialize the SPI Agent Firmware transport library

  PROCEDURE open(servername : String; error : OUT Integer);
  PRAGMA Import(C, open, "spiagent_open");

  -- Deinitialize the SPI Agent Firmware transport library

  PROCEDURE close(error : OUT Integer);
  PRAGMA Import(C, close, "spiagent_close");

  -- Dispatch an SPI Agent Firmware command to the transport library

  PROCEDURE command
   (command  : IN SPIAGENT_COMMAND_MSG_t;
    response : OUT SPIAGENT_RESPONSE_MSG_t;
    error    : OUT Integer);
  PRAGMA Import(C, command, "spiagent_command");

END spi_agent.transport;
