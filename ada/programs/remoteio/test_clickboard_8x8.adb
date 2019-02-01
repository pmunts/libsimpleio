-- Test program for the Mikroelektronika 8x8 LED Matrix Click

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

WITH ClickBoard.LEDs_8x8.RemoteIO;
WITH RemoteIO.Client.hidapi;
WITH TrueColor;

PROCEDURE test_clickboard_8x8 IS

  remdev  : RemoteIO.Client.Device;
  display : TrueColor.Display;
  screen1 : ClickBoard.LEDs_8x8.Screen;
  screen2 : ClickBoard.LEDs_8x8.Screen;

BEGIN
  Put_Line("Mikroelektronika 8x8 LED Click Test");
  New_Line;

  remdev  := RemoteIO.Client.hidapi.Create;
  display := ClickBoard.LEDs_8x8.RemoteIO.Create(remdev, socknum => 1);
  display.Clear;

  -- Try pixel writes...

  Put_Line("Write pixels On...");

  FOR row IN ClickBoard.LEDs_8x8.Screen'Range(1) LOOP
    FOR col IN ClickBoard.LEDs_8x8.Screen'Range(2) LOOP
      display.Put(row, col, TrueColor.White);
      DELAY 0.05;
    END LOOP;
  END LOOP;

  Put_line("Write pixels Off...");

  FOR row IN ClickBoard.LEDs_8x8.Screen'Range(1) LOOP
    FOR col IN ClickBoard.LEDs_8x8.Screen'Range(2) LOOP
      display.Put(row, col, TrueColor.Black);
      DELAY 0.05;
    END LOOP;
  END LOOP;

  DELAY 1.0;

  -- Write checkerboard pattern to screen buffers

  FOR row IN ClickBoard.LEDs_8x8.Screen'Range(1) LOOP
    FOR col IN ClickBoard.LEDs_8x8.Screen'Range(2) LOOP
      IF ((row MOD 2 = 0) AND (col MOD 2 = 0)) OR
         ((row MOD 2 = 1) AND (col MOD 2 = 1)) THEN
        screen1(row, col) := TrueColor.White;
        screen2(row, col) := TrueColor.Black;
      ELSE
        screen1(row, col) := TrueColor.Black;
        screen2(row, col) := TrueColor.White;
      END IF;
    END LOOP;
  END LOOP;

  -- Try screen writes...

  FOR i IN 1 .. 2 LOOP
    Put_Line("Write screen1...");
    display.Put(screen1);
    DELAY 1.0;

    Put_Line("Write screen2...");
    display.Put(screen2);
    DELAY 1.0;
  END LOOP;

  display.Clear;
END test_clickboard_8x8;
