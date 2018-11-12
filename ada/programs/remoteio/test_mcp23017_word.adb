-- Test an MCP23017 as 1 16-bit parallel port

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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH HID.libsimpleio;
WITH I2C.RemoteIO;
WITH MCP23017;
WITH MCP23017.Word;
WITH RemoteIO.Client;

USE TYPE MCP23017.Word.Word;

PROCEDURE test_mcp23017_word IS

  PACKAGE Word_IO IS NEW Ada.Text_IO.Modular_IO(MCP23017.Word.Word);
  USE Word_IO;

  bus   : I2C.Bus;
  dev   : MCP23017.Device;
  port  : MCP23017.Word.Port;

BEGIN
  Put_Line("MCP23017 Word I/O Test");
  New_Line;

  -- Create I2C bus object

  bus := I2C.RemoteIO.Create(RemoteIO.Client.Create(HID.libsimpleio.Create), 0,
    I2C.SpeedFast);

  -- Create MCP23017 device object

  dev   := MCP23017.Create(bus, 16#20#);

  -- Create 16-bit port object

  port := MCP23017.Word.Create(dev);

  -- Configure port pins, alternating inputs and outputs

  port.SetDirections(16#AAAA#);
  port.SetPullups(16#5555#);

  -- Toggle outputs and read inputs

  LOOP
    FOR n IN MCP23017.Word.Word LOOP
      port.Put(n);
      Put(port.Get AND 16#5555#, 0, 16);
      Put(ASCII.CR);
    END LOOP;
  END LOOP;

END test_mcp23017_word;
