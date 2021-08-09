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

PACKAGE BODY Grove_TB6612 IS

  -- Device object constructor

  FUNCTION Create
   (bus  : I2C.Bus;
    addr : I2C.Address := DefaultAddress) RETURN Device IS

    dev : DeviceClass;

  BEGIN
    Initialize(dev, bus, addr);
    RETURN NEW DeviceClass'(dev);
  END Create;

  -- Device object instance initializer

  PROCEDURE Initialize
   (Self : IN OUT DeviceClass;
    bus  : I2C.Bus;
    addr : I2C.Address := DefaultAddress) IS

  BEGIN
    Self.bus  := bus;
    Self.addr := addr;
    Self.Disable;
  END Initialize;

  -- Disable the motor driver and enter standby mode

  PROCEDURE Disable(Self : IN OUT DeviceClass) IS

    cmd : I2C.Command(0 .. 0);

  BEGIN
    cmd(0) := CMD_DISABLE;
    Self.bus.Write(Self.addr, cmd, cmd'Length);
  END Disable;

  -- Leave standby mode and enable the motor driver

  PROCEDURE Enable(Self : IN OUT DeviceClass) IS

    cmd : I2C.Command(0 .. 0);

  BEGIN
    cmd(0) := CMD_ENABLE;
    Self.bus.Write(Self.addr, cmd, cmd'Length);
  END Enable;

  -- Change the I2C address

  PROCEDURE ChangeAddress
   (Self : IN OUT DeviceClass;
    addr : I2C.Address) IS

    cmd : I2C.Command(0 .. 1);

  BEGIN
    cmd(0) := CMD_SET_ADDR;
    cmd(1) := I2C.Byte(addr);
    Self.bus.Write(Self.addr, cmd, cmd'Length);
  END ChangeAddress;

  -- Execute a command

  PROCEDURE Command
   (Self : IN OUT DeviceClass;
    cmd  : I2C.Command) IS

  BEGIN
    Self.bus.Write(Self.addr, cmd, cmd'Length);
  END Command;

END Grove_TB6612;
