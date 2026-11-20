-- Raspberry Pi LPC1114 I/O Processor Expansion Board A/D converter services

-- Copyright (C)2013-2026, Philip Munts, President, Munts AM Corp.
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

WITH Interfaces.C;

WITH Discrete_To_Unsigned;
WITH lpc11xx;
WITH libspiagent;
WITH LPC1114IOP.Pins; USE LPC1114IOP.Pins;

USE TYPE Interfaces.C.int;
USE TYPE lpc11xx.pin_id_t;

PACKAGE BODY LPC1114IOP.ADC IS

  -- GPIO pin type transfer functions

  FUNCTION To_Unsigned IS NEW Discrete_To_Unsigned(lpc11xx.pin_id_t);

  -- Validate LPC1114 analog input pin number

  FUNCTION IsADC(pin : lpc11xx.pin_id_t) RETURN Boolean IS

  BEGIN
    RETURN (pin >= LPC1114_AD1) AND (pin <= LPC1114_AD5);
  END IsADC;

  -- ADC input object constructor

  FUNCTION Create(pin : lpc11xx.pin_id_t) RETURN Voltage.Input IS

    self : ADCInputClass;

  BEGIN
    self.Initialize(pin);
    RETURN NEW ADCInputClass'(self);
  END Create;

  -- ADC input object initializer

  PROCEDURE Initialize
   (self : OUT ADCInputClass;
    pin  : lpc11xx.pin_id_t) IS

    error : Interfaces.C.int;

  BEGIN
    IF NOT IsADC(pin) THEN
      RAISE LPC1114IOP.Error WITH "Invalid pin for analog input";
    END IF;

    libspiagent.spiagent_analog_configure(To_Unsigned(pin), error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_analog_configure() failed, error" &
        error'Image;
    END IF;

    self.pin := pin;
  END Initialize;

  -- Read from LPC1114 analog input pin

  FUNCTION Get(self : IN OUT ADCInputClass) RETURN Voltage.Volts IS

    V     : Interfaces.C.C_float;
    error : Interfaces.C.int;

  BEGIN
    libspiagent.spiagent_analog_get(To_Unsigned(self.pin), V, error);

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "spiagent_analog_get() failed, error" &
        error'Image;
    END IF;

    -- Check for error from the SPI Agent Firmware

    IF error /= 0 THEN
      RAISE LPC1114IOP.Error WITH "SPI Agent Firmware returned error" &
        error'Image;
    END IF;

    -- Return the value of the analog input pin

    RETURN Voltage.Volts(V);
  END Get;

END LPC1114IOP.ADC;
