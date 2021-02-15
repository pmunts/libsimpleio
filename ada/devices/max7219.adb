-- MAX7219 LED driver services

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

PACKAGE BODY MAX7219 IS

  -- MAX7219 device object constructor

  FUNCTION Create(dev : NOT NULL SPI.Device) RETURN DeviceClass IS

  BEGIN
    RETURN DeviceClass'(dev => dev);
  END Create;

  -- Reset the MAX7219 device

  PROCEDURE Initialize(Self : DeviceClass) IS

  BEGIN
    Self.Put(SHUTDOWN,   16#01#);
    Self.Put(DECODEMODE, 16#00#);
    Self.Put(INTENSITY,  16#0F#);
    Self.Put(SCANLIMIT,  16#07#);
    Self.Put(DIGIT0,     16#00#);
    Self.Put(DIGIT1,     16#00#);
    Self.Put(DIGIT2,     16#00#);
    Self.Put(DIGIT3,     16#00#);
    Self.Put(DIGIT4,     16#00#);
    Self.Put(DIGIT5,     16#00#);
    Self.Put(DIGIT6,     16#00#);
    Self.Put(DIGIT7,     16#00#);
  END Initialize;

  -- Write a MAX7219 register

  PROCEDURE Put
   (Self : DeviceClass;
    reg  : Register;
    dat  : Data) IS

    cmd : SPI.Command(0 .. 1);

  BEGIN
    cmd(0) := SPI.Byte(reg);
    cmd(1) := SPI.Byte(dat);

    Self.dev.Write(cmd, cmd'Length);
  END Put;

END MAX7219;
