-- LSM9DS1 acceleration/gyroscope/magnetometer sensor services

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

WITH Accelerometer;
WITH Magnetometer;

USE TYPE Accelerometer.Gravities;
USE TYPE Magnetometer.Gauss;

PACKAGE BODY LSM9DS1 IS
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

  -- Register types

  TYPE RegisterAddress IS RANGE 0 .. 16#3F#;
  TYPE RegisterData    IS MOD 2**8;

  -- Accelerometer/Gyroscope register addresses

  ACT_THS          : CONSTANT RegisterAddress := 16#04#;
  ACT_DUR          : CONSTANT RegisterAddress := 16#05#;
  INT_GEN_CFG_XL   : CONSTANT RegisterAddress := 16#06#;
  INT_GEN_THS_X_XL : CONSTANT RegisterAddress := 16#07#;
  INT_GEN_THS_Y_XL : CONSTANT RegisterAddress := 16#08#;
  INT_GEN_THS_Z_XL : CONSTANT RegisterAddress := 16#09#;
  INT_GEN_DUR_XL   : CONSTANT RegisterAddress := 16#0A#;
  REFERENCE_G      : CONSTANT RegisterAddress := 16#0B#;
  INT1_CTRL        : CONSTANT RegisterAddress := 16#0C#;
  INT2_CTRL        : CONSTANT RegisterAddress := 16#0D#;
  WHO_AM_I         : CONSTANT RegisterAddress := 16#0F#;
  CTRL_REG1_G      : CONSTANT RegisterAddress := 16#10#;
  CTRL_REG2_G      : CONSTANT RegisterAddress := 16#11#;
  CTRL_REG3_G      : CONSTANT RegisterAddress := 16#12#;
  ORIENT_CFG_G     : CONSTANT RegisterAddress := 16#13#;
  INT_GEN_SRC_G    : CONSTANT RegisterAddress := 16#14#;
  OUT_TEMP_L       : CONSTANT RegisterAddress := 16#15#;
  OUT_TEMP_H       : CONSTANT RegisterAddress := 16#16#;
  STATUS_REG_G     : CONSTANT RegisterAddress := 16#17#;
  OUT_X_L_G        : CONSTANT RegisterAddress := 16#18#;
  OUT_X_H_G        : CONSTANT RegisterAddress := 16#19#;
  OUT_Y_L_G        : CONSTANT RegisterAddress := 16#1A#;
  OUT_Y_H_G        : CONSTANT RegisterAddress := 16#1B#;
  OUT_Z_L_G        : CONSTANT RegisterAddress := 16#1C#;
  OUT_Z_H_G        : CONSTANT RegisterAddress := 16#1D#;
  CTRL_REG4        : CONSTANT RegisterAddress := 16#1E#;
  CTRL_REG5_XL     : CONSTANT RegisterAddress := 16#1F#;
  CTRL_REG6_XL     : CONSTANT RegisterAddress := 16#20#;
  CTRL_REG7_XL     : CONSTANT RegisterAddress := 16#21#;
  CTRL_REG8        : CONSTANT RegisterAddress := 16#22#;
  CTRL_REG9        : CONSTANT RegisterAddress := 16#23#;
  CTRL_REG10       : CONSTANT RegisterAddress := 16#24#;
  INT_GEN_SRC_XL   : CONSTANT RegisterAddress := 16#26#;
  STATUS_REG_XL    : CONSTANT RegisterAddress := 16#27#;
  OUT_X_L_XL       : CONSTANT RegisterAddress := 16#28#;
  OUT_X_H_XL       : CONSTANT RegisterAddress := 16#29#;
  OUT_Y_L_XL       : CONSTANT RegisterAddress := 16#2A#;
  OUT_Y_H_XL       : CONSTANT RegisterAddress := 16#2B#;
  OUT_Z_L_XL       : CONSTANT RegisterAddress := 16#2C#;
  OUT_Z_H_XL       : CONSTANT RegisterAddress := 16#2D#;
  FIFO_CTRL        : CONSTANT RegisterAddress := 16#2E#;
  FIFO_SRC         : CONSTANT RegisterAddress := 16#2F#;
  INT_GEN_CFG_G    : CONSTANT RegisterAddress := 16#30#;
  INT_GEN_THS_XH_G : CONSTANT RegisterAddress := 16#31#;
  INT_GEN_THS_XL_G : CONSTANT RegisterAddress := 16#32#;
  INT_GEN_THS_YH_G : CONSTANT RegisterAddress := 16#33#;
  INT_GEN_THS_YL_G : CONSTANT RegisterAddress := 16#34#;
  INT_GEN_THS_ZH_G : CONSTANT RegisterAddress := 16#35#;
  INT_GEN_THS_ZL_G : CONSTANT RegisterAddress := 16#36#;
  INT_GEN_DUR_G    : CONSTANT RegisterAddress := 16#37#;

  -- Magnetometer registers

  OFFSET_X_REG_L_M : CONSTANT RegisterAddress := 16#05#;
  OFFSET_X_REG_H_M : CONSTANT RegisterAddress := 16#06#;
  OFFSET_Y_REG_L_M : CONSTANT RegisterAddress := 16#07#;
  OFFSET_Y_REG_H_M : CONSTANT RegisterAddress := 16#08#;
  OFFSET_Z_REG_L_M : CONSTANT RegisterAddress := 16#09#;
  OFFSET_Z_REG_H_M : CONSTANT RegisterAddress := 16#0A#;
  WHO_AM_I_M       : CONSTANT RegisterAddress := 16#0F#;
  CTRL_REG1_M      : CONSTANT RegisterAddress := 16#20#;
  CTRL_REG2_M      : CONSTANT RegisterAddress := 16#21#;
  CTRL_REG3_M      : CONSTANT RegisterAddress := 16#22#;
  CTRL_REG4_M      : CONSTANT RegisterAddress := 16#23#;
  CTRL_REG5_M      : CONSTANT RegisterAddress := 16#24#;
  STATUS_REG_M     : CONSTANT RegisterAddress := 16#27#;
  OUT_X_L_M        : CONSTANT RegisterAddress := 16#28#;
  OUT_X_H_M        : CONSTANT RegisterAddress := 16#29#;
  OUT_Y_L_M        : CONSTANT RegisterAddress := 16#2A#;
  OUT_Y_H_M        : CONSTANT RegisterAddress := 16#2B#;
  OUT_Z_L_M        : CONSTANT RegisterAddress := 16#2C#;
  OUT_Z_H_M        : CONSTANT RegisterAddress := 16#2D#;
  INT_CFG_M        : CONSTANT RegisterAddress := 16#30#;
  INT_SRC_M        : CONSTANT RegisterAddress := 16#31#;
  INT_THS_L        : CONSTANT RegisterAddress := 16#32#;
  INT_THS_H        : CONSTANT RegisterAddress := 16#33#;

  -- Scale factors

  ACC_SCALEFACTOR  : CONSTANT Accelerometer.Gravities := 8.0/32768.0;
  MAG_SCALEFACTOR  : CONSTANT Magnetometer.Gauss := 1.0;

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

  FUNCTION Create
   (bus      : NOT NULL I2C.Bus;
    addr_acc : I2C.Address;
    addr_mag : I2C.Address) RETURN Device IS

  BEGIN

    -- Write accelerometer and gyroscope configuration registers

    WriteRegister(bus, addr_acc, ACT_THS,          16#80#);
    WriteRegister(bus, addr_acc, ACT_DUR,          16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_CFG_XL,   16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_THS_X_XL, 16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_THS_Y_XL, 16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_THS_Z_XL, 16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_DUR_XL,   16#00#);
    WriteRegister(bus, addr_acc, REFERENCE_G,      16#00#);
    WriteRegister(bus, addr_acc, INT1_CTRL,        16#00#);
    WriteRegister(bus, addr_acc, INT2_CTRL,        16#00#);
    WriteRegister(bus, addr_acc, CTRL_REG1_G,      16#00#);
    WriteRegister(bus, addr_acc, CTRL_REG2_G,      16#00#);
    WriteRegister(bus, addr_acc, CTRL_REG3_G,      16#00#);
    WriteRegister(bus, addr_acc, CTRL_REG3_G,      16#00#);
    WriteRegister(bus, addr_acc, CTRL_REG4,        16#3A#);
    WriteRegister(bus, addr_acc, CTRL_REG5_XL,     16#38#);
    WriteRegister(bus, addr_acc, CTRL_REG6_XL,     16#38#);
    WriteRegister(bus, addr_acc, CTRL_REG7_XL,     16#00#);
    WriteRegister(bus, addr_acc, CTRL_REG8,        16#44#);
    WriteRegister(bus, addr_acc, CTRL_REG9,        16#00#);
    WriteRegister(bus, addr_acc, CTRL_REG10,       16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_CFG_G,    16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_THS_XL_G, 16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_THS_XH_G, 16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_THS_YL_G, 16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_THS_YH_G, 16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_THS_ZL_G, 16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_THS_ZH_G, 16#00#);
    WriteRegister(bus, addr_acc, INT_GEN_DUR_G,    16#00#);

    -- Write magnetometer configuration registers

    WriteRegister(bus, addr_mag, CTRL_REG1_M,      16#F0#);
    WriteRegister(bus, addr_mag, CTRL_REG2_M,      16#00#);
    WriteRegister(bus, addr_mag, CTRL_REG3_M,      16#00#);
    WriteRegister(bus, addr_mag, CTRL_REG4_M,      16#0C#);
    WriteRegister(bus, addr_mag, CTRL_REG5_M,      16#00#);

    RETURN NEW DeviceSubclass'(bus, addr_acc, addr_mag);
  END Create;

  -- Get acceleration vector

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Accelerometer.Vector IS

    cmd     : I2C.Command(0 .. 0);
    resp    : I2C.Response(0 .. 5);
    sampleX : Signed16;
    sampleY : Signed16;
    sampleZ : Signed16;
    X       : Accelerometer.Gravities;
    Y       : Accelerometer.Gravities;
    Z       : Accelerometer.Gravities;

  BEGIN
    cmd(0) := I2C.Byte(OUT_X_L_XL);
    Self.bus.Transaction(Self.addr_acc, cmd, cmd'Length, resp, resp'Length);

    SampleX := ToSigned16(Unsigned16(resp(0)) + Unsigned16(resp(1))*256);
    SampleY := ToSigned16(Unsigned16(resp(2)) + Unsigned16(resp(3))*256);
    SampleZ := ToSigned16(Unsigned16(resp(4)) + Unsigned16(resp(5))*256);

    X := Accelerometer.Gravities(SampleX)*ACC_SCALEFACTOR;
    Y := Accelerometer.Gravities(SampleY)*ACC_SCALEFACTOR;
    Z := Accelerometer.Gravities(SampleZ)*ACC_SCALEFACTOR;

    RETURN Accelerometer.Vector'(X, Y, Z);
  END Get;

  -- Get gyroscope vector

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Gyroscope.Vector IS

  BEGIN
    RETURN Gyroscope.Vector'(0.0, 0.0, 0.0);
  END Get;

  -- Get magnetic field vector

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Magnetometer.Vector IS

    cmd     : I2C.Command(0 .. 0);
    resp    : I2C.Response(0 .. 5);
    sampleX : Signed16;
    sampleY : Signed16;
    sampleZ : Signed16;
    X       : Magnetometer.Gauss;
    Y       : Magnetometer.Gauss;
    Z       : Magnetometer.Gauss;

  BEGIN
    cmd(0) := I2C.Byte(OUT_X_L_M);
    Self.bus.Transaction(Self.addr_mag, cmd, cmd'Length, resp, resp'Length);

    SampleX := ToSigned16(Unsigned16(resp(0)) + Unsigned16(resp(1))*256);
    SampleY := ToSigned16(Unsigned16(resp(2)) + Unsigned16(resp(3))*256);
    SampleZ := ToSigned16(Unsigned16(resp(4)) + Unsigned16(resp(5))*256);

    X := Magnetometer.Gauss(SampleX)*MAG_SCALEFACTOR;
    Y := Magnetometer.Gauss(SampleY)*MAG_SCALEFACTOR;
    Z := Magnetometer.Gauss(SampleZ)*MAG_SCALEFACTOR;

    RETURN Magnetometer.Vector'(X, Y, Z);
  END Get;

  -- Get temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius IS

    cmd    : I2C.Command(0 .. 0);
    resp   : I2C.Response(0 .. 1);
    sample : Signed16;

  BEGIN
    cmd(0) := I2C.Byte(OUT_TEMP_L);
    Self.bus.Transaction(Self.addr_acc, cmd, cmd'Length, resp, resp'Length);

    -- Convert from I2C bytes to 16-bit signed

    sample := ToSigned16(Unsigned16(resp(0)) + Unsigned16(resp(1))*256);

    -- Convert from 16-bit signed to Celsius

    RETURN Temperature.Celsius(Float(sample)/16.0 + 25.0);
  END Get;

END LSM9DS1;
