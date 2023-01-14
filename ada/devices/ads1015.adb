-- ADS1015 Analog to Digital Converter services

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

PACKAGE BODY ADS1015 IS
  PRAGMA Warnings(Off, "literal ""*"" is not referenced");

  TYPE RegAddr IS (Conversion, Config, LowThreshold, HighThreshold);

  MuxMap : CONSTANT ARRAY (Channel) OF RegData :=
   (2#0100_0000_0000_0000#,  -- AIN0
    2#0101_0000_0000_0000#,  -- AIN1
    2#0110_0000_0000_0000#,  -- AIN2
    2#0111_0000_0000_0000#,  -- AIN3
    2#0000_0000_0000_0000#,  -- DIFF01
    2#0001_0000_0000_0000#,  -- DIFF03
    2#0010_0000_0000_0000#,  -- DIFF13
    2#0011_0000_0000_0000#); -- DIFF23

  PGAMap : CONSTANT ARRAY (FullScaleRange) OF RegData :=
   (2#0000_0000_0000_0000#,  -- FSR6144
    2#0000_0010_0000_0000#,  -- FSR4096
    2#0000_0100_0000_0000#,  -- FSR2048
    2#0000_0110_0000_0000#,  -- FSR1024
    2#0000_1000_0000_0000#,  -- FSR512
    2#0000_1010_0000_0000#); -- FSR256

  GainMap : CONSTANT ARRAY (FullScaleRange) OF Voltage.Volts :=
   (1.5,     -- FSR6144
    1.0,     -- FSR4096
    0.5,     -- FSR2048
    0.25,    -- FSR1024
    0.125,   -- FSR512
    0.0625); -- FSR256

  -- Config register fields

  Start : CONSTANT RegData := 2#1000_0000_0000_0000#;
  Idle  : CONSTANT RegData := 2#1000_0000_0000_0000#;
  Mode  : CONSTANT RegData := 2#0000_0001_0000_0000#;

  -- Write to an ADS1015 register

  PROCEDURE WriteRegister(bus : I2C.Bus; addr : I2C.Address; reg : RegAddr;
    data : RegData) IS

    cmd : I2C.Command(0 .. 2);

  BEGIN
    cmd(0) := I2C.Byte(RegAddr'Pos(reg));
    cmd(1) := I2C.Byte(data / 256);
    cmd(2) := I2C.Byte(data MOD 256);

    bus.Write(addr, cmd, cmd'Length);
  END WriteRegister;

  -- Read from an ADS1015 register

  PROCEDURE ReadRegister(bus : I2C.Bus; addr : I2C.Address; reg : RegAddr;
    data : OUT RegData) IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 1);

  BEGIN
    cmd(0) := I2C.Byte(RegAddr'Pos(reg));

    bus.Transaction(addr, cmd, cmd'Length, resp, resp'Length);

    data := RegData(resp(0))*256 + RegData(resp(1));
  END ReadRegister;

  -- Analog input constructor

  FUNCTION Create(bus : NOT NULL I2C.Bus; addr : I2C.Address; chan : Channel;
    fsr : FullScaleRange) RETURN Analog.Input IS

  BEGIN
    RETURN NEW InputSubclass'(bus, addr, MuxMap(chan), PGAMap(fsr),
      GainMap(fsr));
  END Create;

  -- Analog input method

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Analog.Sample IS

    data : RegData;

  BEGIN
    data := Start + Self.mux + Self.pga + Mode;

    WriteRegister(Self.bus, Self.addr, Config, data);

    LOOP
      ReadRegister(Self.bus, Self.addr, Config, data);
      EXIT WHEN (data AND Idle) = Idle;
    END LOOP;

    ReadRegister(Self.bus, Self.addr, Conversion, data);

    RETURN Analog.Sample(data/16);
  END Get;

  -- Retrieve resolution

  PRAGMA Warnings(Off, "formal parameter ""Self"" is not referenced");

  FUNCTION GetResolution(Self : IN OUT InputSubclass) RETURN Positive IS

  BEGIN
    RETURN Resolution - 1;
  END GetResolution;

  PRAGMA Warnings(On, "formal parameter ""Self"" is not referenced");

  -- Retrieve PGA gain

  FUNCTION GetGain(Self : IN OUT InputSubclass) RETURN Voltage.Volts IS

  BEGIN
    RETURN Self.gain;
  END GetGain;

END ADS1015;
