-- M5Stack Ultrasonic I2C Module SONAR Test

-- Copyright (C)2026, Philip Munts dba Munts Technologies.
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

WITH Distance;
WITH I2C.libsimpleio;
WITH M5Stack_Ultrasonic_I2C;
WITH RaspberryPi;

PROCEDURE test_m5stack_ultrasonic_i2c IS

  bus    : I2C.Bus;
  sensor : Distance.Input;

BEGIN
  New_Line;
  Put_Line("M5Stack Ultrasonic I2C Module SONAR Test");
  New_Line;

  bus    := I2C.libsimpleio.Create(RaspberryPi.I2C1);
  sensor := M5Stack_Ultrasonic_I2C.Create(bus);

  LOOP
    Distance.centimeters_IO.Put(Distance.ToCentimeters(sensor.Get), 1, 1, 0);
    New_Line;
    DELAY 0.5;
  END LOOP;
END test_m5stack_ultrasonic_i2c;
