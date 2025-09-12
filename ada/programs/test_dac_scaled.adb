-- Scaled DAC output test using kernel and libsimpleio DAC services

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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

WITH libDAC;
WITH DAC.libsimpleio;
WITH Device;
WITH Voltage;

PROCEDURE test_dac_scaled IS

  desg  : Device.Designator;
  outp  : Voltage.Output;
  scale : Long_Float;
  vref  : Long_Float;
  error : Integer;
  Vout  : Voltage.Volts;

BEGIN
  New_Line;
  Put_Line("Scaled DAC Output Test");
  New_Line;

  Put("Enter DAC chip number:    ");
  Get(desg.chip);

  Put("Enter DAC channel number: ");
  Get(desg.chan);

  New_Line;

  outp := DAC.libsimpleio.Create(desg);

  libDAC.GetReference(desg.chip, vref, error);

  IF error = 0 THEN
    Put_Line("Reference:   " & vref'Image & " V");
  END IF;

  libDAC.GetScale(desg.chip, desg.chan, scale, error);

  IF error = 0 THEN
    Put_Line("Scale Factor:" & scale'Image);
  END IF;

  New_Line;

  Put("Enter DAC output voltage: ");
  Voltage.Volts_IO.Get(Vout);

  outp.Put(Vout);
END test_dac_scaled;
