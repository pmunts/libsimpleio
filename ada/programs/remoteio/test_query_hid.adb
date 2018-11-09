-- HID Remote I/O Device Information Query

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Strings.Fixed;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH ADC.RemoteIO;
WITH GPIO.RemoteIO;
WITH HID.libsimpleio.static;
WITH HID.Munts;
WITH I2C.RemoteIO;
WITH RemoteIO.Client;
WITH SPI.RemoteIO;

PROCEDURE test_query_hid IS

  PACKAGE VendorIO  IS NEW Integer_IO(HID.Vendor);
  PACKAGE ProductIO IS NEW Integer_IO(HID.Product);

  hiddev   : ALIASED HID.libsimpleio.MessengerSubclass;
  remdev   : RemoteIO.Client.Device;
  channels : RemoteIO.ChannelSets.Set;

BEGIN
  New_Line;
  Put_Line("HID Remote I/O Device Information Query");
  New_Line;

  -- Create the HID device

  hiddev := HID.libsimpleio.Static.Create(HID.Munts.VID, HID.Munts.PID);

  -- Create the remote I/O device

  remdev := RemoteIO.Client.Create(hiddev'Unchecked_Access);

  -- Query the HID device information

  Put_Line("HID device name:   " & hiddev.Name);
  Put_Line("HID bus type:     " & Natural'Image(hiddev.BusType));
  Put("HID vendor ID:     "); VendorIO.Put(hiddev.Vendor, 1, 16);   New_Line;
  Put("HID product ID:    "); ProductIO.Put(hiddev.Product, 1, 16); New_Line;

  -- Query the firmware version

  Put_Line("Firmware version:  " & remdev.GetVersion);

  -- Query the capability string

  Put_Line("Capabilities:      " & remdev.GetCapability);

  IF Ada.Strings.Fixed.Index(remdev.GetCapability, "ADC") /= 0 THEN

    -- Query the available ADC input pins

    channels := remdev.GetAvailableChannels(RemoteIO.Channel_ADC);

    IF NOT channels.Is_Empty THEN
      Put("Found ADC inputs: ");

      FOR pin OF channels LOOP
        Put(Integer'Image(pin));
      END LOOP;
    END IF;

    New_Line;
  END IF;

  IF Ada.Strings.Fixed.Index(remdev.GetCapability, "GPIO") /= 0 THEN

    -- Query the available GPIO pins

    channels := remdev.GetAvailableChannels(RemoteIO.Channel_GPIO);

    IF NOT channels.Is_Empty THEN
      Put("Found GPIO pins:  ");

      FOR pin OF channels LOOP
        Put(Integer'Image(pin));
      END LOOP;
    END IF;

    New_Line;
  END IF;

  IF Ada.Strings.Fixed.Index(remdev.GetCapability, "I2C") /= 0 THEN

    -- Query the available I2C buses

    channels := remdev.GetAvailableChannels(RemoteIO.Channel_I2C);

    IF NOT channels.Is_Empty THEN
      Put("Found I2C buses:  ");

      FOR bus OF channels LOOP
        Put(Integer'Image(bus));
      END LOOP;
    END IF;

    NEW_Line;
  END IF;

  IF Ada.Strings.Fixed.Index(remdev.GetCapability, "SPI") /= 0 THEN

    -- Query the available SPI devices

    channels := remdev.GetAvailableChannels(RemoteIO.Channel_SPI);

    IF NOT channels.Is_Empty THEN
      Put("Found SPI devices:");

      FOR dev OF channels LOOP
        Put(Integer'Image(dev));
      END LOOP;
    END IF;

    New_Line;
  END IF;

  New_Line;
END test_query_hid;
