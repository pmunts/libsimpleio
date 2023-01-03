-- MCP23x17 16-bit parallel port services

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

PACKAGE MCP23x17.Word IS

  TYPE Word IS MOD 2**16;

  TYPE PortClass IS TAGGED PRIVATE;

  TYPE Port IS ACCESS PortClass;

  -- Parallel port constructor

  FUNCTION Create(dev : NOT NULL MCP23x17.Device) RETURN Port;

  -- Parallel port configuration methods

  PROCEDURE SetDirections(Self : PortClass; data : Word); -- 1=output, 0=input

  PROCEDURE SetPullups(Self : PortClass; data : Word); -- 1=enabled, 0=disabled

  -- Parallel port I/O methods

  FUNCTION Get(Self : PortClass) RETURN Word;

  PROCEDURE Put(Self : PortClass; data : Word);

PRIVATE

  TYPE PortClass IS TAGGED RECORD
    dev : MCP23x17.Device;
  END RECORD;

END MCP23x17.Word;
