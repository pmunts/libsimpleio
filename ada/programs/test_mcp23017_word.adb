-- Test an MCP23017 as 1 16-bit parallel port

-- Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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
WITH I2C.libsimpleio;
WITH MCP23x17.Word;

USE TYPE MCP23x17.Word.Word;

PROCEDURE test_mcp23017_word IS

  PACKAGE Word_IO IS NEW Ada.Text_IO.Modular_IO(MCP23x17.Word.Word);
  USE Word_IO;

  rstdesg : Device.Designator;
  rstpin  : GPIO.Pin;
  i2cdesg : Device.Designator;
  i2cbus  : I2C.Bus;
  dev     : MCP23x17.Device;
  port    : MCP23x17.Word.Port;

BEGIN
  Put_Line("MCP23017 Word I/O Test");
  New_Line;

  -- Create GPIO pin for RST

  rstdesg := Device.GetDesignator("Enter RST pin");
  rstpin  := GPIO.libsimpleio.Create(rstdesg, GPIO.Output, True);
  New_Line;

  -- Create I2C bus object

  i2cdesg := Device.GetDesignator("Enter I2C bus");
  i2cbus  := I2C.libsimpleio.Create(i2cdesg);
  New_Line;

  -- Create MCP23017 device object

  dev := MCP23x17.Create(rstpin, i2cbus);

  -- Create 16-bit port object

  port := MCP23x17.Word.Create(dev);

  -- Configure port pins, alternating inputs and outputs

  port.SetDirections(16#AAAA#);
  port.SetPullups(16#5555#);

  -- Toggle outputs and read inputs

  LOOP
    FOR n IN MCP23x17.Word.Word LOOP
      port.Put(n);
      Put(port.Get AND 16#5555#, 0, 16);
      Put(ASCII.CR);
    END LOOP;
  END LOOP;

END test_mcp23017_word;
