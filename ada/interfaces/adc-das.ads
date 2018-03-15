-- Generic package for a Data Acquisition System

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

WITH ADC;
WITH Analog;
WITH Voltage;

GENERIC

  TYPE InputClass(<>) IS NEW Analog.Interfaces.InputInterface WITH PRIVATE;

  Resolution : IN Positive;
  Reference  : IN Voltage.Volts;
  Gain       : IN Voltage.Volts := 1.0;
  Offset     : IN Voltage.Volts := 0.0;

PACKAGE ADC.DAS IS

  -- Define subclass of InputClass

  TYPE InputSubclass IS NEW InputClass AND
    Voltage.Interfaces.InputInterface WITH PRIVATE;

  TYPE Input IS ACCESS InputSubClass;

  -- Constructor

  FUNCTION Create
   (adcin     : Analog.Interfaces.Input;
    adcgain   : Voltage.volts := Gain;
    adcoffset : Voltage.Volts := Offset) RETURN Input;

  -- Methods

  FUNCTION Get(self : IN OUT InputSubclass) RETURN Voltage.Volts;

  PROCEDURE SetGain(self : IN OUT InputSubclass; gain : Voltage.Volts);

  PROCEDURE SetOffset(self : IN OUT InputSubclass; offset : Voltage.Volts);

PRIVATE

  TYPE InputSubclass IS NEW Inputclass AND
    Voltage.Interfaces.InputInterface WITH RECORD
    Gain   : Voltage.Volts;
    Offset : Voltage.Volts;
  END RECORD;

END ADC.DAS;
