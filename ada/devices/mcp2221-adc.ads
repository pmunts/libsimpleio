-- MCP2221 A/D Converter Input Services

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

PACKAGE MCP2221.ADC IS

  Resolution : CONSTANT := 10;

  -- Define a subclass of Analog.InputInterface

  TYPE InputSubclass IS NEW Analog.InputInterface WITH PRIVATE;

  TYPE Channel IS NEW Natural RANGE 1 .. 3;

  -- Constructor

  FUNCTION Create(dev : NOT NULL Device; num : Channel) RETURN Analog.Input;

  -- Methods

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Analog.Sample;

  FUNCTION GetResolution(Self : IN OUT InputSubclass) RETURN Positive;

PRIVATE

  TYPE InputSubclass IS NEW Analog.InputInterface WITH RECORD
    dev : DeviceClass;
    num : Channel;
  END RECORD;

END MCP2221.ADC;
