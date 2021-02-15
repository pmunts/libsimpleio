-- BMP280 pressure and temperature sensor services

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

PACKAGE BMP280 IS

  TYPE DeviceSubclass IS NEW Temperature.InputInterface AND
    Pressure.InputInterface WITH PRIVATE;

  TYPE Device IS ACCESS DeviceSubclass;

  -- BMP280 sensor object constructor

  FUNCTION Create(bus : NOT NULL I2C.Bus; addr : I2C.Address) RETURN Device;

  -- Read BMP280 pressure

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Pressure.Pascals;

  -- Read BMP280 temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius;

  MaxSpeed : CONSTANT := I2C.SpeedFast;

PRIVATE

  -- Define signed and unsigned 16-bit types for calibration data

  TYPE Signed16 IS RANGE -32768 .. 32767;
  FOR Signed16'Size USE 16;

  TYPE Unsigned16 IS MOD 2**16;
  FOR Unsigned16'Size USE 16;

  -- Finish defining Device

  TYPE DeviceSubclass IS NEW Temperature.InputInterface AND
    Pressure.InputInterface WITH RECORD
    bus     : I2C.Bus;
    address : I2C.Address;

    -- Calibration data follows

    dig_T1 : Unsigned16;
    dig_T2 : Signed16;
    dig_T3 : Signed16;
    dig_P1 : Unsigned16;
    dig_P2 : Signed16;
    dig_P3 : Signed16;
    dig_P4 : Signed16;
    dig_P5 : Signed16;
    dig_P6 : Signed16;
    dig_P7 : Signed16;
    dig_P8 : Signed16;
    dig_P9 : Signed16;
  END RECORD;

END BMP280;
