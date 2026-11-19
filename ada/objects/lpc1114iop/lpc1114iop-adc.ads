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

WITH lpc11xx;
WITH Voltage;

PACKAGE LPC1114IOP.ADC IS

  -- ADC input type definitions

  TYPE ADCInputClass IS NEW Voltage.InputInterface WITH PRIVATE;

  -- Validate LPC1114 analog input pin number

  FUNCTION IsADC(pin: lpc11xx.pin_id_t) RETURN Boolean;

  -- ADC input object constructor

  FUNCTION Create(pin : lpc11xx.pin_id_t) RETURN Voltage.Input;

  -- ADC input object initializer

  PROCEDURE Initialize
   (self : OUT ADCInputClass;
    pin  : lpc11xx.pin_id_t);

  -- ADC input object method

  FUNCTION Get(self : IN OUT ADCInputClass) RETURN Voltage.Volts;
  
PRIVATE
  TYPE ADCInputClass IS NEW Voltage.InputInterface WITH RECORD
    pin : lpc11xx.pin_id_t;
  END RECORD;
END LPC1114IOP.ADC;
