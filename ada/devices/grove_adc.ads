-- Seeed Studio Grove I2C ADC Module services

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

WITH ADC;
WITH ADC121C021;
WITH Analog;
WITH I2C;
WITH Voltage;

PACKAGE Grove_ADC IS

  DefaultAddress : CONSTANT I2C.Address := 16#50#;

  FUNCTION Create
   (bus  : NOT NULL I2C.Bus;
    addr : I2C.Address := DefaultAddress) RETURN Analog.Input IS
     (ADC121C021.Create(bus, addr));

  FUNCTION Create
   (bus  : NOT NULL I2C.Bus;
    addr : I2C.Address := DefaultAddress) RETURN Voltage.Input IS
     (ADC.Create(ADC121C021.Create(bus, addr), 3.0, 0.5));

END Grove_ADC;
