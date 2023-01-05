-- Test an MCP23S17 as 2 8-bit parallel ports

-- Copyright (C)2017-2023, Philip Munts, President, Munts AM Corp.
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

-- Test with Mikroelektronika Expand 2 Click: https://www.mikroe.com/expand-2-click
-- Default I2C address is 0x20

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Device;
WITH GPIO.libsimpleio;
WITH SPI.libsimpleio;
WITH MCP23x17.Byte;

PROCEDURE test_mcp23s17_byte IS

  PACKAGE Byte_IO IS NEW Ada.Text_IO.Modular_IO(MCP23x17.Byte.Byte);
  USE Byte_IO;

  rstdesg : Device.Designator;
  rstpin  : GPIO.Pin;
  spidesg : Device.Designator;
  spidev  : SPI.Device;
  dev     : MCP23x17.Device;
  PortA   : MCP23x17.Byte.Port;
  PortB   : MCP23x17.Byte.Port;

BEGIN
  New_Line;
  Put_Line("MCP23S17 Byte I/O Test");
  New_Line;

  -- Create GPIO pin for RST

  rstdesg := Device.GetDesignator("Enter RST pin");
  rstpin  := GPIO.libsimpleio.Create(rstdesg, GPIO.Output, True);
  New_Line;

  -- Create SPI slave device object

  spidesg := Device.GetDesignator("Enter SPI slave device");
  spidev  := SPI.libsimpleio.Create(spidesg, MCP23x17.SPI_Mode,
    MCP23x17.SPI_WordSize, MCP23x17.SPI_Frequency);
  New_Line;

  -- Create MCP23S17 device object

  dev := MCP23x17.Create(rstpin, spidev);

  -- Create 8-bit port objects

  PortA := MCP23x17.Byte.Create(dev, MCP23x17.Byte.GPA);
  PortB := MCP23x17.Byte.Create(dev, MCP23x17.Byte.GPB);

  -- Configure all port A pins as outputs

  PortA.SetDirections(16#FF#);
  PortB.SetPullups(16#00#);

  -- Configure all port B pins as inputs with pullups

  PortB.SetDirections(16#00#);
  PortB.SetPullups(16#FF#);

  -- Toggle port A outputs and read port B inputs

  LOOP
    FOR n IN MCP23x17.Byte.Byte LOOP
      PortA.Put(n);
      Put("PortB => ");
      Put(PortB.Get, 0, 16);
      Put(ASCII.CR);
    END LOOP;
  END LOOP;

END test_mcp23s17_byte;
