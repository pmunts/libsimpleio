-- MCP4822 Digital to Analog Converter services

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

WITH Analog;
WITH SPI;

PACKAGE MCP4822 IS

  Resolution : CONSTANT := 12;

  -- SPI transfer characteristics

  SPI_Mode      : CONSTANT Natural := 0;
  SPI_WordSize  : CONSTANT Natural := 8;
  SPI_Frequency : CONSTANT Natural := 20_000_000;

  TYPE Channel IS NEW Natural RANGE 0 .. 1; -- 0=DAC-A, 1=DAC-B

  TYPE OutputGains IS NEW Natural RANGE 1 .. 2;

  -- Define a subclass of Analog.OutputInterface

  TYPE OutputSubclass IS NEW Analog.OutputInterface WITH PRIVATE;

  -- Constructors

  FUNCTION Create
   (spidev : NOT NULL SPI.Device;
    chan   : Channel;
    gain   : OutputGains := 1) RETURN Analog.Output;

  -- Methods

  FUNCTION GetResolution(Self : IN OUT OutputSubclass) RETURN Positive;

  PROCEDURE Put(Self : IN OUT OutputSubclass; value : Analog.Sample);

PRIVATE

  TYPE OutputSubclass IS NEW Analog.OutputInterface WITH RECORD
    spidev : SPI.Device;
    cmd    : SPI.Byte;
  END RECORD;

END MCP4822;
