-- LPS25H temperature and barometric pressure sensor services

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

WITH Ada.Unchecked_Conversion;

PACKAGE BODY LPS25H IS
  PRAGMA Warnings(Off, "constant ""*"" is not referenced");

  -- Define 16-bit signed and unsigned values

  TYPE Signed16 IS RANGE -2**15 .. 2**15-1;
  FOR Signed16'Size USE 16;

  TYPE Unsigned16 IS MOD 2**16;
  FOR Unsigned16'Size USE 16;

  FUNCTION ToSigned16 IS NEW
    Ada.Unchecked_Conversion
     (Source => Unsigned16,
      Target => Signed16);

  -- Define 24-bit signed and unsigned values

  TYPE Signed24 IS RANGE -2**23 .. 2**23-1;
  FOR Signed24'Size USE 24;

  TYPE Unsigned24 IS MOD 2**24;
  FOR Unsigned24'Size USE 24;

  FUNCTION ToSigned24 IS NEW
    Ada.Unchecked_Conversion
     (Source => Unsigned24,
      Target => Signed24);

  -- Register types

  TYPE RegisterAddress IS RANGE 0 .. 16#3F#;
  TYPE RegisterData    IS MOD 2**8;

  -- Register addresses

  REF_P_L      : CONSTANT RegisterAddress := 16#08#;
  REF_P_M      : CONSTANT RegisterAddress := 16#09#;
  REF_P_H      : CONSTANT RegisterAddress := 16#0A#;
  WHO_AM_I     : CONSTANT RegisterAddress := 16#0F#;
  RES_CONF     : CONSTANT RegisterAddress := 16#10#;
  CTRL_REG1    : CONSTANT RegisterAddress := 16#20#;
  CTRL_REG2    : CONSTANT RegisterAddress := 16#21#;
  CTRL_REG3    : CONSTANT RegisterAddress := 16#22#;
  CTRL_REG4    : CONSTANT RegisterAddress := 16#23#;
  INT_CFG      : CONSTANT RegisterAddress := 16#24#;
  INT_SOURCE   : CONSTANT RegisterAddress := 16#25#;
  STATUS_REG   : CONSTANT RegisterAddress := 16#27#;
  PRESS_OUT_L  : CONSTANT RegisterAddress := 16#28#;
  PRESS_OUT_M  : CONSTANT RegisterAddress := 16#29#;
  PRESS_OUT_H  : CONSTANT RegisterAddress := 16#2A#;
  TEMP_OUT_L   : CONSTANT RegisterAddress := 16#2B#;
  TEMP_OUT_H   : CONSTANT RegisterAddress := 16#2C#;
  FIFO_CTRL    : CONSTANT RegisterAddress := 16#2E#;
  FIFO_STATUS  : CONSTANT RegisterAddress := 16#2F#;
  THS_P_L      : CONSTANT RegisterAddress := 16#30#;
  THS_P_H      : CONSTANT RegisterAddress := 16#31#;
  RPDS_L       : CONSTANT RegisterAddress := 16#39#;
  RPDS_H       : CONSTANT RegisterAddress := 16#3A#;

  -- Write an 8-bit register

  PROCEDURE WriteRegister
   (bus     : I2C.Bus;
    addr    : I2C.Address;
    regaddr : RegisterAddress;
    regdata : RegisterData) IS

    cmd     : I2C.Command(0 .. 1);

  BEGIN
    cmd(0) := I2C.Byte(regaddr);
    cmd(1) := I2C.Byte(regdata);
    bus.Write(addr, cmd, cmd'Length);
  END WriteRegister;

  -- Read an 8-bit register

  FUNCTION ReadRegister
   (bus     : I2C.Bus;
    addr    : I2C.Address;
    regaddr : RegisterAddress) RETURN RegisterData IS

    cmd     : I2C.Command(0 .. 0);
    resp    : I2C.Response(0 .. 0);

  BEGIN
    cmd(0) := I2C.Byte(regaddr);
    bus.Transaction(addr, cmd, cmd'Length, resp, resp'Length);
    RETURN RegisterData(resp(0));
  END ReadRegister;

  -- Object constructor

  FUNCTION Create(bus : NOT NULL I2C.Bus; addr : I2C.Address) RETURN Device IS

  BEGIN

    -- Write configuration registers

    WriteRegister(bus, addr, CTRL_REG1, 16#B4#); -- 12.5 Hz sample rate
    WriteRegister(bus, addr, CTRL_REG2, 16#00#);
    WriteRegister(bus, addr, CTRL_REG3, 16#00#);
    WriteRegister(bus, addr, CTRL_REG4, 16#00#);
    WriteRegister(bus, addr, RES_CONF,  16#00#); -- Average 8 samples
    WriteRegister(bus, addr, REF_P_L,   16#00#); -- Measure absolute pressure
    WriteRegister(bus, addr, REF_P_M,   16#00#); -- Measure absolute pressure
    WriteRegister(bus, addr, REF_P_H,   16#00#); -- Measure absolute pressure

    RETURN NEW DeviceSubclass'(bus, addr);
  END Create;

  -- Get Celsius temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius IS

    sample : Signed16;

  BEGIN
    sample := ToSigned16
     (Unsigned16(ReadRegister(Self.bus, Self.address, TEMP_OUT_L)) +
      Unsigned16(ReadRegister(Self.bus, Self.address, TEMP_OUT_H))*256);

    RETURN Temperature.Celsius(42.5 + Float(sample)/480.0);
  END Get;

  -- Get barometric pressure

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Pressure.Pascals IS

    sample : Signed24;

  BEGIN
    sample := ToSigned24
     (Unsigned24(ReadRegister(Self.bus, Self.address, PRESS_OUT_L)) +
      Unsigned24(ReadRegister(Self.bus, Self.address, PRESS_OUT_M))*256 +
      Unsigned24(ReadRegister(Self.bus, Self.address, PRESS_OUT_H))*65536);

    RETURN Pressure.Pascals(Float(sample)/40.96);
  END Get;

END LPS25H;
