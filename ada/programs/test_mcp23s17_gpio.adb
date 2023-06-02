-- Test an MCP23S17 as 16 individual GPIO pins

-- Copyright (C)2023, Philip Munts dba Munts Technologies.
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
WITH MCP23x17.GPIO;

PROCEDURE test_mcp23s17_gpio IS

  rstdesg : Device.Designator;
  rstpin  : GPIO.Pin;
  spidesg : Device.Designator;
  spidev  : SPI.Device;
  dev     : MCP23x17.Device;
  pins    : ARRAY (MCP23x17.GPIO.PinNumber) OF GPIO.Pin;

BEGIN
  New_Line;
  Put_Line("MCP23S17 GPIO Toggle Test");
  New_Line;

  -- Create GPIO pin for RST

  rstdesg := Device.GetDesignator("Enter RST pin         ");
  rstpin  := GPIO.libsimpleio.Create(rstdesg, GPIO.Output, True);
  New_Line;

  -- Create SPI slave device object

  spidesg := Device.GetDesignator("Enter SPI slave device");
  spidev  := SPI.libsimpleio.Create(spidesg, MCP23x17.SPI_Mode,
    MCP23x17.SPI_WordSize, MCP23x17.SPI_Frequency);
  New_Line;

  -- Create MCP23S17 device object

  dev := MCP23x17.Create(rstpin, spidev);

  -- Configure GPIO pins

  FOR n IN pins'Range LOOP
    pins(n) := MCP23x17.GPIO.Create(dev, n, GPIO.Output);
  END LOOP;

  -- Toggle GPIO pins

  Put_Line("Toggling pins...");

  LOOP
    FOR p OF pins LOOP
      p.Put(NOT p.Get);
    END LOOP;
  END LOOP;
END test_mcp23s17_gpio;
