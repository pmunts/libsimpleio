-- TMP102 temperature sensor services

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

WITH I2C;
WITH Temperature;

PACKAGE TMP102 IS

  TYPE DeviceSubclass IS NEW Temperature.InputInterface WITH PRIVATE;

  TYPE Device IS ACCESS DeviceSubclass;

  TYPE RegisterName IS (TempReg, ConfigReg, LowLimit, HighLimit);

  TYPE RegisterData IS MOD 65536;

  MaxSpeed : CONSTANT := I2C.SpeedFast;

  -- Configuration register terms (can be OR'ed together)

  CONFIG_EM       : CONSTANT RegisterData := 2#0000_0000_0001_0000#;
  CONFIG_AL       : CONSTANT RegisterData := 2#0000_0000_0010_0000#;
  CONFIG_CR0      : CONSTANT RegisterData := 2#0000_0000_0100_0000#;
  CONFIG_CR1      : CONSTANT RegisterData := 2#0000_0000_1000_0000#;
  CONFIG_SD       : CONSTANT RegisterData := 2#0000_0001_0000_0000#;
  CONFIG_TM       : CONSTANT RegisterData := 2#0000_0010_0000_0000#;
  CONFIG_POL      : CONSTANT RegisterData := 2#0000_0100_0000_0000#;
  CONFIG_F0       : CONSTANT RegisterData := 2#0000_1000_0000_0000#;
  CONFIG_F1       : CONSTANT RegisterData := 2#0001_0000_0000_0000#;
  CONFIG_R0       : CONSTANT RegisterData := 2#0010_0000_0000_0000#;
  CONFIG_R1       : CONSTANT RegisterData := 2#0100_0000_0000_0000#;
  CONFIG_OS       : CONSTANT RegisterData := 2#1000_0000_0000_0000#;

  CONFIG_0P25HZ   : CONSTANT RegisterData := 2#0000_0000_0000_0000#;
  CONFIG_1HZ      : CONSTANT RegisterData := CONFIG_CR0;
  CONFIG_4HZ      : CONSTANT RegisterData := CONFIG_CR1;
  CONFIG_8HZ      : CONSTANT RegisterData := CONFIG_CR1 + CONFIG_CR0;

  CONFIG_FAULTS_1 : CONSTANT RegisterData := 2#0000_0000_0000_0000#;
  CONFIG_FAULTS_2 : CONSTANT RegisterData := CONFIG_F0;
  CONFIG_FAULTS_4 : CONSTANT RegisterData := CONFIG_F1;
  CONFIG_FAULTS_6 : CONSTANT RegisterData := CONFIG_F1 + CONFIG_F0;

  TYPE AlertMode IS (Comparator, Interrupt);

  TYPE AlertPolarity IS (ActiveLow, ActiveHigh);

  -- Convert RegisterData to Celsius

  SCALE_FACTOR : CONSTANT := 0.00390625;

  -- Object constructor

  FUNCTION Create
   (bus  : NOT NULL I2C.Bus;
    addr : I2C.Address) RETURN Device;

  -- Read TMP102 register

  PROCEDURE ReadRegister
   (Self : DeviceSubclass;
    reg  : RegisterName;
    data : OUT RegisterData);

  -- Write TMP102 register

  PROCEDURE WriteRegister
   (Self : DeviceSubclass;
    reg  : RegisterName;
    data : RegisterData);

  -- Configure the alert output pin

  PROCEDURE ConfigureAlert
   (Self     : DeviceSubclass;
    mode     : AlertMode;
    polarity : AlertPolarity;
    lowtemp  : Temperature.Celsius;
    hightemp : Temperature.Celsius);

  -- Sample TMP102 temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius;

PRIVATE

  TYPE DeviceSubclass IS NEW Temperature.InputInterface WITH RECORD
    bus     : I2C.Bus;
    address : I2C.Address;
  END RECORD;

END TMP102;
