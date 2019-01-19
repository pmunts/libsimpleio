-- USB HID Remote I/O A/D Converter Test

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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH ADC.RemoteIO;
WITH Analog;
WITH HID.hidapi;
WITH RemoteIO.Client;

PROCEDURE test_adc IS

  remdev   : RemoteIO.Client.Device;
  channels : RemoteIO.ChannelSets.Set;

BEGIN
  New_Line;
  Put_Line("USB HID Remote I/O A/D Converter Test");
  New_Line;

  -- Open the remote I/O device

  remdev := RemoteIO.Client.Create(HID.hidapi.Create);

  -- Query the available analog input pins

  channels := remdev.GetAvailableChannels(RemoteIO.Channel_ADC);

  -- Check for empty set

  IF channels.Is_Empty THEN
    Put_Line("No analog inputs available!");
    RETURN;
  END IF;

  Put("ADC inputs:");

  FOR c OF channels LOOP
    Put(Integer'Image(c));
  END LOOP;

  New_Line;
  New_Line;

  DECLARE

    -- Declare an array of Analog.Input sized to match the
    -- number of ADC inputs found

    inputs : ARRAY (1 .. Positive(channels.Length)) OF Analog.Input;
    count  : Natural := 0;

  BEGIN

    -- Initialize ADC outputs

    FOR c OF channels LOOP
      count := count + 1;
      inputs(count) := ADC.RemoteIO.Create(remdev, c);
    END LOOP;

    -- Sample analog inputs

    LOOP
      Put("Samples:");

      FOR inp OF inputs LOOP
        Analog.Sample_IO.Put(inp.Get, 5);
      END LOOP;

      New_Line;

      DELAY 2.0;
    END LOOP;
  END;
END test_adc;
