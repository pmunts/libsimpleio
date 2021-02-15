-- PCA9685 PWM controller device services

-- Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY PCA9685 IS

  -- PCA9685 device object constructor

  FUNCTION Create
   (bus   : NOT NULL I2C.Bus;
    addr  : I2C.Address;
    freq  : Positive := 50;
    clock : ClockFrequency := 0) RETURN Device IS

    dev   : Device;

  BEGIN
    dev := NEW DeviceClass'(bus, addr, freq);

    IF clock = 0 THEN
      -- Use internal 25 MHz clock
      dev.WriteRegister(MODE1, 2#00110000#); -- Set SLEEP
      dev.WriteRegister(PRE_SCALE, RegisterData(25_000_000/4096/freq - 1));
      dev.WriteRegister(MODE1, 2#00100000#); -- Clear SLEEP
    ELSE
      -- Use external clock
      dev.WriteRegister(MODE1, 2#01110000#); -- Set SLEEP
      dev.WriteRegister(PRE_SCALE, RegisterData(Positive(clock)/4096/freq - 1));
      dev.WriteRegister(MODE1, 2#01100000#); -- Clear SLEEP
    END IF;

    dev.WriteRegister(MODE2, 2#00001100#);

    return dev;
  END Create;

  -- Write PCA9685 register

  PROCEDURE WriteRegister
   (Self : DeviceClass;
    reg  : RegisterName;
    data : RegisterData) IS

    cmd  : I2C.Command(0 .. 1);

  BEGIN
    cmd(0) := I2C.Byte(RegisterName'Enum_Rep(reg));
    cmd(1) := I2C.Byte(data);

    Self.bus.Write(Self.address, cmd, 2);
  END WriteRegister;

  -- Write PCA9685 channel data

  PROCEDURE WriteChannel
   (Self    : DeviceClass;
    channel : ChannelNumber;
    data    : ChannelData) IS

    cmd : I2C.Command(0 .. 4);

  BEGIN
    cmd(0) := I2C.Byte(RegisterName'Enum_rep(LED0_ON_L) + channel*4);
    cmd(1) := I2C.Byte(data(0));
    cmd(2) := I2C.Byte(data(1));
    cmd(3) := I2C.Byte(data(2));
    cmd(4) := I2C.Byte(data(3));

    Self.bus.Write(Self.address, cmd, cmd'Length);
  END WriteChannel;

  -- Read PCA9685 channel data

  PROCEDURE ReadChannel
   (Self    : DeviceClass;
    channel : ChannelNumber;
    data    : OUT ChannelData) IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 3);

  BEGIN
    cmd(0) := I2C.Byte(RegisterName'Enum_rep(LED0_ON_L) + channel*4);
    Self.bus.Transaction(Self.address, cmd, cmd'Length, resp, resp'Length);

    data(0) := RegisterData(resp(0));
    data(1) := RegisterData(resp(1));
    data(2) := RegisterData(resp(2));
    data(3) := RegisterData(resp(3));
  END ReadChannel;

END PCA9685;
