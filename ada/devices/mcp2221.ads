-- MCP2221 Device Services

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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
WITH Messaging;
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

  GP0 : CONSTANT PinNumber := 0;
  GP1 : CONSTANT PinNumber := 1;
  GP2 : CONSTANT PinNumber := 2;
  GP3 : CONSTANT PinNumber := 3;

  MODE_GPIO : CONSTANT PinMode := 2#00000000#;  -- GP0, GP1, GP2, GP3
  MODE_ADC  : CONSTANT PinMode := 2#00000010#;  -- GP1, GP2, GP3 only
  MODE_DAC  : CONSTANT PinMode := 2#00000011#;  -- GP2, GP3 only

  AllGPIO : CONSTANT PinModeArray := (OTHERS => MODE_GPIO);

  -- Create an MCP2221 device object instance

  FUNCTION Create
   (msg      : NOT NULL Message64.Messenger;
    pinmodes : PinModeArray := AllGPIO) RETURN Device;

  -- Configure MCP2221 GPIO pin mux

  PROCEDURE SetPinModes
   (Self  : DeviceClass;
    Modes : PinModeArray := AllGPIO);

  -- Get MCP2221 revision information string

  FUNCTION Revision(Self : DeviceClass) RETURN String;

  -- Get MCP2221 USB manufacturer string

  FUNCTION Manufacturer(Self : DeviceClass) RETURN String;

  -- Get MCP2221 USB product string

  FUNCTION Product(Self : DeviceClass) RETURN String;

  -- Get MCP2221 USB serial number string

  FUNCTION SerialNumber(Self : DeviceClass) RETURN String;

PRIVATE

  TYPE DeviceClass IS TAGGED RECORD
    msg : Message64.Messenger;
  END RECORD;

  -- MCP2221 commands

  CMD_SET_PARM             : CONSTANT Messaging.Byte := 16#10#;
  CMD_READ_FLASH           : CONSTANT Messaging.Byte := 16#B0#;
  CMD_WRITE_FLASH          : CONSTANT Messaging.Byte := 16#B1#;
  CMD_I2C_READ             : CONSTANT Messaging.Byte := 16#91#;
  CMD_I2C_READ_REPEAT      : CONSTANT Messaging.Byte := 16#93#;
  CMD_I2C_GET_DATA         : CONSTANT Messaging.Byte := 16#40#;
  CMD_I2C_WRITE            : CONSTANT Messaging.Byte := 16#90#;
  CMD_I2C_WRITE_REPEAT     : CONSTANT Messaging.Byte := 16#92#;
  CMD_I2C_WRITE_NOSTOP     : CONSTANT Messaging.Byte := 16#94#;
  CMD_SET_GPIO             : CONSTANT Messaging.Byte := 16#50#;
  CMD_GET_GPIO             : CONSTANT Messaging.Byte := 16#51#;
  CMD_SET_SRAM             : CONSTANT Messaging.Byte := 16#60#;
  CMD_GET_SRAM             : CONSTANT Messaging.Byte := 16#61#;
  CMD_RESET                : CONSTANT Messaging.Byte := 16#70#;

  -- Issue a command to the MCP2221

  PROCEDURE Command
   (Self : DeviceClass;
    cmd  : Message64.Message;
    resp : OUT Message64.Message);

END MCP2221;
