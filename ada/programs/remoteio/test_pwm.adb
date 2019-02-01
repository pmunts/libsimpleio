-- USB HID Remote I/O PWM Output Test

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

WITH PWM.RemoteIO;
WITH RemoteIO.Client.hidapi;

PROCEDURE test_pwm IS

  remdev   : RemoteIO.Client.Device;
  channels : RemoteIO.ChannelSets.Set;

BEGIN
  New_Line;
  Put_Line("USB HID Remote I/O PWM Output Test");
  New_Line;

  -- Open the remote I/O device

  remdev := RemoteIO.Client.hidapi.Create;

  -- Query the available PWM outputs

  channels := remdev.GetAvailableChannels(RemoteIO.Channel_PWM);

  -- Check for empty set

  IF channels.Is_Empty THEN
    Put_Line("No PWM outputs available!");
    RETURN;
  END IF;

  Put("PWM outputs:");

  FOR outp OF channels LOOP
    Put(Integer'Image(outp));
  END LOOP;

  New_Line;
  New_Line;

  DECLARE

    -- Declare an array of PWM.Output sized to match the
    -- number of PWM outputs found

    outputs : ARRAY (1 .. Positive(channels.Length)) OF PWM.Output;
    count   : Natural := 0;

  BEGIN

    -- Initialize PWM outputs

    FOR c OF channels LOOP
      count := count + 1;
      outputs(count) := PWM.RemoteIO.Create(remdev, c, 1000);
    END LOOP;

    -- Sweep PWM outputs

    LOOP
      FOR i IN 0 .. 1000 LOOP
        FOR outp OF outputs LOOP
          outp.Put(PWM.DutyCycle(Float(i)/10.0));
        END LOOP;
      END LOOP;

      FOR i IN REVERSE 0 .. 1000 LOOP
        FOR outp OF outputs LOOP
          outp.Put(PWM.DutyCycle(Float(i)/10.0));
        END LOOP;
      END LOOP;
    END LOOP;
  END;
END test_pwm;
