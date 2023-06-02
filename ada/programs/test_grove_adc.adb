-- Seeed Studio Grove ADC Test

-- Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Command_Line;

WITH Grove_ADC;
WITH I2C;
WITH I2C.libsimpleio;
WITH Voltage;

PROCEDURE test_grove_adc IS

  bus   : I2C.Bus;
  input : Voltage.Input;

BEGIN
  New_Line;
  Put_Line("Seeed Studio Grove ADC Test");
  New_Line;

  IF Ada.Command_Line.Argument_Count /= 1 THEN
    Put_Line("Usage: test_grove_adc <bus>");
    New_Line;
    RETURN;
  END IF;

  bus   := I2C.libsimpleio.Create(Ada.Command_Line.Argument(1));
  input := Grove_ADC.Create(bus);

  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  LOOP
    Put("Voltage:");

    Voltage.Volts_IO.Put(input.Get, 0, 2, 0);
    Put_Line(" V");

    DELAY 2.0;
  END LOOP;
END test_grove_adc;
