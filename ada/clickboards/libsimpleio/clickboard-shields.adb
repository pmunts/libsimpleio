-- Mikroelektronika Click Board shield services

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Strings.Fixed;

WITH SystemInfo;

PACKAGE BODY ClickBoard.Shields IS

  FUNCTION Detect RETURN Kind IS

  BEGIN

    -- First, try to get the shield from the SHIELDNAME environment variable:

    BEGIN
      RETURN ClickBoard.Shields.Kind'Value(SystemInfo.ShieldName);
    EXCEPTION
      WHEN OTHERS => NULL;
    END;

    -- In the absence of SHIELDNAME, assume the Pi 2 Click Shield
    -- (MIKROE-1512/1513) for all Raspberry Pi boards

    -- TODO: There is now a Pi 3 Click Shield which includes on an on-board
    -- A/D converter.  At some point we may want to change the default shield
    -- from PiClick2 to PiClick3.

    IF Ada.Strings.Fixed.Index(SystemInfo.BoardName, "raspberrypi") = 1 THEN
      -- Raspberry Pi running MuntsOS
      RETURN ClickBoard.Shields.PiClick2;
    END IF;

    -- In the absence of SHIELDNAME, assume the Beagle Bone Click Shield
    -- (MIKROE-1596) for all BeagleBone boards

    -- TODO: The Beagle Bone Click Shield (MIKROE-1596) has been replaced
    -- by the Mikrobus Cape (MIKROE-1857).  At some point we may want to
    -- change the default shield from BeagleBoneClick2 to BeagleBoneClick4.

    IF Ada.Strings.Fixed.Index(SystemInfo.BoardName, "beaglebone") = 1 THEN
      -- BeagleBone running MuntsOS
      RETURN ClickBoard.Shields.BeagleBoneClick2;
    END IF;

    -- The nifty PocketBeagle doesn't need a shield!

    IF Ada.Strings.Fixed.Index(SystemInfo.BoardName, "pocketbeagle") = 1 THEN
      -- PocketBeagle running MuntsOS
      RETURN ClickBoard.Shields.PocketBeagle;
    END IF;

    RAISE ShieldError WITH "Cannot identify the ClickBoard shield";
  END Detect;

END ClickBoard.Shields;
