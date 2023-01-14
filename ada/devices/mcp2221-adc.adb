-- MCP2221 A/D Converter Input Services

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
WITH Message64;

USE TYPE Analog.Sample;

PACKAGE BODY MCP2221.ADC IS

  -- Constructor

  FUNCTION Create(dev : NOT NULL Device; num : Channel) RETURN Analog.Input IS

  BEGIN
    RETURN NEW InputSubclass'(dev.ALL, num);
  END Create;

  -- Methods

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Analog.Sample IS

    cmd    : CONSTANT Message64.Message := (0 => CMD_SET_PARM, OTHERS => 0);
    resp   : Message64.Message;
    offset : CONSTANT Natural := 48 + 2*Natural(Self.num);

  BEGIN
    Self.dev.Command(cmd, resp);

    RETURN Analog.Sample(resp(offset)) + Analog.Sample(resp(offset + 1))*256;
  END;

  PRAGMA Warnings(Off, "formal parameter ""Self"" is not referenced");

  FUNCTION GetResolution(Self : IN OUT InputSubclass) RETURN Positive IS

  BEGIN
    RETURN Resolution;
  END GetResolution;

  PRAGMA Warnings(On, "formal parameter ""Self"" is not referenced");

END MCP2221.ADC;
