-- MCP23x17 8-bit parallel port services

-- Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY MCP23x17.Byte IS

  -- Parallel port constructor

  FUNCTION Create(dev : NOT NULL MCP23x17.Device; which : PortNames) RETURN Port IS

  BEGIN
    RETURN NEW PortClass'(dev, which);
  END Create;

  -- Parallel port configuration methods

  PROCEDURE SetDirections(Self : PortClass; data : Byte) IS

  -- data: 1=output, 0=input

  BEGIN
    IF Self.which = GPA THEN
      Self.dev.WriteRegister8(IODIRA, NOT RegisterData8(data));
    ELSE
      Self.dev.WriteRegister8(IODIRB, NOT RegisterData8(data));
    END IF;
  END SetDirections;

  PROCEDURE SetPullups(Self : PortClass; data : Byte) IS

  -- data: 1=pullup enabled, 0=pullup disabled

  BEGIN
    IF Self.which = GPA THEN
      Self.dev.WriteRegister8(GPPUA, RegisterData8(data));
    ELSE
      Self.dev.WriteRegister8(GPPUB, RegisterData8(data));
    END IF;
  END SetPullups;

  -- Parallel port I/O methods

  FUNCTION Get(Self : PortClass) RETURN Byte IS

    data : RegisterData8;

  BEGIN
    IF Self.which = GPA THEN
      Self.dev.ReadRegister8(GPIOA, data);
    ELSE
      Self.dev.ReadRegister8(GPIOB, data);
    END IF;

    RETURN Byte(data);
  END Get;

  PROCEDURE Put(Self : PortClass; data : Byte) IS

  BEGIN
    IF Self.which = GPA THEN
      Self.dev.WriteRegister8(OLATA, RegisterData8(data));
    ELSE
      Self.dev.WriteRegister8(OLATB, RegisterData8(data));
    END IF;
  END Put;

END MCP23x17.Byte;
