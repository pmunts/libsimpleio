-- Remote I/O Device Information Query

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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
WITH Ada.Strings.Fixed;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Message64.Ham1;
WITH RemoteIO.Client.WioE5_Ham1;

PROCEDURE test_query_wioe5_ham1 IS

  radio    : Message64.Ham1.driver.Device;
  node     : Message64.Ham1.driver.NodeID;
  remdev   : RemoteIO.Client.Device;
  channels : RemoteIO.ChannelSets.Set;

BEGIN
  New_Line;
  Put_Line("Remote I/O Device Information Query");
  New_Line;

  -- Check command line parameters

  IF Ada.Command_Line.Argument_Count /= 1 THEN
    Put_Line("Usage: test_wioe5_ham1 <node ID>");
    New_Line;
    RETURN;
  END IF;

  -- Create Wio-E5 LoRa Transceiver device

  radio := Message64.Ham1.driver.Create;
  node  := Message64.Ham1.driver.NodeID'Value(Ada.Command_Line.Argument(1));

  -- Create the remote I/O device

  remdev := RemoteIO.Client.WioE5_Ham1.Create(radio, node);

  -- Query the firmware version

  Put_Line("Information:        " & remdev.GetVersion);

  -- Query the capability string

  Put_Line("Capabilities:       " & remdev.GetCapability);

  IF Ada.Strings.Fixed.Index(remdev.GetCapability, "ADC") /= 0 THEN

    -- Query the available ADC input pins

    channels := remdev.GetAvailableChannels(RemoteIO.Channel_ADC);

    IF NOT channels.Is_Empty THEN
      Put("Found ADC inputs:  ");

      FOR pin OF channels LOOP
        Put(Integer'Image(pin));
      END LOOP;

      New_Line;
    END IF;
  END IF;

  IF Ada.Strings.Fixed.Index(remdev.GetCapability, "DAC") /= 0 THEN

    -- Query the available DAC output pins

    channels := remdev.GetAvailableChannels(RemoteIO.Channel_DAC);

    IF NOT channels.Is_Empty THEN
      Put("Found DAC outputs: ");

      FOR pin OF channels LOOP
        Put(Integer'Image(pin));
      END LOOP;

      New_Line;
    END IF;
  END IF;

  IF Ada.Strings.Fixed.Index(remdev.GetCapability, "GPIO") /= 0 THEN

    -- Query the available GPIO pins

    channels := remdev.GetAvailableChannels(RemoteIO.Channel_GPIO);

    IF NOT channels.Is_Empty THEN
      Put("Found GPIO pins:   ");

      FOR pin OF channels LOOP
        Put(Integer'Image(pin));
      END LOOP;

      New_Line;
    END IF;
  END IF;

  IF Ada.Strings.Fixed.Index(remdev.GetCapability, "I2C") /= 0 THEN

    -- Query the available I2C buses

    channels := remdev.GetAvailableChannels(RemoteIO.Channel_I2C);

    IF NOT channels.Is_Empty THEN
      Put("Found I2C buses:   ");

      FOR bus OF channels LOOP
        Put(Integer'Image(bus));
      END LOOP;

      NEW_Line;
    END IF;
  END IF;

  IF Ada.Strings.Fixed.Index(remdev.GetCapability, "PWM") /= 0 THEN

    -- Query the available PWM outputs

    channels := remdev.GetAvailableChannels(RemoteIO.Channel_PWM);

    IF NOT channels.Is_Empty THEN
      Put("Found PWM outputs: ");

      FOR dev OF channels LOOP
        Put(Integer'Image(dev));
      END LOOP;

      New_Line;
    END IF;
  END IF;

  IF Ada.Strings.Fixed.Index(remdev.GetCapability, "SPI") /= 0 THEN

    -- Query the available SPI devices

    channels := remdev.GetAvailableChannels(RemoteIO.Channel_SPI);

    IF NOT channels.Is_Empty THEN
      Put("Found SPI devices: ");

      FOR dev OF channels LOOP
        Put(Integer'Image(dev));
      END LOOP;

      New_Line;
    END IF;
  END IF;

  IF Ada.Strings.Fixed.Index(remdev.GetCapability, "DEVICE") /= 0 THEN

    -- Query the available abstract devices

    channels := remdev.GetAvailableChannels(RemoteIO.Channel_Device);

    IF NOT channels.Is_Empty THEN
      Put("Found devices:     ");

      FOR dev OF channels LOOP
        Put(Integer'Image(dev));
      END LOOP;

      New_Line;
    END IF;
  END IF;

  radio.Shutdown;

EXCEPTION
  WHEN OTHERS =>
    radio.Shutdown;
    RAISE;
END test_query_wioe5_ham1;
