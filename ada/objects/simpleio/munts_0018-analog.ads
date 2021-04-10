-- Define I/O device objects for the Raspberry Pi Tutorial I/O Board MUNTS-0018

-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH ADC.libsimpleio;
WITH MCP3204;
WITH Voltage;

PACKAGE MUNTS_0018.Analog IS

  Inputs : CONSTANT ARRAY (0 .. 3) OF Voltage.Input :=
   (ADC.Create(ADC.libsimpleio.Create(MUNTS_0018.J10A0, MCP3204.Resolution), 3.3),
    ADC.Create(ADC.libsimpleio.Create(MUNTS_0018.J10A1, MCP3204.Resolution), 3.3),
    ADC.Create(ADC.libsimpleio.Create(MUNTS_0018.J11A0, MCP3204.Resolution), 3.3),
    ADC.Create(ADC.libsimpleio.Create(MUNTS_0018.J11A1, MCP3204.Resolution), 3.3));

END MUNTS_0018.Analog;
