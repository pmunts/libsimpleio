-- Seeed Studio Grove Temperature and Humdity Sensor (TH02) Services.

-- Copyright (C)2019-2023, Philip Munts dba Munts Technologies.
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

WITH Humidity;
WITH Temperature;
WITH I2C;
WITH TH02;

PACKAGE Grove_Temperature_Humidity IS

  -- Create a humidity sensor object

  FUNCTION Create(bus : NOT NULL I2C.Bus) RETURN Humidity.Input IS
   (Humidity.Input(TH02.Create(bus)));

  -- Create a temperature sensor object

  FUNCTION Create(bus : NOT NULL I2C.Bus) RETURN Temperature.Input IS
   (Temperature.Input(TH02.Create(bus)));

  -- Create a TH02 temperature and humidity sensor object

  FUNCTION Create(bus : NOT NULL I2C.Bus) RETURN TH02.Device IS
   (TH02.Create(bus));

END Grove_Temperature_Humidity;
