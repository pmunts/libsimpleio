-- HDC1080 Temperature/Humidity Sensor Test

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

-- Test with Digilent pMod HYGRO:
-- https://store.digilentinc.com/pmod-hygro-digital-humidity-and-temperature-sensor

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

WITH HDC1080;
WITH I2C.Remoteio;
WITH Humidity;
WITH RemoteIO.Client.libusb;
WITH Temperature;

PROCEDURE test_hdc1080 IS

  bus    : I2C.Bus;
  sensor : HDC1080.Device;

BEGIN
  New_Line;
  Put_Line("HDC1080 Temperature/Humidity Sensor Test");
  New_Line;

  bus    := I2C.RemoteIO.Create(RemoteIO.Client.libusb.Create, 0,
    HDC1080.MaxSpeed);

  sensor := HDC1080.Create(bus);

  Put("Manufacturer ID: ");
  Put(sensor.ManufacturerID, 8, 16);
  New_Line;

  Put("Device ID:       ");
  Put(sensor.DeviceID, 8, 16);
  New_Line;

  New_Line;
  Put_Line("Press CONTROL-C to exit...");
  New_Line;

  LOOP
    Put("Temperature: ");
    Temperature.Celsius_IO.Put(sensor.Get, 0, 1, 0);
    Put("  Humidity: ");
    Humidity.Relative_IO.Put(sensor.Get, 0, 1, 0);
    New_Line;

    DELAY 1.0;
  END LOOP;
END test_hdc1080;
