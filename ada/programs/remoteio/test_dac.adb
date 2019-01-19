-- USB HID Remote I/O DAC Output Test

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

WITH Analog;
WITH HID.hidapi;
WITH DAC.RemoteIO;
WITH RemoteIO.Client;

PROCEDURE test_dac IS

  remdev   : RemoteIO.Client.Device;
  channels : RemoteIO.ChannelSets.Set;

BEGIN
  New_Line;
  Put_Line("USB HID Remote I/O DAC Output Test");
  New_Line;

  -- Open the remote I/O device

  remdev := RemoteIO.Client.Create(HID.hidapi.Create);

  -- Query the available DAC outputs

  channels := remdev.GetAvailableChannels(RemoteIO.Channel_DAC);

  -- Check for empty set

  IF channels.Is_Empty THEN
    Put_Line("No DAC outputs available!");
    RETURN;
  END IF;

  Put("DAC outputs:");

  FOR c OF channels LOOP
    Put(Integer'Image(c));
  END LOOP;

  New_Line;
  New_Line;

  DECLARE

    -- Declare an array of Analog.Output sized to match the
    -- number of DAC outputs found

    outputs : ARRAY (1 .. Positive(channels.Length)) OF Analog.Output;
    count   : Natural := 0;

  BEGIN

    -- Initialize DAC outputs

    FOR c OF channels LOOP
      count := count + 1;
      outputs(count) := DAC.RemoteIO.Create(remdev, c);
    END LOOP;

    -- Generate sawtooth wave

    LOOP
      FOR i IN Analog.Sample RANGE 0 .. 4095 LOOP
        FOR outp OF outputs LOOP
          outp.Put(i);
        END LOOP;
      END LOOP;
    END LOOP;
  END;
END test_dac;
