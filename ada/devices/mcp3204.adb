-- MCP3204 Analog to Digital Converter services

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

WITH Interfaces;

USE TYPE Interfaces.Unsigned_32;

PACKAGE BODY MCP3204 IS

  -- Constructors

  FUNCTION Create
   (spidev  : NOT NULL SPI.Device;
    chan    : Channel;
    config  : Configuration := SingleEnded) RETURN Analog.Input IS

  BEGIN
    CASE config IS
      WHEN SingleEnded =>
        RETURN NEW InputSubclass'(spidev, SPI.Byte(16#60# + Natural(chan)*4));

      WHEN Differential =>
        RETURN NEW InputSubclass'(spidev, SPI.Byte(16#40# + Natural(chan)*4));
    END CASE;
  END Create;

  -- Methods

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Analog.Sample IS

    cmd  : SPI.Command(0 .. 0);
    resp : SPI.Response(0 .. 1);

  BEGIN
    cmd(0) := Self.cmd;
    Self.spidev.Transaction(cmd, cmd'Length, resp, resp'Length);

    RETURN Analog.Sample(Standard.Interfaces.Shift_Left(
      Standard.Interfaces.Unsigned_32(resp(0)), 4) +
      Standard.Interfaces.Shift_Right(Standard.Interfaces.Unsigned_32(resp(1)), 4));
  END Get;

  PRAGMA Warnings(Off, "formal parameter ""Self"" is not referenced");

  FUNCTION GetResolution(Self : IN OUT InputSubclass) RETURN Positive IS

  BEGIN
    RETURN Resolution;
  END GetResolution;

  PRAGMA Warnings(On, "formal parameter ""Self"" is not referenced");

END MCP3204;
