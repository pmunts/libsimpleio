-- MCP23017 8-bit parallel port services

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY MCP23017.BytePorts IS

  -- Parallel port constructor

  FUNCTION Create(dev : MCP23017.Device; which : PortNames) RETURN Port IS

  BEGIN
    RETURN NEW PortClass'(dev, which);
  END Create;

  -- Parallel port configuration methods

  PROCEDURE SetDirections(self : PortClass; data : Byte) IS

  -- data: 1=output, 0=input

  BEGIN
    IF self.which = GPA THEN
      self.dev.WriteRegister8(IODIRA, NOT RegisterData8(data));
    ELSE
      self.dev.WriteRegister8(IODIRB, NOT RegisterData8(data));
    END IF;
  END SetDirections;

  PROCEDURE SetPullups(self : PortClass; data : Byte) IS

  -- data: 1=pullup enabled, 0=pullup disabled

  BEGIN
    IF self.which = GPA THEN
      self.dev.WriteRegister8(GPPUA, RegisterData8(data));
    ELSE
      self.dev.WriteRegister8(GPPUB, RegisterData8(data));
    END IF;
  END SetPullups;

  -- Parallel port I/O methods

  FUNCTION Get(self : PortClass) RETURN Byte IS

    data : RegisterData8;

  BEGIN
    IF self.which = GPA THEN
      self.dev.ReadRegister8(GPIOA, data);
    ELSE
      self.dev.ReadRegister8(GPIOB, data);
    END IF;

    RETURN Byte(data);
  END Get;

  PROCEDURE Put(self : PortClass; data : Byte) IS

  BEGIN
    IF self.which = GPA THEN
      self.dev.WriteRegister8(OLATA, RegisterData8(data));
    ELSE
      self.dev.WriteRegister8(OLATB, RegisterData8(data));
    END IF;
  END Put;

END MCP23017.BytePorts;
