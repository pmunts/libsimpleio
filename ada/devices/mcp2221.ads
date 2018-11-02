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

WITH HID;
WITH Message64;

PACKAGE MCP2221 IS

  MCP2221_Error : EXCEPTION;

  TYPE DeviceClass IS TAGGED PRIVATE;

  TYPE Device IS ACCESS DeviceClass;

  VendorID  : CONSTANT HID.Vendor  := 16#04D8#;
  ProductID : CONSTANT HID.Product := 16#00DD#;

  TYPE PinNumber    IS RANGE 0 .. 3;
  TYPE PinMode      IS RANGE 0 .. 7;
  TYPE PinModeArray IS ARRAY (PinNumber) OF PinMode;

  AllGPIO : CONSTANT PinModeArray := (0, 0, 0, 0);

  FUNCTION Create
   (msg       : Message64.Messenger;
    pinmodes  : PinModeArray := AllGPIO) RETURN Device;

  FUNCTION Create
   (vid       : HID.Vendor   := VendorID;
    pid       : HID.Product  := ProductID;
    timeoutms : Integer      := 1000;
    pinmodes  : PinModeArray := AllGPIO) RETURN Device;

  -- Get MCP2221 revision information

  PROCEDURE GetRevisions
   (Self          : DeviceClass;
    HardwareMajor : OUT Character;
    HardwareMinor : OUT Character;
    FirmwareMajor : OUT Character;
    FirmwareMinor : OUT Character);

  -- Configure MCP2221 GPIO pin mux

  PROCEDURE SetPinMode
   (Self  : DeviceClass;
    Modes : PinModeArray := AllGPIO);

PRIVATE

  TYPE DeviceClass IS TAGGED RECORD
    msg : Message64.Messenger;
  END RECORD;

  -- MCP2221 commands

  CMD_SET_PARM             : CONSTANT Message64.Byte := 16#10#;
  CMD_READ_FLASH           : CONSTANT Message64.Byte := 16#B0#;
  CMD_WRITE_FLASH          : CONSTANT Message64.Byte := 16#B1#;
  CMD_I2C_WRITE            : CONSTANT Message64.Byte := 16#90#;
  CMD_I2C_READ             : CONSTANT Message64.Byte := 16#91#;
  CMD_I2C_WRITE_REPEAT     : CONSTANT Message64.Byte := 16#92#;
  CMD_I2C_READ_REPEAT      : CONSTANT Message64.Byte := 16#93#;
  CMD_I2C_WRITE_NOSTOP     : CONSTANT Message64.Byte := 16#94#;
  CMD_SET_GPIO             : CONSTANT Message64.Byte := 16#50#;
  CMD_GET_GPIO             : CONSTANT Message64.Byte := 16#51#;
  CMD_SET_SRAM             : CONSTANT Message64.Byte := 16#60#;
  CMD_GET_SRAM             : CONSTANT Message64.Byte := 16#61#;
  CMD_RESET                : CONSTANT Message64.Byte := 16#70#;

  -- Issue a command to the MCP2221

  PROCEDURE Command
   (Self : DeviceClass;
    cmd  : Message64.Message;
    resp : OUT Message64.Message);

END MCP2221;
