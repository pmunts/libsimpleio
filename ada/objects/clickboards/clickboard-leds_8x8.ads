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

-- 8 by 8 LED Display layout:

-- Top left LED     is row 0 column 0
-- Bottom right LED is row 7 column 7

WITH MAX7219;
WITH SPI;
WITH TrueColor;

PACKAGE ClickBoard.LEDs_8x8 IS

  -- SPI transfer characteristics

  SPI_Mode      : Natural RENAMES MAX7219.SPI_Mode;
  SPI_WordSize  : Natural RENAMES MAX7219.SPI_WordSize;
  SPI_Frequency : Natural RENAMES MAX7219.SPI_Frequency;

  -- Display characteristics

  SUBTYPE Screen IS TrueColor.Screen(0 .. 7, 0 .. 7);

  -- Display class definition

  TYPE DisplaySubclass IS NEW MAX7219.DeviceClass AND
    TrueColor.DisplayInterface WITH PRIVATE;

  -- Display object constructor

  FUNCTION Create(spidev : NOT NULL SPI.Device) RETURN TrueColor.Display;

  -- Write a single pixel

  PROCEDURE Put
   (self  : DisplaySubclass;
    row   : Natural;
    col   : Natural;
    value : TrueColor.Pixel);

  -- Write a pixel buffer to the display

  PROCEDURE Put(self : DisplaySubclass; buf : TrueColor.Screen);

  -- Clear the display

  PROCEDURE Clear(self : DisplaySubclass);

PRIVATE

  TYPE DisplaySubclass IS NEW MAX7219.DeviceClass AND
    TrueColor.DisplayInterface WITH NULL RECORD;

END ClickBoard.LEDs_8x8;
