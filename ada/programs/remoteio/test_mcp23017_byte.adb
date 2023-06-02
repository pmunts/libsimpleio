-- Test an MCP23017 as 2 8-bit parallel ports

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
WITH Ada.Integer_Text_IO;

WITH GPIO.RemoteIO;
WITH I2C.RemoteIO;
WITH MCP23x17;
WITH MCP23x17.Byte;
WITH RemoteIO.Client.hidapi;

PROCEDURE test_mcp23017_byte IS

  PACKAGE Byte_IO IS NEW Ada.Text_IO.Modular_IO(MCP23x17.Byte.Byte);
  USE Byte_IO;

  remdev  : RemoteIO.Client.Device;
  rstchan : RemoteIO.ChannelNumber;
  i2cchan : RemoteIO.ChannelNumber;
  rstpin  : GPIO.Pin;
  i2cbus  : I2C.Bus;
  dev     : MCP23x17.Device;
  PortA   : MCP23x17.Byte.Port;
  PortB   : MCP23x17.Byte.Port;

BEGIN
  Put_Line("MCP23017 Byte I/O Test");
  New_Line;

  -- Create Remote I/O Protocol server device

  remdev := RemoteIO.Client.hidapi.Create;

  -- Create reset pin

  Put("Enter reset pin channel number: ");
  Ada.Integer_Text_IO.Get(rstchan);
  New_Line;

  rstpin := GPIO.RemoteIO.Create(remdev, rstchan, GPIO.Output, False);

  -- Create I2C bus object

  Put("Enter I2C bus   channel number: ");
  Ada.Integer_Text_IO.Get(i2cchan);
  New_Line;

  i2cbus := I2C.RemoteIO.Create(remdev, i2cchan, MCP23x17.MaxSpeed);

  -- Create MCP23017 device object

  dev := MCP23x17.Create(rstpin, i2cbus, 16#20#);

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

END test_mcp23017_byte;
