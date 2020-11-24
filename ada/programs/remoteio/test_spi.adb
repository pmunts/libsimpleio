-- USB HID remote I/O SPI test

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

WITH Ada.Command_Line;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH RemoteIO.Client.libusb;
WITH SPI.RemoteIO;

PROCEDURE test_spi IS

  remdev   : RemoteIO.Client.Device;
  devnum   : RemoteIO.ChannelNumber;
  mode     : Natural;
  wordsize : Natural;
  speed    : Natural;
  slave    : SPI.Device;
  outbuf   : SPI.Command(0 .. 31) := (OTHERS => 16#AA#);

BEGIN
  New_Line;
  Put_Line("USB HID Remote I/O SPI Test");
  New_Line;

  -- Check command line parameters

  IF Ada.Command_Line.Argument_Count /= 4 THEN
    Put_Line("Usage: test_spi <slave> <mode> <wordsize> <speed>");
    New_Line;
    RETURN;
  END IF;

  -- Convert command line parameters

  devnum   := RemoteIO.ChannelNumber'Value(Ada.Command_Line.Argument(1));
  mode     := Natural'Value(Ada.Command_Line.Argument(2));
  wordsize := Natural'Value(Ada.Command_Line.Argument(3));
  speed    := Natural'Value(Ada.Command_Line.Argument(4));

  -- Open the remote I/O device

  remdev := RemoteIO.Client.libusb.Create;

  -- Create the SPI slave device

  slave := SPI.RemoteIO.Create(remdev, devnum, mode, wordsize, speed);

  -- Write to the SPI slave device

  LOOP
    slave.Write(outbuf, outbuf'Length);
  END LOOP;
END test_spi;
