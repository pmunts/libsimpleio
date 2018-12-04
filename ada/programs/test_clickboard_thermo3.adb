-- Mikroelektronika Thermo3 Click Temperature Sensor Test

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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH ClickBoard.Thermo3.RemoteIO;
WITH HID.hidapi;
WITH RemoteIO.Client;
WITH TMP102;
WITH Temperature;

PROCEDURE test_clickboard_thermo3 IS

  remdev : RemoteIO.Client.Device;
  sensor : TMP102.Device;

BEGIN
  New_Line;
  Put_Line("Mikroelektronika Thermo3 Click Temperature Sensor Test");
  New_Line;

  remdev := RemoteIO.Client.Create(HID.hidapi.Create);
  sensor := ClickBoard.Thermo3.SimpleIO.Create(remdev, socknum => 1);

  Put_Line("Press CONTROL-C to exit...");
  New_Line;

  LOOP
    Put("Temperature: ");
    Temperature.Celsius_IO.Put(sensor.Get, 0, 1, 0);
    New_Line;

    DELAY 1.0;
  END LOOP;
END test_clickboard_thermo3;
