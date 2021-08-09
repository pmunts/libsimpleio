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

PACKAGE BODY HDC1080 IS

  -- Object constructor

  FUNCTION Create(bus : NOT NULL I2C.Bus) RETURN Device IS

    dev : Device;

  BEGIN
    dev := NEW DeviceSubclass'(bus, 16#40#);

    -- Issue software reset

    dev.Put(RegConfiguration, 16#8000#);
    DELAY 0.1;

    -- Heater off, acquire temp or humidity, 14 bit resolutions

    dev.Put(RegConfiguration, 16#0000#);

    RETURN dev;
  END Create;

  -- Read from an HDC1080 device register

  FUNCTION Get
   (Self : DeviceSubclass;
    addr : RegisterAddress) RETURN RegisterData IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 1);

  BEGIN
    IF (addr > RegConfiguration) AND (addr < RegSerialNumberFirst) THEN
      RAISE HDC1080_Error WITH "Invalid register address";
    END IF;

    cmd(0) := I2C.Byte(addr);

    IF (addr = RegTemperature) OR (addr = RegHumidity) THEN
      Self.bus.Transaction(Self.address, cmd, cmd'Length, resp, resp'Length, 65535);
    ELSE
      Self.bus.Transaction(Self.address, cmd, cmd'Length, resp, resp'Length, 0);
    END IF;

    RETURN (RegisterData(resp(0))*256) + RegisterData(resp(1));
  END Get;

  -- Write to an HDC1080 device register

  PROCEDURE Put
   (Self : DeviceSubclass;
    addr : RegisterAddress;
    data : RegisterData) IS

    cmd : I2C.Command(0 .. 2);

  BEGIN
    IF (addr > RegConfiguration) AND (addr < RegSerialNumberFirst) THEN
      RAISE HDC1080_Error WITH "Invalid register address";
    END IF;

    cmd(0) := I2C.Byte(addr);
    cmd(1) := I2C.Byte(data / 256);
    cmd(2) := I2C.Byte(data MOD 256);

    Self.bus.Write(Self.address, cmd, cmd'Length);
  END Put;

  -- Get Celsius temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius IS

  BEGIN
    RETURN Temperature.Celsius(Float(Self.Get(RegTemperature))/65536.0*165.0 - 40.0);
  END Get;

  -- Get relative humidity

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Humidity.Relative IS

  BEGIN
    RETURN Humidity.Relative(Float(Self.Get(RegHumidity))/65536.0*100.0);
  END Get;

  -- Get manufacturer ID

  FUNCTION ManufacturerID(Self : IN OUT DeviceSubclass) RETURN Natural IS

  BEGIN
    RETURN Natural(Self.Get(RegManufacturerID));
  END ManufacturerID;

  -- Get device ID

  FUNCTION DeviceID(Self : IN OUT DeviceSubclass) RETURN Natural IS

  BEGIN
    RETURN Natural(Self.Get(RegDeviceID));
  END DeviceID;

END HDC1080;
