-- ADC121C021 Analog to Digital Converter services

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

PACKAGE BODY ADC121C021 IS
  PRAGMA Warnings(Off, "constant ""*"" is not referenced");
  PRAGMA Warnings(Off, "function ""*"" is not referenced");
  PRAGMA Warnings(Off, "procedure ""*"" is not referenced");

  -- ADC121C021 register types

  TYPE RegAddr8  IS MOD 2**8;
  TYPE RegAddr16 IS MOD 2**8;
  TYPE RegData8  IS MOD 2**8;
  TYPE RegData16 IS MOD 2**16;

  -- ADC121C021 register addresses

  ConversionResult  : CONSTANT RegAddr16 := 16#00#;
  AlertStatus       : CONSTANT RegAddr8  := 16#01#;
  Configuration     : CONSTANT RegAddr8  := 16#02#;
  AlertLowLimit     : CONSTANT RegAddr16 := 16#03#;
  AlertHighLimit    : CONSTANT RegAddr16 := 16#04#;
  AlertHysteresis   : CONSTANT RegAddr16 := 16#05#;
  LowestConversion  : CONSTANT RegAddr16 := 16#06#;
  HighestConversion : CONSTANT RegAddr16 := 16#07#;

  -- ADC121C021 register constants

  SAMPLE_MASK  : CONSTANT RegData16 := RegData16(2**Resolution - 1);

  -- Read a single byte register

  FUNCTION ReadRegister8
   (Self : InputSubclass;
    addr : RegAddr8) RETURN RegData8 IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 0);

  BEGIN
    cmd(0) := I2C.Byte(addr);
    Self.Bus.Transaction(Self.Address, cmd, cmd'Length, resp, resp'Length);
    RETURN RegData8(resp(0));
  END ReadRegister8;

  -- Read a double byte register

  FUNCTION ReadRegister16
   (Self : InputSubclass;
    addr : RegAddr16) RETURN RegData16 IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 1);

  BEGIN
    cmd(0) := I2C.Byte(addr);
    Self.Bus.Transaction(Self.Address, cmd, cmd'Length, resp, resp'Length);
    RETURN RegData16(resp(0))*256 + RegData16(resp(1));
  END ReadRegister16;

  -- Write a single byte register

  PROCEDURE WriteRegister8
   (Self : InputSubclass;
    addr : RegAddr8;
    data : RegData8) IS

   cmd : I2C.Command(0 .. 1);

  BEGIN
    cmd(0) := I2C.Byte(addr);
    cmd(1) := I2C.Byte(data);

    Self.Bus.Write(Self.Address, cmd, cmd'Length);
  END WriteRegister8;

  -- Write a double byte register

  PROCEDURE WriteRegister16
   (Self : InputSubclass;
    addr : RegAddr16;
    data : RegData16) IS

    cmd : I2C.Command(0 .. 2);

  BEGIN
    cmd(0) := I2C.Byte(addr);
    cmd(1) := I2C.Byte(data / 256);
    cmd(2) := I2C.Byte(data MOD 256);

    Self.Bus.Write(Self.Address, cmd, cmd'Length);
  END WriteRegister16;

  -- Constructors

  FUNCTION Create
   (bus  : NOT NULL I2C.Bus;
    addr : I2C.Address) RETURN Analog.Input IS

  BEGIN
    WriteRegister8(InputSubclass'(bus, addr), Configuration, 16#00#);
    RETURN NEW InputSubclass'(bus, addr);
  END Create;

  -- Methods

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Analog.Sample IS

  BEGIN
    RETURN Analog.Sample(ReadRegister16(Self, ConversionResult) AND SAMPLE_MASK);
  END Get;

  PRAGMA Warnings(Off, "formal parameter ""Self"" is not referenced");

  FUNCTION GetResolution(Self : IN OUT InputSubclass) RETURN Positive IS

  BEGIN
    RETURN resolution;
  END GetResolution;

  PRAGMA Warnings(On, "formal parameter ""Self"" is not referenced");

END ADC121C021;
