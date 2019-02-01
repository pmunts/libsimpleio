-- Remote I/O Abstract Device Test

-- Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

WITH RemoteIO_Abstract;
WITH RemoteIO.Client.hidapi;

PROCEDURE test_abstract_device IS

  remdev   : RemoteIO.Client.Device;
  channels : RemoteIO.ChannelSets.Set;
  dev      : RemoteIO_Abstract.Device;

BEGIN
  New_Line;
  Put_Line("Remote I/O Abstract Device Test");
  New_Line;

  -- Open the remote I/O device

  remdev := RemoteIO.Client.hidapi.Create;

  -- Query the abstract devices

  channels := remdev.GetAvailableChannels(RemoteIO.Channel_Device);

  -- Check for empty set

  IF channels.Is_Empty THEN
    Put_Line("No devices available!");
    RETURN;
  END IF;

  -- Display the abstract devices found

  Put("Devices:");

  FOR c OF channels LOOP
    Put(Integer'Image(c));
  END LOOP;

  New_Line;
  New_Line;

  -- Create an abstract device object

  dev := RemoteIO_Abstract.Create(remdev, 0);

  -- Display the abstract device info string

  Put_Line("Info: " & dev.GetInfo);
END test_abstract_device;
