-- USB HID remote I/O GPIO test

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

WITH GPIO.RemoteIO;
WITH HID.hidapi;
WITH RemoteIO.Client;

PROCEDURE test_gpio IS

  remdev   : RemoteIO.Client.Device;
  channels : RemoteIO.ChannelSets.Set;

BEGIN
  New_Line;
  Put_Line("USB HID Remote I/O GPIO Test");
  New_Line;

  -- Open the remote I/O device

  remdev := RemoteIO.Client.Create(HID.hidapi.Create);

  -- Query the available GPIO pins

  channels := remdev.GetAvailableChannels(RemoteIO.Channel_GPIO);

  -- Check for empty set

  IF channels.Is_Empty THEN
    Put_Line("No GPIO pins available!");
    RETURN;
  END IF;

  Put("GPIO pins:   ");

  FOR pin OF channels LOOP
    Put(Integer'Image(pin));
  END LOOP;

  New_Line;
  New_Line;

  DECLARE

    -- Declare an array of GPIO.Pin sized to match the
    -- number of GPIO pins found

    pins  : ARRAY (1 .. Positive(channels.Length)) OF GPIO.Pin;
    count : Natural := 0;

  BEGIN

    -- Initialize GPIO pins: All outputs initially turned off

    FOR pin OF channels LOOP
      count := count + 1;
      pins(count) := GPIO.RemoteIO.Create(remdev, pin, Standard.GPIO.Output,
        False);
    END LOOP;

    -- Toggle GPIO outputs

    LOOP
      FOR pin OF pins LOOP
        pin.Put(NOT pin.Get);
      END LOOP;
    END LOOP;
  END;
END test_gpio;
