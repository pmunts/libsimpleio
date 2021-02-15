-- MPL3115A2 pressure and temperature sensor services

-- Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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
WITH Pressure;
WITH Temperature;

USE TYPE Pressure.Pascals;
USE TYPE Temperature.Celsius;

PACKAGE BODY MPL3115A2 IS

  -- Conversions between register data and Celsius require
  -- intermediate unsigned and signed 32-bit integer steps

  TYPE UnsignedPressureData IS MOD 2**32;
  FOR UnsignedPressureData'Size USE 32;

  TYPE SignedPressureData IS RANGE -2**31 .. 2**31-1;
  FOR SignedPressureData'Size USE 32;

  FUNCTION ToSignedPressureData IS NEW
    Ada.Unchecked_Conversion
     (Source => UnsignedPressureData,
      Target => SignedPressureData);

  -- Conversions between register data and Celsius require
  -- intermediate unsigned and signed 16-bit integer steps

  TYPE UnsignedTemperatureData IS MOD 2**16;
  FOR UnsignedTemperatureData'Size USE 16;

  TYPE SignedTemperatureData IS RANGE -2**15 .. 2**15-1;
  FOR SignedTemperatureData'Size USE 16;

  FUNCTION ToSignedTemperatureData IS NEW
    Ada.Unchecked_Conversion
     (Source => UnsignedTemperatureData,
      Target => SignedTemperatureData);

  -- MPL3115A2 sensor device object constructor

  FUNCTION Create
   (bus  : NOT NULL I2C.Bus;
    addr : I2C.Address := 16#60#) RETURN Device IS

    d : Device;

  BEGIN
    d := NEW DeviceSubclass'(bus, addr);

    d.WriteRegister(CTRL_REG1, 16#00#);
    d.WriteRegister(CTRL_REG2, 16#00#);
    d.WriteRegister(CTRL_REG3, 16#00#);
    d.WriteRegister(CTRL_REG4, 16#00#);
    d.WriteRegister(CTRL_REG5, 16#00#);

    RETURN d;
  END Create;

  -- Read MPL3115A2 register

  PROCEDURE ReadRegister
   (Self : DeviceSubclass;
    reg  : RegisterAddr;
    data : OUT RegisterData) IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 0);

  BEGIN
    cmd(0) := I2C.Byte(reg);
    Self.bus.Transaction(Self.address, cmd, 1, resp, 1);
    data := RegisterData(resp(0));
  END ReadRegister;

  -- Write MPL3115A2 register

  PROCEDURE WriteRegister
   (Self : DeviceSubclass;
    reg  : RegisterAddr;
    data : RegisterData) IS

    cmd  : I2C.Command(0 .. 1);

  BEGIN
    cmd(0) := I2C.Byte(reg);
    cmd(1) := I2C.Byte(data);

    Self.bus.Write(Self.address, cmd, 2);
  END WriteRegister;

  -- Read MPL3115A2 temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius IS

    cr1     : RegisterData;
    Thibyte : RegisterData;
    Tlobyte : RegisterData;

  BEGIN

    -- Initiate one shot sample by setting the OST bit

    Self.WriteRegister(CTRL_REG1, OST);

    -- Wait for the sampling process to complete, which is indicated
    -- when OST has been cleared automatically

    LOOP
      Self.ReadRegister(CTRL_REG1, cr1);
      EXIT WHEN (cr1 AND OST) = 0;
    END LOOP;

    -- Fetch temperature data bytes

    Self.ReadRegister(TEMP_HIGH, Thibyte);
    Self.ReadRegister(TEMP_LOW, Tlobyte);

    -- Return the temperature converted to Celsius value

    RETURN Temperature.Celsius(ToSignedTemperatureData(
      UnsignedTemperatureData(Thibyte)*256 +
      UnsignedTemperatureData(Tlobyte)))/TEMPERATURE_SCALE_FACTOR;
  END Get;

  -- Read MPL3115A2 barometric pressure

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Pressure.Pascals IS

    cr1       : RegisterData;
    Phighbyte : RegisterData;
    Pmidbyte  : RegisterData;
    Plowbyte  : RegisterData;

  BEGIN

    -- Initiate one shot sample by setting the OST bit

    Self.WriteRegister(CTRL_REG1, OST);

    -- Wait for the sampling process to complete, which is indicated
    -- when OST has been cleared automatically

    LOOP
      Self.ReadRegister(CTRL_REG1, cr1);
      EXIT WHEN (cr1 AND OST) = 0;
    END LOOP;

    -- Fetch pressure data bytes

    Self.ReadRegister(PRESSURE_HIGH, Phighbyte);
    Self.ReadRegister(PRESSURE_MID, Pmidbyte);
    Self.ReadRegister(PRESSURE_LOW, Plowbyte);

    -- Return the temperature converted to Celsius value

    RETURN Pressure.Pascals(ToSignedPressureData(
      UnsignedPressureData(Phighbyte)*65536 +
      UnsignedPressureData(Pmidbyte)*256 +
      UnsignedPressureData(Plowbyte)))/PRESSURE_SCALE_FACTOR;
  END Get;

END MPL3115A2;
