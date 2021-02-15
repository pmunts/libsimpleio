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

WITH I2C;
WITH Pressure;
WITH Temperature;

PACKAGE MPL3115A2 IS

  TYPE DeviceSubclass IS NEW Temperature.InputInterface AND
    Pressure.InputInterface WITH PRIVATE;

  TYPE Device IS ACCESS DeviceSubclass;

  TYPE RegisterAddr IS RANGE 16#00# .. 16#2D#;

  TYPE RegisterData IS MOD 256;

  MaxSpeed : CONSTANT := I2C.SpeedFast;

  -- Register addresses

  STATUS        : CONSTANT RegisterAddr := 16#00#;
  PRESSURE_HIGH : CONSTANT RegisterAddr := 16#01#;
  PRESSURE_MID  : CONSTANT RegisterAddr := 16#02#;
  PRESSURE_LOW  : CONSTANT RegisterAddr := 16#03#;
  TEMP_HIGH     : CONSTANT RegisterAddr := 16#04#;
  TEMP_LOW      : CONSTANT RegisterAddr := 16#05#;
  DEVICE_ID     : CONSTANT RegisterAddr := 16#0C#;
  CTRL_REG1     : CONSTANT RegisterAddr := 16#26#;
  CTRL_REG2     : CONSTANT RegisterAddr := 16#27#;
  CTRL_REG3     : CONSTANT RegisterAddr := 16#28#;
  CTRL_REG4     : CONSTANT RegisterAddr := 16#29#;
  CTRL_REG5     : CONSTANT RegisterAddr := 16#2A#;

  -- Register value constants

  OST           : CONSTANT RegisterData := 16#02#;

  -- Scale factors

  PRESSURE_SCALE_FACTOR    : CONSTANT Pressure.Pascals := 64.0;
  TEMPERATURE_SCALE_FACTOR : CONSTANT Temperature.Celsius := 256.0;

  -- MPL3115A2 sensor device object constructor

  FUNCTION Create
   (bus  : NOT NULL I2C.Bus;
    addr : I2C.Address := 16#60#) RETURN Device;

  -- Read MPL3115A2 register

  PROCEDURE ReadRegister
   (Self : DeviceSubclass;
    reg  : RegisterAddr;
    data : OUT RegisterData);

  -- Write MPL3115A2 register

  PROCEDURE WriteRegister
   (Self : DeviceSubclass;
    reg  : RegisterAddr;
    data : RegisterData);

  -- Read MPL3115A2 temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius;

  -- Read MPL3115A2 pressure

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Pressure.Pascals;

PRIVATE

  TYPE DeviceSubclass IS NEW Temperature.InputInterface AND
    Pressure.InputInterface WITH RECORD
    bus     : I2C.Bus;
    address : I2C.Address;
  END RECORD;

END MPL3115A2;
