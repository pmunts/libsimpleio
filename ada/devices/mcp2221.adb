-- MCP2221 Device Services

-- Copyright (C)2018-2023, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Characters.Conversions;
WITH Ada.Strings.Fixed;

WITH Messaging;

USE TYPE Messaging.Byte;

PACKAGE BODY MCP2221 IS
  PRAGMA Warnings(Off, """*"" modified by call, but value might not be referenced");

  -- Create an MCP2221 device object instance

  FUNCTION Create
   (msg       : NOT NULL Message64.Messenger;
    pinmodes  : PinModeArray := AllGPIO) RETURN Device IS

    dev : CONSTANT DeviceClass := DeviceClass'(msg => msg);

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
        Messaging.Byte'Image(resp(1));
    END IF;
  END Command;

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
        cmd(8 + Natural(p)) := Messaging.Byte(Modes(p));
      END IF;
    END LOOP;

    Self.Command(cmd, resp);
  END SetPinModes;

  -- Get MCP2221 revision information string

  FUNCTION Revision(Self : DeviceClass) RETURN String IS

    cmd  : CONSTANT Message64.Message := (0 => CMD_SET_PARM, OTHERS => 0);
    resp : Message64.Message;

  BEGIN
    Self.Command(cmd, resp);

    RETURN Character'Val(resp(46)) & " " & Character'Val(resp(47)) & " " &
     Character'Val(resp(48)) & " " & Character'Val(resp(49));
  END Revision;

  -- Get MCP2221 USB manufacturer string

  FUNCTION Manufacturer(Self : DeviceClass) RETURN String IS

    cmd    : CONSTANT Message64.Message := (0 => CMD_READ_FLASH, 1 => 2, OTHERS => 0);
    resp   : Message64.Message;
    len    : Natural;
    code   : Natural;
    result : Wide_Wide_String(1 .. 30) := (OTHERS => ' ');

  BEGIN
    Self.Command(cmd, resp);

    -- Extract the Unicode USB manufacturer string from the response

    len := Natural(resp(2) - 2)/2;

    FOR i IN 1 .. len LOOP
      code := Natural(resp(i*2 + 2)) + Natural(resp(i*2 + 3));
      result(i) := Wide_Wide_Character'Val(code);
    END LOOP;

    -- Convert the Unicode string to plain ASCII

    RETURN Ada.Strings.Fixed.Trim(Ada.Characters.Conversions.To_String(result),
      Ada.Strings.Both);
  END Manufacturer;

  -- Get MCP2221 USB product string

  FUNCTION Product(Self : DeviceClass) RETURN String IS

    cmd    : CONSTANT Message64.Message := (0 => CMD_READ_FLASH, 1 => 3, OTHERS => 0);
    resp   : Message64.Message;
    len    : Natural;
    code   : Natural;
    result : Wide_Wide_String(1 .. 30) := (OTHERS => ' ');

  BEGIN
    Self.Command(cmd, resp);

    -- Extract the Unicode USB product string from the response

    len := Natural(resp(2) - 2)/2;

    FOR i IN 1 .. len LOOP
      code := Natural(resp(i*2 + 2)) + Natural(resp(i*2 + 3));
      result(i) := Wide_Wide_Character'Val(code);
    END LOOP;

    -- Convert the Unicode string to plain ASCII

    RETURN Ada.Strings.Fixed.Trim(Ada.Characters.Conversions.To_String(result),
      Ada.Strings.Both);
  END Product;

  -- Get MCP2221 USB serial number string

  FUNCTION SerialNumber(Self : DeviceClass) RETURN String IS

    cmd    : CONSTANT Message64.Message := (0 => CMD_READ_FLASH, 1 => 4, OTHERS => 0);
    resp   : Message64.Message;
    len    : Natural;
    code   : Natural;
    result : Wide_Wide_String(1 .. 30) := (OTHERS => ' ');

  BEGIN
    Self.Command(cmd, resp);

    -- Extract the Unicode USB serial number string from the response

    len := Natural(resp(2) - 2)/2;

    FOR i IN 1 .. len LOOP
      code := Natural(resp(i*2 + 2)) + Natural(resp(i*2 + 3));
      result(i) := Wide_Wide_Character'Val(code);
    END LOOP;

    -- Convert the Unicode string to plain ASCII

    RETURN Ada.Strings.Fixed.Trim(Ada.Characters.Conversions.To_String(result),
      Ada.Strings.Both);
  END SerialNumber;

END MCP2221;
