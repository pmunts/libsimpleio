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

WITH Interfaces;
WITH Temperature;

USE TYPE Interfaces.Unsigned_32;
USE TYPE Temperature.Celsius;

PACKAGE BODY MAX31855 IS

  MASK_THERMO   : CONSTANT Interfaces.Unsigned_32 := 16#FFFC0000#;
  MASK_FAULT    : CONSTANT Interfaces.Unsigned_32 := 16#00010000#;
  MASK_INTERNAL : CONSTANT Interfaces.Unsigned_32 := 16#0000FFF0#;
  MASK_SHORTVCC : CONSTANT Interfaces.Unsigned_32 := 16#00000004#;
  MASK_SHORTGND : CONSTANT Interfaces.Unsigned_32 := 16#00000002#;
  MASK_OPEN     : CONSTANT Interfaces.Unsigned_32 := 16#00000001#;

  -- Object constructor

  FUNCTION Create(dev : NOT NULL SPI.Device) RETURN Device IS

  BEGIN
    RETURN NEW DeviceSubclass'(dev => dev);
  END Create;

  -- Get the 32-bit status word from the MAX31855

  FUNCTION GetRawData(Self : DeviceSubclass)
    RETURN Standard.Interfaces.Unsigned_32 IS

    respbuf : SPI.Response(0 .. 3);

  BEGIN
    Self.dev.Read(respbuf, respbuf'Length);

    RETURN Standard.Interfaces.Shift_Left(Standard.Interfaces.Unsigned_32(respbuf(0)), 24) +
           Standard.Interfaces.Shift_Left(Standard.Interfaces.Unsigned_32(respbuf(1)), 16) +
           Standard.Interfaces.Shift_Left(Standard.Interfaces.Unsigned_32(respbuf(2)),  8) +
           Standard.Interfaces.Unsigned_32(respbuf(3));
  END;

  -- Get thermocouple temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius IS

    rawdata  : Standard.Interfaces.Unsigned_32;
    tempdata : Standard.Interfaces.Unsigned_32;

  BEGIN
    rawdata := GetRawData(Self);

    -- Check for thermocouple input fault

    IF (rawdata AND MASK_FAULT) /= 0 THEN
      IF (rawdata AND MASK_SHORTVCC) /= 0 THEN
        RAISE Sensor_Error WITH "Thermocouple input is shorted to VCC";
      ELSIF (rawdata AND MASK_SHORTGND) /= 0 THEN
        RAISE Sensor_Error WITH "Thermocouple input is shorted to GND";
      ELSIF (rawdata AND MASK_OPEN) /= 0 THEN
        RAISE Sensor_Error WITH "Thermocouple input is open circuit";
      ELSE
        RAISE Sensor_Error WITH "General fault is posted but specific fault is not";
      END IF;
    END IF;

    -- Extract thermocouple temperature field

    tempdata := Standard.Interfaces.Shift_Right(rawdata AND MASK_THERMO, 18);

    -- Convert to Celsius

    IF tempdata > 8191 THEN
      RETURN -0.25*Temperature.Celsius(16384 - tempdata);
    ELSE
      RETURN 0.25*Temperature.Celsius(tempdata);
    END IF;
  END Get;

  -- Get reference junction temperature

  FUNCTION GetReferenceJunctionTemperature(Self : DeviceSubclass)
    RETURN Temperature.Celsius IS

    rawdata  : Standard.Interfaces.Unsigned_32;
    tempdata : Standard.Interfaces.Unsigned_32;

  BEGIN
    rawdata  := GetRawData(Self);

    -- Extract reference junction temperature field

    tempdata := Standard.Interfaces.Shift_Right(rawdata AND MASK_INTERNAL, 4);

    -- Convert to Celsius

    IF tempdata > 2047 THEN
      RETURN -0.0625*Temperature.Celsius(4096 - tempdata);
    ELSE
      RETURN 0.0625*Temperature.Celsius(tempdata);
    END IF;
  END GetReferenceJunctionTemperature;

  -- Get thermocouple fault condition

  FUNCTION Fault(Self : DeviceSubclass) RETURN SensorFaults IS

    rawdata : Standard.Interfaces.Unsigned_32;

  BEGIN
    rawdata := GetRawData(Self);

    IF (rawdata AND MASK_FAULT) = 0 THEN
      RETURN OK;
    END IF;

    IF (rawdata AND MASK_SHORTVCC) /= 0 THEN
      RETURN ShortVCC;
    END IF;

    IF (rawdata AND MASK_SHORTGND) /= 0 THEN
      RETURN ShortGND;
    END IF;

    IF (rawdata AND MASK_OPEN) /= 0 THEN
      RETURN Open;
    END IF;

    RAISE Sensor_Error WITH "General fault is posted but specific fault is not";
  END Fault;

END MAX31855;
