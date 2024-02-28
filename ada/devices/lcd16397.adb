-- Sparkfun LCD-16397 16x2 Display Module Services

-- Copyright (C)2024, Philip Munts dba Munts Technologies.
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

-- See also: https://www.sparkfun.com/products/16397

WITH I2C;

USE TYPE I2C.Byte;

PACKAGE BODY LCD16397 IS

  -- Device object constructor

  FUNCTION Create
   (bus             : I2C.Bus;
    addr            : I2C.Address := DefaultAddress;
    delayafterwrite : Duration    := DefaultDelay) RETURN Device IS

    self : DeviceClass;

  BEGIN
    self.Initialize(bus, addr, delayafterwrite);
    RETURN NEW DeviceClass'(self);
  END Create;

  -- Device object instance initializer

  PROCEDURE Initialize
   (Self            : OUT DeviceClass;
    bus             : I2C.Bus;
    addr            : I2C.Address := DefaultAddress;
    delayafterwrite : Duration    := DefaultDelay) IS

  BEGIN
    Self.bus             := bus;
    Self.addr            := addr;
    Self.delayafterwrite := delayafterwrite;
    Self.Reset;
  END Initialize;

  -- Write string to display

  PROCEDURE Put(Self : DeviceClass; s : String) IS

    cmd  : I2C.Command(1 .. s'Length);

  BEGIN
    FOR i in s'Range LOOP
      cmd(i) := Character'Pos(s(i));
    END LOOP;

    Self.bus.Write(Self.addr, cmd, cmd'Length);
    DELAY Self.delayafterwrite;
  END Put;

  -- Write character to display

  PROCEDURE Put(Self : DeviceClass; c : Character) IS

    cmd  : I2C.Command(0 .. 0);

  BEGIN
    cmd(0) := Character'Pos(c);

    Self.bus.Write(Self.addr, cmd, cmd'Length);
    DELAY Self.delayafterwrite;
  END Put;

  -- Request software reset

  PROCEDURE Reset(Self : DeviceClass) IS

  BEGIN
    Self.Put("|" & ASCII.BS);
    DELAY 2.0;
  END Reset;

  -- Clear display

  PROCEDURE Clear(Self : DeviceClass) IS

  BEGIN
    Self.Put("|-");
  END Clear;

  -- Move cursor

  RowCommand : CONSTANT ARRAY (RowNumber) OF I2C.Byte := (0, 64);

  PROCEDURE Move
   (Self : DeviceClass;
    row  : RowNumber;
    col  : ColumnNumber) IS

    cmd  : I2C.Command(0 .. 1);

  BEGIN
    cmd(0) := 254;
    cmd(1) := 128 + RowCommand(row) + I2C.Byte(col);

    Self.bus.Write(Self.addr, cmd, cmd'Length);
    DELAY Self.delayafterwrite;
  END Move;

END LCD16397;
