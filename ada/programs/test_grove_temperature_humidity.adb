-- Seeed Studio Grove Temperature and Humdity Sensor (TH02) Test.

-- Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Command_Line;

WITH Grove_Temperature_Humidity;
WITH Humidity;
WITH I2C.libsimpleio;
WITH Temperature;
WITH TH02;

PROCEDURE test_grove_temperature_humidity IS

  bus    : I2C.Bus;
  sensor : TH02.Device;

BEGIN
  New_Line;
  Put_Line("Seeed Studio Grove Temperature and Humdity Sensor (TH02) Test");
  New_Line;

  IF Ada.Command_Line.Argument_Count /= 1 THEN
    Put_Line("Usage: test_grove_temperature_humidity <bus>");
    New_Line;
    RETURN;
  END IF;

  bus    := I2C.libsimpleio.Create(Ada.Command_Line.Argument(1));
  sensor := Grove_Temperature_Humidity.Create(bus);

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
END test_grove_temperature_humidity;
