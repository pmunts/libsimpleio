-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Exceptions;
WITH Ada.Strings.Fixed;
WITH Interfaces.C.Strings;

WITH HID.hidapi;
WITH RemoteIO.Client.hidapi;

USE TYPE Interfaces.C.Strings.chars_ptr;
USE TYPE RemoteIO.Client.Device;

PACKAGE BODY libRemoteIO IS

  NextAdapter : Natural := AdapterRange'First;

  PROCEDURE Open
   (VID     : Integer;
    PID     : Integer;
    serial  : Interfaces.C.Strings.chars_ptr;
    timeout : Integer;
    handle  : OUT Integer;
    error   : OUT Integer) IS

  BEGIN
    handle := -1;
    error  := EOK;

    -- Validate parameters

    IF (VID < 0) OR (PID < 0) THEN
      handle := -1;
      error := EINVAL;
    END IF;

    IF timeout < -1 THEN
      handle := -1;
      error := EINVAL;
    END IF;

    IF NextAdapter > AdapterRange'Last THEN
      handle := -1;
      error  := ENOMEM;
      RETURN;
    END IF;

    -- Open Remote I/O client device

    handle := NextAdapter;

    IF serial = Interfaces.C.Strings.Null_Ptr THEN
      AdapterTable(handle).dev := RemoteIO.Client.Create(HID.HIDAPI.Create(HID.Vendor(VID),
        HID.Product(PID), "", timeout));
    ELSE
      AdapterTable(handle).dev := RemoteIO.Client.Create(HID.HIDAPI.Create(HID.Vendor(VID),
        HID.Product(PID), Interfaces.C.Strings.Value(serial), timeout));
    END IF;

    NextAdapter := NextAdapter + 1;

    -- Get version and capability strings from the Remote I/O Protocol adapter

    AdapterTable(handle).version    := Ada.Strings.Unbounded.To_Unbounded_String(AdapterTable(handle).dev.GetVersion);
    AdapterTable(handle).capability := Ada.Strings.Unbounded.To_Unbounded_String(AdapterTable(handle).dev.GetCapability);

    -- Query the channels available for each hardware subsystem

    IF Ada.Strings.Unbounded.Index(AdapterTable(handle).capability, "ADC") > 0 THEN
      AdapterTable(handle).ADC_channels := AdapterTable(handle).dev.GetAvailableChannels(RemoteIO.Channel_ADC);
    END IF;

    IF Ada.Strings.Unbounded.Index(AdapterTable(handle).capability, "DAC") > 0 THEN
      AdapterTable(handle).DAC_channels := AdapterTable(handle).dev.GetAvailableChannels(RemoteIO.Channel_DAC);
    END IF;

    IF Ada.Strings.Unbounded.Index(AdapterTable(handle).capability, "GPIO") > 0 THEN
      AdapterTable(handle).GPIO_channels := AdapterTable(handle).dev.GetAvailableChannels(RemoteIO.Channel_GPIO);
    END IF;

    IF Ada.Strings.Unbounded.Index(AdapterTable(handle).capability, "I2C") > 0 THEN
      AdapterTable(handle).I2C_channels := AdapterTable(handle).dev.GetAvailableChannels(RemoteIO.Channel_I2C);
    END IF;

    IF Ada.Strings.Unbounded.Index(AdapterTable(handle).capability, "PWM") > 0 THEN
      AdapterTable(handle).PWM_channels := AdapterTable(handle).dev.GetAvailableChannels(RemoteIO.Channel_PWM);
    END IF;

    IF Ada.Strings.Unbounded.Index(AdapterTable(handle).capability, "SPI") > 0 THEN
      AdapterTable(handle).SPI_channels := AdapterTable(handle).dev.GetAvailableChannels(RemoteIO.Channel_SPI);
    END IF;

  EXCEPTION
    WHEN e: OTHERS =>
      handle := -1;
      error  := EIO;
  END Open;

-- Send a 64-byte message (aka report) to a USB Raw HID device.

  PROCEDURE Send
   (handle  : Integer;
    cmd     : IN Message64.Message;
    error   : OUT Integer) IS

  BEGIN
    error := EOK;

    -- Validate parameters

    IF (handle NOT IN AdapterRange) THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF AdapterTable(handle).dev = NULL THEN
      error := ENODEV;
    END IF;

    AdapterTable(handle).dev.GetMessenger.Send(cmd);

  EXCEPTION
    WHEN e : OTHERS =>
      error := EIO;
  END Send;

  -- Receive a 64-byte message (aka report) from a USB Raw HID device.

  PROCEDURE Receive
   (handle  : Integer;
    resp    : OUT Message64.Message;
    error   : OUT Integer) IS

  BEGIN
    error := EOK;

    -- Validate parameters

    IF (handle NOT IN AdapterRange) THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF AdapterTable(handle).dev = NULL THEN
      error := ENODEV;
    END IF;

    AdapterTable(handle).dev.GetMessenger.Receive(resp);

  EXCEPTION
    WHEN e : OTHERS =>
      error := EIO;
  END Receive;

END libRemoteIO;