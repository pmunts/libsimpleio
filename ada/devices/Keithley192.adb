-- Keithley 192 DMM Services

-- Copyright (C)2023, Philip Munts.
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

WITH GPIB.Slave;

PACKAGE BODY Keithley192 IS

  -- Configure DMM

  PROCEDURE Configure(Self : Device; config : String) IS

  BEGIN
    -- Issue command string

    Self.Put(config & "X");

    -- Receive throwaway response string

    DECLARE
      resp : String := Self.Get;
    BEGIN
      NULL;
    END;
  END Configure;

  -- Get one measurement (cast to Voltage.Volts or Resistance.Ohms)

  FUNCTION Get(Self : IN OUT Device) RETURN Float IS

    inbuf : String(1 .. 16);

  BEGIN
    -- Issue command string

    Self.Put("X");

    -- Receive response string

    inbuf := Self.Get;

    -- Validate response string

    IF inbuf(1) = 'O' THEN
      RAISE OutOfRange;
    END IF;

    -- Return result

    RETURN Float'Value(inbuf(5..16));
  END Get;

END Keithley192;
