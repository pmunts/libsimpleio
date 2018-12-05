-- Raspberry Pi LPC1114 I/O Processor Expansion Board analog input test

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

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Interfaces;

WITH ADC.libspiagent;
WITH errno;
WITH libspiagent;
WITH LPC11xx;
WITH Voltage;

USE TYPE Interfaces.Integer_32;

PROCEDURE test_libspiagent_adc IS

  error  : Interfaces.Integer_32;

  pins   : CONSTANT ARRAY (1 .. 5) OF LPC11xx.pin_id_t :=
   (ADC.libspiagent.AD1,
    ADC.libspiagent.AD2,
    ADC.libspiagent.AD3,
    ADC.libspiagent.AD4,
    ADC.libspiagent.AD5);

  inputs : ARRAY (1 .. 5) OF Voltage.Interfaces.Input;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor Expansion Board ADC Test");
  New_Line;

  libspiagent.Open(libspiagent.Localhost, error);

  IF error /= 0 THEN
    RAISE Program_Error WITH "spiagent_open() failed, " &
      errno.strerror(Integer(error));
  END IF;

  FOR i IN inputs'Range LOOP
    inputs(i) := ADC.libspiagent.Create(pins(i));
  END LOOP;

  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  LOOP
    Put("Voltages:");

    FOR v OF inputs LOOP
      Voltage.Volts_IO.Put(v.Get, 3, 3, 0);
    END LOOP;

    New_Line;
    DELAY 2.0;
  END LOOP;
END test_libspiagent_adc;
