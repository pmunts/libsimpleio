-- Generic package for an Analog Data Acquisition System

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

WITH Voltage;

USE TYPE Voltage.Volts;

PACKAGE BODY ADC.DAS IS

  -- Constructor

  FUNCTION Create
   (adcin     : Analog.Interfaces.Input;
    adcgain   : Voltage.Volts := Gain;
    adcoffset : Voltage.Volts := Offset) RETURN Input IS

  BEGIN
    RETURN NEW InputSubclass'(InputClass(adcin.ALL) WITH
      Reference/Voltage.Volts(2**Resolution), adcgain, adcoffset);
  END Create;

  -- Methods

  FUNCTION Get(self : IN OUT InputSubclass) RETURN Voltage.Volts IS

  BEGIN
    RETURN Voltage.Volts(Analog.Sample'(self.Get))*self.StepSize/self.gain -
      self.offset;
  END Get;

  PROCEDURE SetGain(self : IN OUT InputSubclass; gain : Voltage.Volts) IS

  BEGIN
    self.gain := gain;
  END SetGain;

  PROCEDURE SetOffset(self : IN OUT InputSubclass; offset : Voltage.Volts) IS

  BEGIN
    self.offset := offset;
  END SetOffset;

END ADC.DAS;
