-- HTS221 temperature and humidity sensor services

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

PACKAGE BODY HTS221 IS
  PRAGMA Warnings(Off, "constant ""*"" is not referenced");
  PRAGMA Warnings(Off, "function ""ToUnsigned16"" is not referenced");

  -- Instantiate conversions between 16-bit signed and unsigned

  TYPE Signed16 IS RANGE -32768 .. 32767;
  FOR Signed16'Size USE 16;

  TYPE Unsigned16 IS MOD 2**16;
  FOR Unsigned16'Size USE 16;

  FUNCTION ToSigned16 IS NEW
    Ada.Unchecked_Conversion
     (Source => Unsigned16,
      Target => Signed16);

  FUNCTION ToUnsigned16 IS NEW
    Ada.Unchecked_Conversion
     (Source => Signed16,
      Target => Unsigned16);

  -- Register types

  TYPE RegisterAddress IS RANGE 0 .. 16#3F#;
  TYPE RegisterData    IS MOD 2**8;

  -- Register addresses

  WHO_AM_I       : CONSTANT RegisterAddress := 16#0F#;
  AV_CONF        : CONSTANT RegisterAddress := 16#10#;
  CTRL_REG1      : CONSTANT RegisterAddress := 16#20#;
  CTRL_REG2      : CONSTANT RegisterAddress := 16#21#;
  CTRL_REG3      : CONSTANT RegisterAddress := 16#22#;
  STATUS_REG     : CONSTANT RegisterAddress := 16#27#;
  HUMIDITY_OUT_L : CONSTANT RegisterAddress := 16#28#;
  HUMIDITY_OUT_H : CONSTANT RegisterAddress := 16#29#;
  TEMP_OUT_L     : CONSTANT RegisterAddress := 16#2A#;
  TEMP_OUT_H     : CONSTANT RegisterAddress := 16#2B#;
  CALIB_0        : CONSTANT RegisterAddress := 16#30#;
  CALIB_1        : CONSTANT RegisterAddress := 16#31#;
  CALIB_2        : CONSTANT RegisterAddress := 16#32#;
  CALIB_3        : CONSTANT RegisterAddress := 16#33#;
  CALIB_4        : CONSTANT RegisterAddress := 16#34#;
  CALIB_5        : CONSTANT RegisterAddress := 16#35#;
  CALIB_6        : CONSTANT RegisterAddress := 16#36#;
  CALIB_7        : CONSTANT RegisterAddress := 16#37#;
  CALIB_8        : CONSTANT RegisterAddress := 16#38#;
  CALIB_9        : CONSTANT RegisterAddress := 16#39#;
  CALIB_A        : CONSTANT RegisterAddress := 16#3A#;
  CALIB_B        : CONSTANT RegisterAddress := 16#3B#;
  CALIB_C        : CONSTANT RegisterAddress := 16#3C#;
  CALIB_D        : CONSTANT RegisterAddress := 16#3D#;
  CALIB_E        : CONSTANT RegisterAddress := 16#3E#;
  CALIB_F        : CONSTANT RegisterAddress := 16#3F#;

  -- Write an 8-bit register

  PROCEDURE WriteRegister8
   (bus     : I2C.Bus;
    addr    : I2C.Address;
    regaddr : RegisterAddress;
    regdata : RegisterData) IS

    cmd     : I2C.Command(0 .. 1);

  BEGIN
    cmd(0) := I2C.Byte(regaddr);
    cmd(1) := I2C.Byte(regdata);
    bus.Write(addr, cmd, cmd'Length);
  END WriteRegister8;

  -- Read an 8-bit register

  FUNCTION ReadRegister8
   (bus     : I2C.Bus;
    addr    : I2C.Address;
    regaddr : RegisterAddress) RETURN RegisterData IS

    cmd     : I2C.Command(0 .. 0);
    resp    : I2C.Response(0 .. 0);

  BEGIN
    cmd(0) := I2C.Byte(regaddr);
    bus.Transaction(addr, cmd, cmd'Length, resp, resp'Length);
    RETURN RegisterData(resp(0));
  END ReadRegister8;

  -- Read a signed 16-bit register pair

  FUNCTION ReadRegister16
   (bus     : I2C.Bus;
    addr    : I2C.Address;
    regaddr : RegisterAddress) RETURN Signed16 IS

  BEGIN
    RETURN ToSigned16(Unsigned16(ReadRegister8(bus, addr, regaddr+1))*256 +
                      Unsigned16(ReadRegister8(bus, addr, regaddr+0)));
  END ReadRegister16;

  -- Calculate the slope of a line from two points

  FUNCTION Slope(x1, y1, x2, y2 : Float) RETURN Float IS

  BEGIN
    RETURN (y2 - y1)/(x2 -x1);
  END Slope;

  -- Calculate the intercept of a line from two points

  FUNCTION Intercept(x1, y1, x2, y2 : Float) RETURN Float IS

  BEGIN
    RETURN y1 - Slope(x1, y1, x2, y2)*x1;
  END Intercept;

  -- Object constructor

  FUNCTION Create(bus : NOT NULL I2C.Bus; addr : I2C.Address) RETURN Device IS

    -- Calibration points

    HX1 : Float;
    HX2 : Float;
    HY1 : Float;
    HY2 : Float;
    TX1 : Float;
    TX2 : Float;
    TY1 : Float;
    TY2 : Float;

    -- Derived slopes and intercepts

    Tm, Tb, Hm, Hb : Float;

  BEGIN

    -- Write configuration registers

    WriteRegister8(bus, addr, CTRL_REG1, 16#87#); -- 12.5 Hz sample rate
    WriteRegister8(bus, addr, CTRL_REG2, 16#00#);
    WriteRegister8(bus, addr, CTRL_REG3, 16#00#);
    WriteRegister8(bus, addr, AV_CONF,   16#1A#); -- Average 16 samples

    -- Read humidity sensor calibration points

    HX1 := Float(ReadRegister16(bus, addr, CALIB_6));
    HX2 := Float(ReadRegister16(bus, addr, CALIB_A));
    HY1 := Float(ReadRegister8(bus, addr, CALIB_0))/2.0;
    HY2 := Float(ReadRegister8(bus, addr, CALIB_1))/2.0;

    -- Read temperature sensor calibration points

    TX1 := Float(ReadRegister16(bus, addr, CALIB_C));
    TX2 := Float(ReadRegister16(bus, addr, CALIB_E));
    TY1 := Float(Signed16(ReadRegister8(bus, addr, CALIB_2)) +
      (Signed16(ReadRegister8(bus, addr, CALIB_5) AND 2#00000011#)*256))/8.0;
    TY2 := Float(Signed16(ReadRegister8(bus, addr, CALIB_3)) +
      ((Signed16(ReadRegister8(bus, addr, CALIB_5) AND 2#00001100#)/4)*256))/8.0;

    -- Derive the temperature equation from the two calibration points

    Tm := Slope(TX1, TY1, TX2, TY2);
    Tb := Intercept(TX1, TY1, TX2, TY2);

    -- Derive the humidity equation from the two calibration points

    Hm := Slope(HX1, HY1, HX2, HY2);
    Hb := Intercept(HX1, HY1, HX2, HY2);

    RETURN NEW DeviceSubclass'(bus, addr, Tm, Tb, Hm, Hb);
  END Create;

  -- Get Celsius temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius IS

    S : Signed16;

  BEGIN
    S := ReadRegister16(Self.bus, Self.address, TEMP_OUT_L);
    RETURN Temperature.Celsius(Self.Tm*Float(S) + Self.Tb);
  END Get;

  -- Get relative humidity

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Humidity.Relative IS

    S : Signed16;

  BEGIN
    S := ReadRegister16(Self.bus, Self.address, HUMIDITY_OUT_L);
    RETURN Humidity.Relative(Self.Hm*Float(S) + Self.Hb);
  END Get;

END HTS221;
