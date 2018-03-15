-- MCP3204 Analog to Digital Converter services

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE MCP3204 IS

  -- Configuration constants

  Resolution : CONSTANT Positive := 12;

  -- Define a subclass of Analog.Interfaces.InputInterface

  TYPE InputSubclass IS NEW Analog.Interfaces.InputInterface WITH PRIVATE;

  -- Define some types for analog input channels

  TYPE Configuration IS (SingleEnded, Differential);

  TYPE Channel IS NEW Natural RANGE 0 .. 3;

  -- Constructors

  -- If the input configuration is Differential, the channel parameter
  -- selects IN+.  IN- is inferred to be the other input of the pair.

  FUNCTION Create
   (spidev : SPI.Device;
    chan   : Channel;
    config : Configuration := SingleEnded) RETURN Analog.Interfaces.Input;

  -- Methods

  FUNCTION Get(self : IN OUT InputSubclass) RETURN Analog.Sample;

PRIVATE

  TYPE InputSubclass IS NEW Analog.Interfaces.InputInterface WITH RECORD
    spidev : SPI.Device;
    cmd    : SPI.Byte;
  END RECORD;

END MCP3204;
