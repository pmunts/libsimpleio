-- MCP4822 Digital to Analog Converter services

-- Copyright (C)2018-2023, Philip Munts, President, Munts AM Corp.
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

WITH Analog;
WITH SPI;

USE TYPE Analog.Sample;
USE TYPE SPI.Byte;

PACKAGE BODY MCP4822 IS

  -- Write command register bitmask constants

  ChannelBits : CONSTANT ARRAY (Channel) OF SPI.Byte :=
   (2#00000000#,   -- DAC A
    2#10000000#);  -- DAC B

  GainBits    : CONSTANT ARRAY (OutputGains) OF SPI.Byte :=
   (2#00100000#,   -- 1x output gain
    2#00000000#);  -- 2x output gain

  EnableBits  : CONSTANT ARRAY (Boolean) OF SPI.Byte :=
   (2#00000000#,   -- Output disabled
    2#00010000#);  -- Output enabled

  Steps : CONSTANT Analog.Sample := 2**Resolution;

  -- Constructors

  FUNCTION Create
   (spidev : NOT NULL SPI.Device;
    chan   : Channel;
    gain   : OutputGains := 1) RETURN Analog.Output IS

  BEGIN
    RETURN NEW OutputSubclass'(spidev, ChannelBits(chan) + GainBits(gain) +
      EnableBits(True));
  END Create;

  -- Methods

  PRAGMA Warnings(Off, "formal parameter ""Self"" is not referenced");

  FUNCTION GetResolution(Self : IN OUT OutputSubclass) RETURN Positive IS

  BEGIN
    RETURN Resolution;
  END GetResolution;

  PRAGMA Warnings(On, "formal parameter ""Self"" is not referenced");

  PROCEDURE Put(Self : IN OUT OutputSubclass; value : Analog.Sample) IS

    cmd : SPI.Command(0 .. 1);

  BEGIN
    IF value >= Steps THEN
      RAISE Constraint_Error WITH "Sample value is out of range";
    END IF;

    cmd(0) := Self.cmd OR SPI.Byte(value / 256);
    cmd(1) := SPI.Byte(value MOD 256);

    Self.spidev.Write(cmd, cmd'Length);
  END Put;

END MCP4822;
