-- ADS1015 Analog to Digital Converter services

-- Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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

-- NOTE: The ADS1015 is a true differential 12-bit A/D converter producing
-- two's complement samples.
--
-- In differential input mode, sample values range from -2048 to +2047.
-- In single ended input mode, sample values range from 0 to +2047.
--
-- Since Analog.Sample is unsigned, special care must be taken when converting
-- Analog.Sample from the Get() method to Voltage.Volts.

WITH Analog;
WITH I2C;
WITH Voltage;

PACKAGE ADS1015 IS

  Resolution : CONSTANT := 12;

  -- Define a subclass of Analog.InputInterface

  TYPE InputSubclass IS NEW Analog.InputInterface WITH PRIVATE;

  -- Full scale range selectors in millivolts

  TYPE FullScaleRange IS (FSR6144, FSR4096, FSR2048, FSR1024, FSR512, FSR256);

  -- Analog input channel selectors

  TYPE Channel IS (AIN0, AIN1, AIN2, AIN3,  DIFF01, DIFF03, DIFF13, DIFF23);

  MaxSpeed : CONSTANT := I2C.SpeedFast;

  -- Analog input constructor

  FUNCTION Create(bus : NOT NULL I2C.Bus; addr : I2C.Address; chan : Channel;
    fsr : FullScaleRange) RETURN Analog.Input;

  -- Analog input method

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Analog.Sample;

  -- Retrieve resolution

  FUNCTION GetResolution(Self : IN OUT InputSubclass) RETURN Positive;

  -- Retrieve PGA gain

  FUNCTION GetGain(Self : IN OUT InputSubclass) RETURN Voltage.Volts;

PRIVATE

  TYPE RegData IS MOD 2**16;

  TYPE InputSubclass IS NEW Analog.InputInterface WITH RECORD
    bus  : I2C.Bus;
    addr : I2C.Address;
    mux  : RegData;
    pga  : RegData;
    gain : Voltage.Volts;
  END RECORD;

END ADS1015;
