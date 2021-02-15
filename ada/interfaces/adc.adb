-- Abstract Analog to Digital Converter interface definitions

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

WITH Voltage;

USE TYPE Voltage.Volts;

PACKAGE BODY ADC IS

  -- Constructor

  FUNCTION Create
   (input     : NOT NULL Analog.Input;
    reference : Voltage.Volts;
    gain      : Voltage.Volts := 1.0) RETURN Voltage.Input IS

  BEGIN
    IF reference = 0.0 THEN
      RAISE ADC_Error WITH "ERROR: reference voltage cannot be zero";
    END IF;

    IF gain = 0.0 THEN
      RAISE ADC_Error WITH "ERROR: gain cannot be zero";
    END IF;

    RETURN NEW InputSubclass'(input, reference/2.0**input.GetResolution/gain);
  END Create;

  -- Methods

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Voltage.Volts IS

  BEGIN
    RETURN Voltage.Volts(Self.input.Get)*Self.stepsize;
  END Get;

END ADC;
