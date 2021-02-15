-- Abstract Digital to Analog Converter interface definitions

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

WITH Analog;
WITH Voltage;

PACKAGE DAC IS

  DAC_Error : EXCEPTION;

  TYPE OutputSubclass IS NEW Voltage.OutputInterface WITH PRIVATE;

  -- Constructor

  FUNCTION Create
   (output    : NOT NULL Analog.Output;
    reference : Voltage.Volts;
    gain      : Voltage.Volts := 1.0) RETURN Voltage.Output;

  -- Methods

  PROCEDURE Put(Self : IN OUT OutputSubclass; V : Voltage.Volts);

PRIVATE

  TYPE OutputSubclass IS NEW Voltage.OutputInterface WITH RECORD
    output   : Analog.Output;
    stepsize : Voltage.Volts;
  END RECORD;

END DAC;
