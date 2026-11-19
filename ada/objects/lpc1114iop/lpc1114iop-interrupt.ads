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

PACKAGE LPC1114IOP.Interrupt IS
  pragma Link_With("-lspiagent");

  -- Raspberry Pi GPIO pins (on P1 expansion header)

  RPI_GPIO4 : CONSTANT Integer := 4;
  RPI_INT   : CONSTANT Integer := RPI_GPIO4;

  -- Interrupt helper procedures

  PROCEDURE interrupt_enable(error : OUT Integer);
  PRAGMA Import(C, interrupt_enable, "spiagent_interrupt_enable");

  PROCEDURE interrupt_disable(error : OUT Integer);
  PRAGMA Import(C, interrupt_disable, "spiagent_interrupt_disable");

  PROCEDURE interrupt_wait
   (timeout : Integer;
    pin     : OUT Integer;
    error   : OUT Integer);
  PRAGMA Import(C, interrupt_wait, "spiagent_interrupt_wait");

END LPC1114IOP.Interrupt;
