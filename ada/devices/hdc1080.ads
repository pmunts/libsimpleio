-- HDC1080 temperature and humidity sensor services

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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
WITH Humidity;
WITH Temperature;

PACKAGE HDC1080 IS

  HDC1080_Error : EXCEPTION;

  TYPE DeviceSubclass IS NEW Temperature.InputInterface AND
    Humidity.InputInterface WITH PRIVATE;

  TYPE Device IS ACCESS DeviceSubclass;

  MaxSpeed : CONSTANT := I2C.SpeedFast;

  -- Object constructor

  FUNCTION Create(bus : NOT NULL I2C.Bus) RETURN Device;

  -- Get Celsius temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius;

  -- Get relative humidity

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Humidity.Relative;

  -- Get manufacturer ID

  FUNCTION ManufacturerID(Self : IN OUT DeviceSubclass) RETURN Natural;

  -- Get device ID

  FUNCTION DeviceID(Self : IN OUT DeviceSubclass) RETURN Natural;

PRIVATE

  TYPE DeviceSubclass IS NEW Temperature.InputInterface AND
    Humidity.InputInterface WITH RECORD
    bus     : I2C.Bus;
    address : I2C.Address;
  END RECORD;

  TYPE RegisterAddress IS MOD 2**8;
  TYPE RegisterData    IS MOD 2**16;

  -- Register address constants

  RegTemperature        : CONSTANT RegisterAddress := 16#00#;
  RegHumidity           : CONSTANT RegisterAddress := 16#01#;
  RegConfiguration      : CONSTANT RegisterAddress := 16#02#;
  RegSerialNumberFirst  : CONSTANT RegisterAddress := 16#FB#;
  RegSerialNumberMiddle : CONSTANT RegisterAddress := 16#FC#;
  RegSerialNumberLast   : CONSTANT RegisterAddress := 16#FD#;
  RegManufacturerID     : CONSTANT RegisterAddress := 16#FE#;
  RegDeviceID           : CONSTANT RegisterAddress := 16#FF#;

  -- Read from an HDC1080 device register

  FUNCTION Get
   (Self : DeviceSubclass;
    addr : RegisterAddress) RETURN RegisterData;

  -- Write to an HDC1080 device register

  PROCEDURE Put
   (Self : DeviceSubclass;
    addr : RegisterAddress;
    data : RegisterData);

END HDC1080;
