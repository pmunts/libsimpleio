-- Seeed Studio Grove Temperature Sensor Module services

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

WITH Resistance;
WITH Temperature;
WITH Thermistor;

USE TYPE Temperature.Celsius;

PACKAGE BODY Grove_Temperature IS

  -- NCP18WF104F03RC thermistor B parameter equation characteristics

  B  : CONSTANT Float := 4250.0;
  R0 : CONSTANT Resistance.Ohms := 100_000.0;

  -- Instantiate an NTC thermistor model tailored for the particular
  -- thermistor on the Grove Temperature Sensor Module

  PACKAGE thermistor IS NEW Thermistor.NTC_B_Parms(B, R0);

  -- Module circuit characteristics

  Vcc  : CONSTANT Voltage.Volts := 3.3;
  Rdiv : CONSTANT Resistance.Ohms := 100_000.0;

  -- Constructor

  FUNCTION Create(input : NOT NULL Voltage.Input)
    RETURN Temperature.Input IS

  BEGIN
    RETURN NEW InputSubclass'(input => input);
  END Create;

  -- Implement the Temperature.InputInterface Get method

  FUNCTION Get(self : IN OUT InputSubclass) RETURN Temperature.Celsius IS

    V : Voltage.Volts;
    R : Resistance.Ohms;
    K : Temperature.Kelvins;

  BEGIN
    V := self.input.Get;
    R := Resistance.Ohms(Float(Rdiv)*Float(Vcc)/Float(V) - Float(Rdiv));
    K := thermistor.T(R);

    RETURN Temperature.Celsius(K) + Temperature.AbsoluteZero;
  END GET;

END Grove_Temperature;
