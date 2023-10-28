-- MCP3208 SPI A/D Converter Test

-- Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Analog;
WITH Device;
WITH MCP3208;
WITH SPI.libsimpleio;

PROCEDURE test_mcp3208 IS

  desg   : Device.Designator;
  spidev : SPI.Device;
  inputs : ARRAY (MCP3208.Channel) OF Analog.Input;

BEGIN
  New_Line;
  Put_Line("MCP3208 SPI A/D Converter Test");
  New_Line;

  desg   := Device.GetDesignator("Enter SPI device: ");

  spidev := SPI.libsimpleio.Create(desg, MCP3208.SPI_Mode,
    MCP3208.SPI_WordSize, MCP3208.SPI_Frequency);

  FOR c IN MCP3208.Channel LOOP
    inputs(c) := MCP3208.Create(spidev, c);
  END LOOP;

  Put_Line("Press CONTROL-C to exit...");
  New_Line;

  LOOP
    Put("Samples:");

    FOR i OF inputs LOOP
      Analog.Sample_IO.Put(i.Get, 5);
    END LOOP;

    New_Line;

    DELAY 2.0;
  END LOOP;
END test_mcp3208;
