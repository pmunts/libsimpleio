-- TCS3472 Color Sensor services

-- Copyright (C)2017-2023, Philip Munts, President, Munts AM Corp.
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

USE TYPE I2C.Byte;

PACKAGE BODY TCS3472 IS
  PRAGMA Warnings(Off, "constant ""*"" is not referenced");

  -- TCS3472 register addresses

  ENABLE  : CONSTANT I2C.Byte := 16#00#;
  ATIME   : CONSTANT I2C.Byte := 16#01#;
  WTIME   : CONSTANT I2C.Byte := 16#03#;
  AILTL   : CONSTANT I2C.Byte := 16#04#;
  AILTH   : CONSTANT I2C.Byte := 16#05#;
  AIHTL   : CONSTANT I2C.Byte := 16#06#;
  AIHTH   : CONSTANT I2C.Byte := 16#07#;
  PERS    : CONSTANT I2C.Byte := 16#0C#;
  CONFIG  : CONSTANT I2C.Byte := 16#0D#;
  CONTROL : CONSTANT I2C.Byte := 16#0F#;
  ID      : CONSTANT I2C.Byte := 16#12#;
  STATUS  : CONSTANT I2C.Byte := 16#13#;
  CDATAL  : CONSTANT I2C.Byte := 16#14#;
  CDATAH  : CONSTANT I2C.Byte := 16#15#;
  RDATAL  : CONSTANT I2C.Byte := 16#16#;
  RDATAH  : CONSTANT I2C.Byte := 16#17#;
  GDATAL  : CONSTANT I2C.Byte := 16#18#;
  GDATAH  : CONSTANT I2C.Byte := 16#19#;
  BDATAL  : CONSTANT I2C.Byte := 16#1A#;
  BDATAH  : CONSTANT I2C.Byte := 16#1B#;

  -- Commands

  REPEAT  : CONSTANT I2C.Byte := 2#1000_0000#;
  AUTOINC : CONSTANT I2C.Byte := 2#1010_0000#;

  -- Enable Register fields

  PON     : CONSTANT I2C.Byte := 2#0000_0001#;
  AEN     : CONSTANT I2C.Byte := 2#0000_0010#;
  WEN     : CONSTANT I2C.Byte := 2#0000_1000#;
  AIEN    : CONSTANT I2C.Byte := 2#0001_0000#;

  -- Composite enable commands

  POWERON : CONSTANT I2C.Byte := PON;
  ACQUIRE : CONSTANT I2C.Byte := PON OR AEN;

  -- Write to TCS3472 register

  PROCEDURE WriteRegister
   (bus     : I2C.Bus;
    addr    : I2C.Address;
    regaddr : I2C.Byte;
    regdata : I2C.Byte) IS

    cmd : I2C.Command(0 .. 1);

  BEGIN
    cmd(0) := REPEAT + regaddr;
    cmd(1) := regdata;

    bus.Write(addr, cmd, cmd'Length);
  END WriteRegister;

  -- Read from TCS3472 register

  PROCEDURE ReadRegister
   (bus     : I2C.Bus;
    addr    : I2C.Address;
    regaddr : I2C.Byte;
    regdata : OUT I2C.byte) IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 0);

  BEGIN
    cmd(0) := REPEAT + regaddr;

    bus.Transaction(addr, cmd, cmd'Length, resp, resp'Length);
    regdata := resp(0);
  END ReadRegister;

  -- Constructor

  FUNCTION Create(bus : NOT NULL I2C.Bus; address : I2C.Address) RETURN Device IS

  BEGIN
    WriteRegister(bus, address, ENABLE, 0);

    RETURN NEW DeviceSubclass'(bus, address);
  END Create;

  -- Methods

  FUNCTION Get
   (Self : IN OUT DeviceSubclass) RETURN Sample IS

  BEGIN
    RETURN Self.Get(1, 1, X1, False);
  END Get;

  FUNCTION Get
   (Self   : IN OUT DeviceSubclass;
    aticks : Time;
    wticks : Time := 1;
    gain   : Gains := X1;
    wlong  : Boolean := False) RETURN Sample IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 7);
    stat : I2C.Byte;
    samp : Sample;

  BEGIN

    -- Power on the TCS3472

    WriteRegister(Self.bus, Self.address, ENABLE, PON);
    DELAY 0.01;

    WriteRegister(Self.bus, Self.address, CONFIG,
     (IF wlong THEN 16#00# ELSE 16#02#));

    WriteRegister(Self.bus, Self.address, ATIME, I2C.Byte(256 - aticks));
    WriteRegister(Self.bus, Self.address, WTIME, I2C.Byte(256 - wticks));
    WriteRegister(Self.bus, Self.address, ENABLE, PON OR WEN OR AEN);

    -- Wait for acquisition to complete

    LOOP
      ReadRegister(Self.bus, Self.address, STATUS, stat);
      EXIT WHEN (stat AND 16#01#) = 16#01#;
    END LOOP;

    -- Fetch acquisition results

    cmd(0) := AUTOINC + CDATAL;
    Self.bus.Transaction(Self.address, cmd, cmd'Length, resp, resp'Length);

    -- Power off the TCS3472

    WriteRegister(Self.bus, Self.address, ENABLE, 0);

    -- Extract acquisition results

    samp(Clear) := Brightness(resp(0)) + Brightness(resp(1))*256;
    samp(Red)   := Brightness(resp(2)) + Brightness(resp(3))*256;
    samp(Green) := Brightness(resp(4)) + Brightness(resp(5))*256;
    samp(Blue ) := Brightness(resp(6)) + Brightness(resp(7))*256;

    RETURN samp;
  END Get;

END TCS3472;
