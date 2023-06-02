-- TH02 Temperature/Humidity Sensor Test

-- Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

-- Test with Grove Temperature & Humidity Sensor (High-Accuracy & Mini):
-- http://wiki.seeedstudio.com/Grove-TemptureAndHumidity_Sensor-High-Accuracy_AndMini-v1.0

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

WITH Humidity;
WITH I2C;
WITH MCP2221.hidapi;
WITH MCP2221.I2C;
WITH Temperature;
WITH TH02;

PROCEDURE test_th02 IS

  dev    : MCP2221.Device;
  bus    : I2C.Bus;
  sensor : TH02.Device;

BEGIN
  New_Line;
  Put_Line("TH02 Temperature/Humidity Sensor Test");
  New_Line;

  dev    := MCP2221.hidapi.Create;
  bus    := MCP2221.I2C.Create(dev);
  sensor := TH02.Create(bus);

  Put("Device ID: ");
  Put(sensor.DeviceID, 5, 16);
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
END test_th02;
