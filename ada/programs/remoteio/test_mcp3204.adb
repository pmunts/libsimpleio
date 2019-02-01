-- MCP3204 SPI A/D Converter Test

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

-- Test with Mikroelektronika ADC Click: https://www.mikroe.com/adc-click

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Analog;
WITH MCP3204;
WITH RemoteIO.Client.hidapi;
WITH SPI.RemoteIO;

PROCEDURE test_mcp3204 IS

  remdev : RemoteIO.Client.Device;
  spidev : SPI.Device;
  inputs : ARRAY (MCP3204.Channel) OF Analog.Input;

BEGIN
  New_Line;
  Put_Line("MCP3204 SPI A/D Converter Test");
  New_Line;

  remdev := RemoteIO.Client.hidapi.Create;

  spidev := SPI.RemoteIO.Create(remdev, 0, MCP3204.SPI_Mode,
    MCP3204.SPI_WordSize, MCP3204.SPI_Frequency);

  FOR c IN MCP3204.Channel LOOP
    inputs(c) := MCP3204.Create(spidev, c);
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
END test_mcp3204;
