-- Grove I2C Motor Driver TB6612 Device Services

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

WITH I2C;

PACKAGE Grove_TB6612 IS

  DefaultAddress : CONSTANT I2C.Address := 16#14#;

  TYPE DeviceClass IS TAGGED PRIVATE;

  TYPE Device IS ACCESS ALL DeviceClass'Class;

  -- Device object constructor

  FUNCTION Create
   (bus  : I2C.Bus;
    addr : I2C.Address := DefaultAddress) RETURN Device;

  -- Device object instance initializer

  PROCEDURE Initialize
   (Self : IN OUT DeviceClass;
    bus  : I2C.Bus;
    addr : I2C.Address := DefaultAddress);

  -- Disable the motor driver and enter standby mode

  PROCEDURE Disable(Self : IN OUT DeviceClass);

  -- Leave standby mode and enable the motor driver

  PROCEDURE Enable(Self : IN OUT DeviceClass);

  -- Change the I2C address

  PROCEDURE ChangeAddress
   (Self : IN OUT DeviceClass;
    addr : I2C.Address);

PRIVATE

  -- Execute a command

  PROCEDURE Command
   (Self : IN OUT DeviceClass;
    cmd  : I2C.Command);

  TYPE DeviceClass IS TAGGED RECORD
    bus  : I2C.Bus;
    addr : I2C.Address;
  END RECORD;

  CMD_MOTOR_BRAKE      : CONSTANT I2C.Byte := 16#00#;
  CMD_MOTOR_STOP       : CONSTANT I2C.Byte := 16#01#;
  CMD_MOTOR_CW         : CONSTANT I2C.Byte := 16#02#;
  CMD_MOTOR_CCW        : CONSTANT I2C.Byte := 16#03#;
  CMD_ENABLE           : CONSTANT I2C.Byte := 16#04#;
  CMD_DISABLE          : CONSTANT I2C.Byte := 16#05#;
  CMD_STEPPER_MOVE     : CONSTANT I2C.Byte := 16#06#;
  CMD_STEPPER_STOP     : CONSTANT I2C.Byte := 16#07#;
  CMD_STEPPER_SPIN     : CONSTANT I2C.Byte := 16#08#;
  CMD_SET_ADDR         : CONSTANT I2C.Byte := 16#11#;

  MOTORA               : CONSTANT I2C.Byte := 0;
  MOTORB               : CONSTANT I2C.Byte := 1;

  FULL_STEP            : CONSTANT I2C.Byte := 0;
  WAVE_DRIVE           : CONSTANT I2C.Byte := 1;
  HALF_STEP            : CONSTANT I2C.Byte := 2;
  MICRO_STEPPING       : CONSTANT I2C.Byte := 3;

END Grove_TB6612;
