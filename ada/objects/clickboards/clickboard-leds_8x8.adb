-- Services for the Mikroelektronika 8x8 LED Click

-- Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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

WITH MAX7219;
WITH ClickBoard;
WITH TrueColor;

USE TYPE MAX7219.Data;
USE TYPE MAX7219.Register;
USE TYPE TrueColor.Pixel;

PACKAGE BODY ClickBoard.LEDs_8x8 IS

  LEDs : ARRAY (MAX7219.Digit0 .. MAX7219.Digit7) OF MAX7219.Data;

  ORMASKS : CONSTANT ARRAY (0 .. 7) OF MAX7219.Data :=
    (16#01#, 16#02#, 16#04#, 16#08#, 16#10#, 16#20#, 16#40#, 16#80#);

  ANDMASKS : CONSTANT ARRAY (0 .. 7) OF MAX7219.Data :=
    (16#FE#, 16#FD#, 16#FB#, 16#F7#, 16#EF#, 16#DF#, 16#BF#, 16#7F#);

  -- Display object constructor

  FUNCTION Create(spidev : NOT NULL SPI.Device) RETURN TrueColor.Display IS

  BEGIN
    RETURN NEW DisplaySubclass'(MAX7219.Create(spidev) WITH NULL RECORD);
  END Create;

  -- Write a single pixel

  PROCEDURE Put
   (self  : DisplaySubclass;
    row   : Natural;
    col   : Natural;
    value : TrueColor.Pixel) IS

    digit : MAX7219.Register;
    bit   : Natural;

  BEGIN
    digit := MAX7219.DIGIT0 + MAX7219.Register(7 - col MOD 8);
    bit   := 7 - row MOD 8;

    IF value = TrueColor.Black THEN
      LEDs(digit) := LEDs(digit) AND ANDMASKS(bit);
    ELSE
      LEDs(digit) := LEDs(digit) OR ORMASKS(bit);
    END IF;

    self.Put(digit, LEDs(digit));
  END Put;

  -- Write a pixel buffer to the display

  PROCEDURE Put(self : DisplaySubclass; buf : TrueColor.Screen) IS

    digit : MAX7219.Register;
    bit   : Natural;

  BEGIN
    IF buf NOT IN ClickBoard.LEDs_8x8.Screen THEN
      RAISE Constraint_Error WITH "buf is not subtype ClickBoard.LEDs_8x8.Screen";
    END IF;

    FOR row IN ClickBoard.LEDs_8x8.Screen'Range(1) LOOP
      FOR col IN ClickBoard.LEDs_8x8.Screen'Range(2) LOOP
        digit := MAX7219.DIGIT0 + MAX7219.Register(7 - col MOD 8);
        bit   := 7 - row MOD 8;

        IF buf(row, col) = TrueColor.Black THEN
          LEDs(digit) := LEDs(digit) AND ANDMASKS(bit);
        ELSE
          LEDs(digit) := LEDs(digit) OR ORMASKS(bit);
        END IF;
      END LOOP;
    END LOOP;

    FOR digit IN LEDs'Range LOOP
      self.Put(digit, LEDs(digit));
    END LOOP;
  END Put;

  -- Clear the display

  PROCEDURE Clear(self : DisplaySubclass) IS

  BEGIN
    self.Initialize;

    FOR digit IN LEDs'Range LOOP
      LEDs(digit) := 16#00#;
    END LOOP;
  END Clear;

END ClickBoard.LEDs_8x8;
