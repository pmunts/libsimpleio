-- MCP23017 I2C / MCP23S17 SPI GPIO expander device services

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

WITH I2C;
WITH SPI;

USE TYPE I2C.Bus;
USE TYPE SPI.Device;

USE TYPE I2C.Address;

PACKAGE BODY MCP23x17 IS

  -- MCP23x17 hardware reset

  PROCEDURE Reset(Self : IN DeviceClass) IS

  BEGIN
    Self.rstpin.Put(True);
    DELAY 0.000002;
    Self.rstpin.Put(False);
    DELAY 0.000002;
    Self.rstpin.Put(True);
    DELAY 0.000002;

    IF Self.spidev /= NULL THEN
      -- Set HAEN (Hardware Address Enable) for MCP23S17
      Self.WriteRegister8(IOCON, 16#08#);
    ELSE
      -- Clear HAEN (Hardware Address Enable) for MCP23017
      Self.WriteRegister8(IOCON, 16#00#);
    END IF;

    Self.WriteRegister16(IODIR,   16#FFFF#);
    Self.WriteRegister16(IPOL,    16#0000#);
    Self.WriteRegister16(GPINTEN, 16#0000#);
    Self.WriteRegister16(DEFVAL,  16#0000#);
    Self.WriteRegister16(INTCON,  16#0000#);
  END Reset;

  -- MCP23017 I2C device initializer

  PROCEDURE Initialize
   (Self   : OUT DeviceClass;
    rstpin : NOT NULL GPIO.Pin;
    bus    : NOT NULL I2C.Bus;
    addr   : Address := DefaultAddress) IS

  BEGIN
    Self.rstpin := rstpin;
    Self.i2cbus := bus;
    Self.spidev := NULL;
    Self.addr   := addr;
    Self.Reset;
  END Initialize;

  -- MCP23017 I2C device object constructor

  FUNCTION Create
   (rstpin : NOT NULL GPIO.Pin;
    bus    : NOT NULL I2C.Bus;
    addr   : Address := DefaultAddress) RETURN Device IS

    dev : DeviceClass;

  BEGIN
    dev.Initialize(rstpin, bus, addr);
    return NEW DeviceClass'(dev);
  END Create;

  -- MCP23S17 SPI device initializer

  PROCEDURE Initialize
   (Self   : OUT DeviceClass;
    rstpin : NOT NULL GPIO.Pin;
    spidev : NOT NULL SPI.Device;
    addr   : Address := DefaultAddress) IS

  BEGIN
    Self.rstpin := rstpin;
    Self.i2cbus := NULL;
    Self.spidev := spidev;
    Self.addr   := addr;
    Self.Reset;
  END Initialize;

  -- MCP23S17 SPI device object constructor

  FUNCTION Create
   (rstpin : NOT NULL GPIO.Pin;
    spidev : NOT NULL SPI.Device;
    addr   : Address := DefaultAddress) RETURN Device IS

    dev : DeviceClass;

  BEGIN
    dev.Initialize(rstpin, spidev, addr);
    return NEW DeviceClass'(dev);
  END Create;

  -- Read an 8-bit register

  PROCEDURE ReadRegister8
   (Self  : DeviceClass;
    reg   : RegisterAddress8;
    data  : OUT RegisterData8) IS

  BEGIN
    IF Self.i2cbus /= NULL THEN  -- MCP23017 I2C
      DECLARE
        cmd  : I2C.Command(0 .. 0);
        resp : I2C.Response(0 .. 0);
      BEGIN
        cmd(0) := I2C.Byte(reg);
        Self.i2cbus.Transaction(Self.addr, cmd, cmd'Length, resp, resp'Length);
        data := RegisterData8(resp(0));
      END;
    ELSIF Self.spidev /= NULL THEN  -- MCP23S17 SPI
      DECLARE
        cmd  : SPI.Command(0 .. 1);
        resp : SPI.Response(0 .. 0);
      BEGIN
        cmd(0) := SPI.Byte(Self.addr*2 + 1);
        cmd(1) := SPI.Byte(reg);
        Self.spidev.Transaction(cmd, cmd'Length, resp, resp'Length);
        data := RegisterData8(resp(0));
      END;
    ELSE
      RAISE Error WITH "Transport is undefined";
    END IF;
  END ReadRegister8;

  -- Write an 8-bit register

  PROCEDURE WriteRegister8
   (Self : DeviceClass;
    reg  : RegisterAddress8;
    data : RegisterData8) IS

  BEGIN
    IF Self.i2cbus /= NULL THEN  -- MCP23017 I2C
      DECLARE
        cmd  : I2C.Command(0 .. 1);
      BEGIN
        cmd(0) := I2C.Byte(reg);
        cmd(1) := I2C.Byte(data);
        Self.i2cbus.Write(Self.addr, cmd, cmd'Length);
      END;
    ELSIF Self.spidev /= NULL THEN  -- MCP23S17 SPI
      DECLARE
        cmd  : SPI.Command(0 .. 2);
      BEGIN
        cmd(0) := SPI.Byte(Self.addr*2);
        cmd(1) := SPI.Byte(reg);
        cmd(2) := SPI.Byte(data);
        Self.spidev.Write(cmd, cmd'Length);
      END;
    ELSE
      RAISE Error WITH "Transport is undefined";
    END IF;
  END WriteRegister8;

  -- Read a 16-bit register

  PROCEDURE ReadRegister16
   (Self  : DeviceClass;
    reg   : RegisterAddress16;
    data  : OUT RegisterData16) IS

  BEGIN
    IF Self.i2cbus /= NULL THEN  -- MCP23017 I2C
      DECLARE
        cmd  : I2C.Command(0 .. 0);
        resp : I2C.Response(0 .. 1);
      BEGIN
        cmd(0) := I2C.Byte(reg);
        Self.i2cbus.Transaction(Self.addr, cmd, cmd'Length, resp, resp'Length);
        data := RegisterData16(resp(0)) + RegisterData16(resp(1))*256;
      END;
    ELSIF Self.spidev /= NULL THEN  -- MCP23S17 SPI
      DECLARE
        cmd  : SPI.Command(0 .. 1);
        resp : SPI.Response(0 .. 1);
      BEGIN
        cmd(0) := SPI.Byte(Self.addr*2 + 1);
        cmd(1) := SPI.Byte(reg);
        Self.spidev.Transaction(cmd, cmd'Length, resp, resp'Length);
        data := RegisterData16(resp(0)) + RegisterData16(resp(1))*256;
      END;
    ELSE
      RAISE Error WITH "Transport is undefined";
    END IF;
  END ReadRegister16;

  -- Write a 16-bit register pair

  PROCEDURE WriteRegister16
   (Self : DeviceClass;
    reg  : RegisterAddress16;
    data : RegisterData16) IS

  BEGIN
    IF Self.i2cbus /= NULL THEN  -- MCP23017 I2C
      DECLARE
        cmd  : I2C.Command(0 .. 2);
      BEGIN
        cmd(0) := I2C.Byte(reg);
        cmd(1) := I2C.Byte(data MOD 256);
        cmd(2) := I2C.Byte(data / 256);
        Self.i2cbus.Write(Self.addr, cmd, cmd'Length);
      END;
    ELSIF Self.spidev /= NULL THEN  -- MCP23S17 SPI
      DECLARE
        cmd  : SPI.Command(0 .. 3);
      BEGIN
        cmd(0) := SPI.Byte(Self.addr*2);
        cmd(1) := SPI.Byte(reg);
        cmd(2) := SPI.Byte(data MOD 256);
        cmd(3) := SPI.Byte(data / 256);
        Self.spidev.Write(cmd, cmd'Length);
      END;
    ELSE
      RAISE Error WITH "Transport is undefined";
    END IF;
  END WriteRegister16;

END MCP23x17;
