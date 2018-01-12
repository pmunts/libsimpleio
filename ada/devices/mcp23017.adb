-- MCP23017 I2C GPIO expander device services

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

PACKAGE BODY MCP23017 IS

  -- MCP23017 device object constructor

  FUNCTION Create
   (bus  : I2C.Bus;
    addr : I2C.Address) RETURN Device IS

    dev : Device;

  BEGIN
    dev := NEW DeviceClass'(bus, addr);

    dev.WriteRegister8(IOCON,    16#00#);
    dev.WriteRegister16(IODIR,   16#FFFF#);
    dev.WriteRegister16(IPOL,    16#0000#);
    dev.WriteRegister16(GPINTEN, 16#0000#);
    dev.WriteRegister16(DEFVAL,  16#0000#);
    dev.WriteRegister16(INTCON,  16#0000#);

    return dev;
  END Create;

  -- Read an 8-bit register

  PROCEDURE ReadRegister8
   (self  : DeviceClass;
    reg   : RegisterAddress8;
    data  : OUT RegisterData8) IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 0);

  BEGIN
    cmd(0) := I2C.Byte(reg);

    self.bus.Transaction(self.address, cmd, cmd'Length, resp, resp'Length);

    data := RegisterData8(resp(0));
  END ReadRegister8;

  -- Write an 8-bit register

  PROCEDURE WriteRegister8
   (self : DeviceClass;
    reg  : RegisterAddress8;
    data : RegisterData8) IS

    cmd : I2C.Command(0 .. 1);

  BEGIN
    cmd(0) := I2C.Byte(reg);
    cmd(1) := I2C.Byte(data);

    self.bus.Write(self.address, cmd, cmd'Length);
  END WriteRegister8;

  -- Read a 16-bit register

  PROCEDURE ReadRegister16
   (self  : DeviceClass;
    reg   : RegisterAddress16;
    data  : OUT RegisterData16) IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 1);

  BEGIN
    cmd(0) := I2C.Byte(reg);

    self.bus.Transaction(self.address, cmd, cmd'Length, resp, resp'Length);

    data := RegisterData16(resp(0)) + RegisterData16(resp(1))*256;
  END ReadRegister16;

  -- Write a 16-bit register pair

  PROCEDURE WriteRegister16
   (self : DeviceClass;
    reg  : RegisterAddress16;
    data : RegisterData16) IS

    cmd : I2C.Command(0 .. 2);

  BEGIN
    cmd(0) := I2C.Byte(reg);
    cmd(1) := I2C.Byte(data MOD 256);
    cmd(2) := I2C.Byte(data / 256);

    self.bus.Write(self.address, cmd, cmd'Length);
  END WriteRegister16;

END MCP23017;
