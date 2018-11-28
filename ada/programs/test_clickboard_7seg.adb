-- Test program for the Mikroelektronika 7seg Click

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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH ClickBoard.SevenSegment.libsimpleio;

USE TYPE ClickBoard.SevenSegment.Features;

PROCEDURE test_clickboard_7seg IS

  display : ClickBoard.SevenSegment.Display;

BEGIN
  New_Line;
  Put_Line("Mikroelektronika 7seg Click Test");
  New_Line;

  display := ClickBoard.SevenSegment.libsimpleio.Create(socknum => 2);

  -- Count up

  FOR n IN Natural Range 0 .. 99 LOOP
    display.Put(n);
    DELAY 0.1;
  END LOOP;

  DELAY 1.0;

  -- Count down

  FOR n IN REVERSE Natural Range 0 .. 99 LOOP
    display.Put(n, ClickBoard.SevenSegment.FEATURES_7SEG_DEC);
    DELAY 0.1;
  END LOOP;

  DELAY 1.0;

  -- Count up in hexadecimal

  FOR i IN Natural RANGE 0 .. 255 LOOP
    display.Put(i, ClickBoard.SevenSegment.FEATURES_7SEG_HEX OR
      ClickBoard.SevenSegment.FEATURES_7SEG_LDP);
    DELAY 0.1;
  END LOOP;

  DELAY 1.0;

  -- Count down in hexadecimal

  FOR i IN REVERSE Natural RANGE 0 .. 255 LOOP
    display.Put(i, ClickBoard.SevenSegment.FEATURES_7SEG_HEX OR
      ClickBoard.SevenSegment.FEATURES_7SEG_RDP);
    DELAY 0.1;
  END LOOP;

  DELAY 1.0;

  -- Blank the display

  display.Clear;
END test_clickboard_7seg;
