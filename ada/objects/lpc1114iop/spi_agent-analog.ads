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

PACKAGE spi_agent.analog IS

  LPC1114_ADC_SPAN     : constant := 3.3;		-- Volts
  LPC1114_ADC_BITS     : constant := 10;		-- Bits
  LPC1114_ADC_STEPS    : constant := 1024;		-- Levels
  LPC1114_ADC_STEPSIZE : constant := 0.00322265625;	-- Volts

  -- Analog input type definitions

  TYPE analog_channel_t IS NEW Natural RANGE 1 .. 5;

  TYPE analog_voltage_t IS NEW Float RANGE 0.0 .. LPC1114_ADC_SPAN;

  TYPE ADC IS TAGGED PRIVATE;

  -- Analog input operations

  FUNCTION IsAnalog(pin: pin_id_t) RETURN Boolean;

  FUNCTION Create(pin : pin_id_t) RETURN ADC;

  FUNCTION Create(channel : analog_channel_t) RETURN ADC;

  FUNCTION Get(self : ADC) RETURN analog_voltage_t;

PRIVATE
  TYPE ADC IS TAGGED RECORD
    pin : pin_id_t;
  END RECORD;
END spi_agent.analog;
