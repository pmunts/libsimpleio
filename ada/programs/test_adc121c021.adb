-- ADC121C021 A/D Converter Test

-- Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

-- Test with Grove I2C ADC module -- http://wiki.seeedstudio.com/Grove-I2C_ADC

-- NOTE: The documentation is inconsistent about which I2C slave address to
-- use:  Some places state 0x50 and others state 0x55.  The module used for
-- development of this program uses 0x50.

WITH Ada.Command_Line;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH ADC121C021;
WITH Analog;
WITH I2C.libsimpleio;

PROCEDURE test_adc121c021 IS

  bus   : I2C.Bus;
  input : Analog.Input;

BEGIN
  New_Line;
  Put_Line("ADC121C021 A/D Converter Test");
  New_Line;

  IF Ada.Command_Line.Argument_Count /= 2 THEN
    Put_Line("Usage: test_adc121c021 <bus> <addr>");
    New_Line;
    RETURN;
  END IF;

  -- Create I2C bus object

  bus := I2C.libsimpleio.Create(Ada.Command_Line.Argument(1));

  -- Create ADC121C021 input object

  input :=
    ADC121C021.Create(bus, I2C.Address'Value(Ada.Command_Line.Argument(2)));

  -- Display analog samples

  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  LOOP
    Put("Sample:");
    Analog.Sample_IO.Put(input.Get, 5);
    New_Line;

    DELAY 2.0;
  END LOOP;
END test_adc121c021;
