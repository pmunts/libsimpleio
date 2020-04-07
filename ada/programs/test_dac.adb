-- DAC Output Test using kernel and libsimpleio DAC services

-- Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;

WITH Analog;
WITH DAC.libsimpleio;
WITH Device;

USE TYPE Analog.Sample;

PROCEDURE test_dac IS

  desg       : Device.Designator;
  resolution : Positive;
  DAC0       : Analog.Output;

BEGIN
  Put_Line("DAC Output Test");
  New_Line;

  Put("Enter DAC chip number:    ");
  Get(desg.chip);

  Put("Enter DAC channel number: ");
  Get(desg.chan);

  Put("Enter DAC resolution:     ");
  Get(resolution);

  -- Create DAC output object

  DAC0 := DAC.libsimpleio.Create(desg, resolution);

  -- Generate sawtooth wave

  LOOP
    FOR s IN Analog.Sample RANGE 0 .. 2**resolution - 1 LOOP
      DAC0.Put(s);
    END LOOP;
  END LOOP;
END test_dac;
