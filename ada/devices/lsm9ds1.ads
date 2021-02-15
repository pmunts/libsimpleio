-- LSM9DS1 acceleration/gyroscope/magnetometer sensor services

-- Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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
WITH Accelerometer;
WITH Gyroscope;
WITH Magnetometer;
WITH Temperature;

PACKAGE LSM9DS1 IS

  TYPE DeviceSubclass IS NEW Accelerometer.InputInterface AND
    Gyroscope.InputInterface AND
    Magnetometer.InputInterface AND
    Temperature.InputInterface WITH PRIVATE;

  TYPE Device IS ACCESS DeviceSubclass;

  MaxSpeed : CONSTANT := I2C.SpeedFast;

  -- Object constructor

  FUNCTION Create
   (bus      : NOT NULL I2C.Bus;
    addr_acc : I2C.Address;
    addr_mag : I2C.Address) RETURN Device;

  -- Get acceleration vector

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Accelerometer.Vector;

  -- Get gyroscope vector

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Gyroscope.Vector;

  -- Get magnetometer vector

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Magnetometer.Vector;

  -- Get temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius;

PRIVATE

  TYPE DeviceSubclass IS NEW Accelerometer.InputInterface AND
    Gyroscope.InputInterface AND
    Magnetometer.InputInterface AND
    Temperature.InputInterface WITH RECORD
    bus      : I2C.Bus;
    addr_acc : I2C.Address;
    addr_mag : I2C.Address;
  END RECORD;

END LSM9DS1;
