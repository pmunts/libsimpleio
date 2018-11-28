-- MCP4822 SPI D/A Converter Test

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Command_Line;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Analog;
WITH MCP4822;
WITH SPI.libsimpleio;

USE TYPE Analog.Sample;

PROCEDURE test_mcp4822 IS

  spidev  : SPI.Device;
  outputs : ARRAY (MCP4822.Channel) OF Analog.Output;

BEGIN
  New_Line;
  Put_Line("MCP4822 SPI D/A Converter Test");
  New_Line;

  IF Ada.Command_Line.Argument_Count /= 1 THEN
    Put_Line("Usage: test_mcp4822 <device>");
    New_Line;
    RETURN;
  END IF;

  spidev := SPI.libsimpleio.Create(Ada.Command_Line.Argument(1),
    MCP4822.SPI_Mode, MCP4822.SPI_WordSize, MCP4822.SPI_Frequency);

  FOR c IN MCP4822.Channel LOOP
    outputs(c) := MCP4822.Create(spidev, c);
  END LOOP;

  Put_Line("Press CONTROL-C to exit...");
  New_Line;

  -- Generate sawtooth waveforms

  LOOP
    FOR n IN Analog.Sample RANGE 0 .. 4095 LOOP
      outputs(0).Put(n);
      outputs(1).Put(4095 - n);
    END LOOP;
  END LOOP;
END test_mcp4822;
