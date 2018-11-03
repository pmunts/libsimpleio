-- MCP2221 USB to I2C Device Services

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

WITH HID.libsimpleio;
WITH Message64;

USE TYPE Message64.Byte;

PACKAGE BODY MCP2221 IS

  FUNCTION Create
   (msg       : Message64.Messenger;
    pinmodes  : PinModeArray := AllGPIO) RETURN Device IS

    dev : DeviceClass := DeviceClass'(msg => msg);

  BEGIN
    dev.SetPinModes(pinmodes);

    RETURN NEW DeviceClass'(dev);
  END Create;

  FUNCTION Create
   (vid       : HID.Vendor   := VendorID;
    pid       : HID.Product  := ProductID;
    timeoutms : Integer      := 1000;
    pinmodes  : PinModeArray := AllGPIO) RETURN Device IS

    dev : DeviceClass :=
      DeviceClass'(msg => HID.libsimpleio.Create(vid, pid, timeoutms));

  BEGIN
    dev.SetPinModes(pinmodes);

    RETURN NEW DeviceClass'(dev);
  END Create;

  -- Issue a command to the MCP2221

  PROCEDURE Command
   (Self : DeviceClass;
    cmd  : Message64.Message;
    resp : OUT Message64.Message) IS

  BEGIN
    Self.msg.Send(cmd);
    Self.msg.Receive(resp);

    IF resp(0) /= cmd(0) THEN
      RAISE MCP2221_Error WITH "Command echo mismatch";
    END IF;

    IF resp(1) /= 0 THEN
      RAISE MCP2221_Error WITH "Command failed, error => " &
        Message64.Byte'Image(resp(1));
    END IF;
  END Command;

  -- Get MCP2221 revision information

  PROCEDURE GetRevisions
   (Self          : DeviceClass;
    HardwareMajor : OUT Character;
    HardwareMinor : OUT Character;
    FirmwareMajor : OUT Character;
    FirmwareMinor : OUT Character) IS

    cmd  : Message64.Message := (0 => CMD_SET_PARM, OTHERS => 0);
    resp : Message64.Message;

  BEGIN
    Self.Command(cmd, resp);

    HardwareMajor := Character'Val(resp(46));
    HardwareMinor := Character'Val(resp(47));
    FirmwareMajor := Character'Val(resp(48));
    FirmwareMinor := Character'Val(resp(49));
  END GetRevisions;

  -- Configure MCP2221 GPIO pin mux

  PROCEDURE SetPinModes
   (Self  : DeviceClass;
    Modes : PinModeArray := AllGPIO) IS

    cmd  : Message64.Message := (0 => CMD_SET_SRAM, 5 => 128, 7 => 255, OTHERS => 0);
    resp : Message64.Message;

  BEGIN
    FOR p IN PinNumber LOOP
      IF Modes(p) = MODE_GPIO THEN
        -- Configure pin as GPIO (and input, for now, to prevent output glitch)
        cmd(8 + Natural(p)) := 16#08#;
      ELSE
        -- Configure pin as special function
        cmd(8 + Natural(p)) := Message64.Byte(Modes(p));
      END IF;
    END LOOP;

    Self.Command(cmd, resp);
  END SetPinModes;

END MCP2221;
