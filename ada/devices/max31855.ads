-- MAX31855 thermocouple converter services

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

WITH SPI;
WITH Temperature;

PACKAGE MAX31855 IS

  Sensor_Error : EXCEPTION;

  TYPE DeviceSubclass IS NEW Temperature.InputInterface WITH PRIVATE;

  TYPE Device IS ACCESS DeviceSubclass;

  TYPE SensorFaults IS (OK, ShortVCC, ShortGND, Open);

  -- SPI transfer characteristics

  SPI_Mode      : CONSTANT Natural := 0;
  SPI_WordSize  : CONSTANT Natural := 8;
  SPI_Frequency : CONSTANT Natural := 5_000_000;

  -- Object constructor

  FUNCTION Create(dev : NOT NULL SPI.Device) RETURN Device;

  -- Get thermocouple temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius;

  -- Get reference junction temperature

  FUNCTION GetReferenceJunctionTemperature(Self : DeviceSubclass) RETURN Temperature.Celsius;

  -- Get thermocouple fault condition

  FUNCTION Fault(Self : DeviceSubclass) RETURN SensorFaults;

PRIVATE

  TYPE DeviceSubclass IS NEW Temperature.InputInterface WITH RECORD
    dev : SPI.Device;
  END RECORD;

END MAX31855;
