-- Mikroelektronika Altitude Click Temperature/Pressure Sensor Test

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

-- NOTE: The temperature reading may be significantly higher than the actual
-- ambient temperature because of heat generated by the underlying CPU board.

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH ClickBoard.Altitude.RemoteIO;
WITH MPL3115A2;
WITH Pressure;
WITH RemoteIO.Client.hidapi;
WITH Temperature;

USE TYPE Pressure.Pascals;

PROCEDURE test_clickboard_altitude IS

  remdev : RemoteIO.Client.Device;
  sensor : MPL3115A2.Device;

BEGIN
  New_Line;
  Put_Line("Mikroelektronika Altitude Click Temperature Sensor/Pressure Test");
  New_Line;

  remdev := RemoteIO.Client.hidapi.Create;
  sensor := ClickBoard.Altitude.RemoteIO.Create(remdev, socknum => 1);

  Put_Line("Press CONTROL-C to exit...");
  New_Line;

  LOOP
    Put("Temperature: ");
    Temperature.Celsius_IO.Put(sensor.Get, 0, 1, 0);
    Put("  Pressure: ");
    Pressure.Pascals_IO.Put(sensor.Get/100.0, 0, 1, 0);
    Put(" hPa");
    New_Line;

    DELAY 1.0;
  END LOOP;
END test_clickboard_altitude;
