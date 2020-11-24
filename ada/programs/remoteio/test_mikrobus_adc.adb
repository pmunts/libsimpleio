-- Mikroelektronika mikroBUS GPIO Toggle Test

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Command_Line;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Analog;
WITH ADC.RemoteIO;
WITH ClickBoard.RemoteIO;
WITH RemoteIO.Client.libusb;

PROCEDURE test_mikrobus_adc IS

  remdev  : RemoteIO.Client.Device;
  socknum : Positive;
  socket  : ClickBoard.RemoteIO.Socket;
  input   : Analog.Input;

BEGIN
  New_Line;
  Put_Line("Mikroelektronika mikroBUS Analog Input Test");
  New_Line;

  -- Check command line parameters

  IF Ada.Command_Line.Argument_Count /= 1 THEN
    Put_Line("Usage: test_mikrobus_adc <sock num>");
    New_Line;
    RETURN;
  END IF;

  -- Configure the selected analog input

  socknum := Positive'Value(Ada.Command_Line.Argument(1));
  socket  := ClickBoard.RemoteIO.Create(socknum);
  remdev  := RemoteIO.Client.libusb.Create;
  input   := ADC.RemoteIO.Create(remdev, socket.AIN);

  -- Display analog samples

  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  LOOP
    Put("Sample:");
    Analog.Sample_IO.Put(input.Get, 5);
    New_Line;

    DELAY 2.0;
  END LOOP;
END test_mikrobus_adc;
