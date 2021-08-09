-- TH02 temperature and humidity sensor services

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

WITH I2C;
WITH Humidity;
WITH Temperature;

PACKAGE TH02 IS

  TH02_Error : EXCEPTION;

  TYPE DeviceSubclass IS NEW Temperature.InputInterface AND
    Humidity.InputInterface WITH PRIVATE;

  TYPE Device IS ACCESS DeviceSubclass;

  MaxSpeed : CONSTANT := I2C.SpeedFast;

  -- Object constructor

  FUNCTION Create(bus : NOT NULL I2C.Bus) RETURN Device;

  -- Get Celsius temperature

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Temperature.Celsius;

  -- Get relative humidity

  FUNCTION Get(Self : IN OUT DeviceSubclass) RETURN Humidity.Relative;

  -- Get device ID

  FUNCTION DeviceID(Self : IN OUT DeviceSubclass) RETURN Natural;

PRIVATE

  TYPE DeviceSubclass IS NEW Temperature.InputInterface AND
    Humidity.InputInterface WITH RECORD
    bus     : I2C.Bus;
    address : I2C.Address;
  END RECORD;

  TYPE RegisterAddress IS MOD 2**8;
  TYPE RegisterData    IS MOD 2**8;
  TYPE RawData         IS MOD 2**16;

  -- TH02 register addresses

  RegStatus : CONSTANT RegisterAddress := 16#00#;
  RegDataH  : CONSTANT RegisterAddress := 16#01#;
  RegDataL  : CONSTANT RegisterAddress := 16#02#;
  RegConfig : CONSTANT RegisterAddress := 16#03#;
  RegID     : CONSTANT RegisterAddress := 16#11#;

  -- TH02 commands

  cmdInit   : CONSTANT RegisterData := 16#00#;  -- Turn heater off
  cmdTemp   : CONSTANT RegisterData := 16#11#;  -- Request temperature sample
  cmdHumid  : CONSTANT RegisterData := 16#01#;  -- Request humidity sample

  -- TH02 status masks

  mskBusy   : CONSTANT RegisterData := 16#01#;  -- Zero when conversion complete

  -- Linearization cofficients (from the TH02 datasheet)

  A0 : CONSTANT := -4.7844;
  A1 : CONSTANT := 0.4008;
  A2 : CONSTANT := -0.00393;

  Q0 : CONSTANT := 0.1973;
  Q1 : CONSTANT := 0.00237;

  -- Read from an TH02 device register

  FUNCTION Get
   (Self : DeviceSubclass;
    addr : RegisterAddress) RETURN RegisterData;

  -- Write to an TH02 device register

  PROCEDURE Put
   (Self : DeviceSubclass;
    addr : RegisterAddress;
    data : RegisterData);

  -- Request a raw data sample

  FUNCTION Get
   (Self : DeviceSubclass;
    what : RegisterData) RETURN RawData;

END TH02;
