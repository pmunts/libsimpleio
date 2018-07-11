-- Test program for the PIC16F1455 HID Remote I/O Analog to Digital Converter

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

WITH ADC.RemoteIO;
WITH ADC.RemoteIO.PIC16F1455;
WITH HID.Munts;
WITH RemoteIO;
WITH Voltage;

PROCEDURE test_remoteio_hid_adc_pic16f1455 IS

  remdev : RemoteIO.Device;
  inputs : ARRAY (0 .. 4) OF Voltage.Interfaces.Input;

BEGIN
  New_Line;
  Put_Line("PIC16F1455 Remote I/O A/D Converter Test");
  New_Line;

  -- Open the remote I/O device

  remdev := RemoteIO.Create(HID.Munts.Create);

  -- Configure analog inputs

  FOR i IN inputs'Range LOOP
    inputs(i) := ADC.RemoteIO.PIC16F1455.Create(remdev, i);
  END LOOP;

  -- Display analog input voltages

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
END test_remoteio_hid_adc_pic16f1455;
