-- Declarations for the Raspberry Pi LPC1114 I/O Processor SPI Agent Firmware

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

WITH Interfaces;

PACKAGE spi_agent.messages IS

  -- Raspberry Pi LPC1114 I/O Processor SPI Agent Firmware command structure

  TYPE SPIAGENT_COMMAND_MSG_t IS RECORD
    command : Interfaces.Unsigned_32;
    pin     : Interfaces.Unsigned_32;
    data    : Interfaces.Unsigned_32;
  END RECORD;

  -- Raspberry Pi LPC1114 I/O Processor SPI Agent Firmware response structure

  TYPE SPIAGENT_RESPONSE_MSG_t IS RECORD
    command : Interfaces.Unsigned_32;
    pin     : Interfaces.Unsigned_32;
    data    : Interfaces.Unsigned_32;
    error   : Interfaces.Unsigned_32;
  END RECORD;

END spi_agent.messages;
