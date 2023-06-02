-- USB HID Remote I/O GPIO Output Toggle Test

-- Copyright (C)2016-2023, Philip Munts dba Munts Technologies.
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

WITH GPIO.RemoteIO;
WITH RemoteIO.Client.hidapi;

PROCEDURE test_gpio IS

  remdev   : RemoteIO.Client.Device;
  channels : RemoteIO.ChannelSets.Set;
  num      : Natural;
  outp     : GPIO.Pin;

BEGIN
  New_Line;
  Put_Line("USB HID Remote I/O GPIO Output Toggle Test");
  New_Line;

  -- Open the remote I/O device

  remdev := RemoteIO.Client.hidapi.Create;

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
  Put("Enter GPIO pin number: ");
  Get(num);
  New_Line;

  -- Create GPIO output object

  outp := GPIO.RemoteIO.Create(remdev, num, GPIO.Output);

  -- Toggle the GPIO output

  LOOP
    outp.Put(NOT outp.Get);
  END LOOP;
END test_gpio;
