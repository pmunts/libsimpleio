-- MUNTS-0018 Raspberry Pi Tutorial I/O Board A/D Converter Test

-- Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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
WITH RemoteIO.Client.hidapi;
WITH RemoteIO.MUNTS_0018;
WITH Voltage;

PROCEDURE test_munts_0018_adc IS

  remdev : RemoteIO.Client.Device;
  inputs : ARRAY (RemoteIO.MUNTS_0018.AnalogInputChannelRange) OF Voltage.Input;

BEGIN
  New_Line;
  Put_Line("MUNTS-0018 A/D Converter Test");
  New_Line;

  -- Open the remote I/O device

  remdev := RemoteIO.Client.hidapi.Create;

  -- Configure analog inputs

  FOR i IN inputs'Range LOOP
    inputs(i) := ADC.Create(ADC.RemoteIO.Create(remdev, i),
      RemoteIO.MUNTS_0018.AnalogInputReference);
  END LOOP;

  -- Sample analog voltages

  LOOP
    FOR inp OF inputs LOOP
      Voltage.Volts_IO.Put(inp.Get, 1, 3, 0);
      Put(" V   ");
    END LOOP;

    New_Line;

    DELAY 2.0;
  END LOOP;
END test_munts_0018_adc;
