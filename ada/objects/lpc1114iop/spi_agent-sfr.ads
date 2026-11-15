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

-- An SFR (Special Function Register) is defined as a 32-bit unsigned integer
-- at a 32-bit address within the LPC1114 address space.  Only the addresses
-- of peripheral registers within the ranges 40000000-4007FFF and
-- 50000000-501FFFFF are accessible.

PACKAGE spi_agent.sfr IS

  -- Derive types for SFR address and data

  TYPE sfr_address IS NEW Unsigned_32;
  TYPE sfr_data    IS NEW Unsigned_32;

  TYPE SFR IS TAGGED PRIVATE;

  -- Define some well-known SFR's -- see the LPC11xx User Manual UM10398
  -- for details

  LPC1114_DEVICE_ID : CONSTANT sfr_address := 16#400483F4#;
  LPC1114_GPIO1DATA : CONSTANT sfr_address := 16#50010CFC#;
  LPC1114_U0SCR     : CONSTANT sfr_address := 16#4000801C#;

  -- Create an LPC1114 special function register instance

  FUNCTION Create(address : sfr_address) RETURN sfr;

  -- Read from LPC1114 special function register

  FUNCTION Get(reg : sfr) RETURN sfr_data;

  -- Write to LPC1114 special function register

  PROCEDURE Put(reg : sfr; data : sfr_data);

PRIVATE
  TYPE SFR IS TAGGED RECORD
    address : sfr_address;
  END RECORD;
END spi_agent.sfr;
