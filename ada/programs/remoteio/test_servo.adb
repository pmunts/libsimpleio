-- USB HID Remote I/O Servo Output Test

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

WITH HID.hidapi;
WITH PWM.RemoteIO;
WITH RemoteIO.Client;
WITH Servo.PWM;

PROCEDURE test_servo IS

  remdev   : RemoteIO.Client.Device;
  channels : RemoteIO.ChannelSets.Set;

BEGIN
  New_Line;
  Put_Line("USB HID Remote I/O Servo Output Test");
  New_Line;

  -- Open the remote I/O device

  remdev := RemoteIO.Client.Create(HID.hidapi.Create);

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

    -- Declare an array of Servo.Interfaces.Output sized to match the
    -- number of PWM outputs found

    outputs : ARRAY (1 .. Positive(channels.Length)) OF Servo.Interfaces.Output;
    count   : Natural := 0;

  BEGIN

    -- Initialize servo outputs

    FOR c OF channels LOOP
      count := count + 1;
      outputs(count) := Servo.PWM.Create(PWM.RemoteIO.Create(remdev, c, 50), 50);
    END LOOP;

    -- Sweep servo outputs

    LOOP
      FOR i IN -100 .. 100 LOOP
        FOR outp OF outputs LOOP
          outp.Put(Servo.Position(Float(i)/100.0));
        END LOOP;
      END LOOP;

      FOR i IN REVERSE -100 .. 100 LOOP
        FOR outp OF outputs LOOP
          outp.Put(Servo.Position(Float(i)/100.0));
        END LOOP;
      END LOOP;
    END LOOP;
  END;
END test_servo;
