-- Mikroelektronika Click Board shield services, using libsimpleio

-- Copyright (C)2016-2025, Philip Munts dba Munts Technologies.
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

WITH Ada.Characters.Handling;
WITH Ada.Environment_Variables;
WITH Ada.Strings.Fixed;

PACKAGE BODY ClickBoard.Shields IS

  FUNCTION getenv(name : String) RETURN String IS

  BEGIN
    IF Ada.Environment_Variables.Exists(name) THEN
      RETURN Ada.Characters.Handling.To_Lower(Ada.Environment_Variables.Value(name));
    ELSE
      RETURN "";
    END IF;
  END getenv;

  FUNCTION matchenv(name: String; target : String) RETURN Boolean IS

  BEGIN
    RETURN Ada.Strings.Fixed.Index(getenv(name), target) = 1;
  END matchenv;

  FUNCTION Detect RETURN Kind IS

  BEGIN

    -- First, try to get the shield from the SHIELDNAME environment variable:

    BEGIN
      RETURN ClickBoard.Shields.Kind'Value(getenv("SHIELDNAME"));
    EXCEPTION
      WHEN OTHERS => NULL;
    END;

    -- The nifty PocketBeagle doesn't need a shield!

    IF matchenv("BOARDNAME", "pocketbeagle") THEN
      RETURN ClickBoard.Shields.PocketBeagle;
    END IF;

    RETURN ClickBoard.Shields.Unknown;
  END Detect;

END ClickBoard.Shields;
