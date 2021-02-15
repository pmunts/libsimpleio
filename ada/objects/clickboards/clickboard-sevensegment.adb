-- Services for the Mikroelektronika 7seg Click

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

PACKAGE BODY ClickBoard.SevenSegment IS

  -- The segments of the Mikroelektronika Seven Segment Display
  -- Click Board are wired in an odd fashion.  The following
  -- permutation table transforms from standard seven segment
  -- layout to that of the Click Board.

  PermuteSegments : CONSTANT ARRAY (SPI.Byte) OF SPI.Byte :=
   (16#00#, 16#04#, 16#02#, 16#06#, 16#08#, 16#0C#, 16#0A#, 16#0E#,
    16#10#, 16#14#, 16#12#, 16#16#, 16#18#, 16#1C#, 16#1A#, 16#1E#,
    16#20#, 16#24#, 16#22#, 16#26#, 16#28#, 16#2C#, 16#2A#, 16#2E#,
    16#30#, 16#34#, 16#32#, 16#36#, 16#38#, 16#3C#, 16#3A#, 16#3E#,
    16#40#, 16#44#, 16#42#, 16#46#, 16#48#, 16#4C#, 16#4A#, 16#4E#,
    16#50#, 16#54#, 16#52#, 16#56#, 16#58#, 16#5C#, 16#5A#, 16#5E#,
    16#60#, 16#64#, 16#62#, 16#66#, 16#68#, 16#6C#, 16#6A#, 16#6E#,
    16#70#, 16#74#, 16#72#, 16#76#, 16#78#, 16#7C#, 16#7A#, 16#7E#,
    16#80#, 16#84#, 16#82#, 16#86#, 16#88#, 16#8C#, 16#8A#, 16#8E#,
    16#90#, 16#94#, 16#92#, 16#96#, 16#98#, 16#9C#, 16#9A#, 16#9E#,
    16#A0#, 16#A4#, 16#A2#, 16#A6#, 16#A8#, 16#AC#, 16#AA#, 16#AE#,
    16#B0#, 16#B4#, 16#B2#, 16#B6#, 16#B8#, 16#BC#, 16#BA#, 16#BE#,
    16#C0#, 16#C4#, 16#C2#, 16#C6#, 16#C8#, 16#CC#, 16#CA#, 16#CE#,
    16#D0#, 16#D4#, 16#D2#, 16#D6#, 16#D8#, 16#DC#, 16#DA#, 16#DE#,
    16#E0#, 16#E4#, 16#E2#, 16#E6#, 16#E8#, 16#EC#, 16#EA#, 16#EE#,
    16#F0#, 16#F4#, 16#F2#, 16#F6#, 16#F8#, 16#FC#, 16#FA#, 16#FE#,
    16#01#, 16#05#, 16#03#, 16#07#, 16#09#, 16#0D#, 16#0B#, 16#0F#,
    16#11#, 16#15#, 16#13#, 16#17#, 16#19#, 16#1D#, 16#1B#, 16#1F#,
    16#21#, 16#25#, 16#23#, 16#27#, 16#29#, 16#2D#, 16#2B#, 16#2F#,
    16#31#, 16#35#, 16#33#, 16#37#, 16#39#, 16#3D#, 16#3B#, 16#3F#,
    16#41#, 16#45#, 16#43#, 16#47#, 16#49#, 16#4D#, 16#4B#, 16#4F#,
    16#51#, 16#55#, 16#53#, 16#57#, 16#59#, 16#5D#, 16#5B#, 16#5F#,
    16#61#, 16#65#, 16#63#, 16#67#, 16#69#, 16#6D#, 16#6B#, 16#6F#,
    16#71#, 16#75#, 16#73#, 16#77#, 16#79#, 16#7D#, 16#7B#, 16#7F#,
    16#81#, 16#85#, 16#83#, 16#87#, 16#89#, 16#8D#, 16#8B#, 16#8F#,
    16#91#, 16#95#, 16#93#, 16#97#, 16#99#, 16#9D#, 16#9B#, 16#9F#,
    16#A1#, 16#A5#, 16#A3#, 16#A7#, 16#A9#, 16#AD#, 16#AB#, 16#AF#,
    16#B1#, 16#B5#, 16#B3#, 16#B7#, 16#B9#, 16#BD#, 16#BB#, 16#BF#,
    16#C1#, 16#C5#, 16#C3#, 16#C7#, 16#C9#, 16#CD#, 16#CB#, 16#CF#,
    16#D1#, 16#D5#, 16#D3#, 16#D7#, 16#D9#, 16#DD#, 16#DB#, 16#DF#,
    16#E1#, 16#E5#, 16#E3#, 16#E7#, 16#E9#, 16#ED#, 16#EB#, 16#EF#,
    16#F1#, 16#F5#, 16#F3#, 16#F7#, 16#F9#, 16#FD#, 16#FB#, 16#FF#);

  -- The following glyph pattern values came from:
  -- https://en.wikipedia.org/wiki/Seven-segment_display

  GlyphTable : CONSTANT ARRAY (0 .. 15) OF Segments :=
   (16#3F#, 16#06#, 16#5B#, 16#4F#, 16#66#, 16#6D#, 16#7D#, 16#07#,
    16#7F#, 16#6F#, 16#77#, 16#7C#, 16#39#, 16#5E#, 16#79#, 16#71#);

  FUNCTION Create
   (spidev : NOT NULL SPI.Device;
    pwmpin : NOT NULL GPIO.PIN;
    rstpin : NOT NULL GPIO.Pin) RETURN Display IS

  BEGIN
    RETURN Display'(spidev, pwmpin, null, rstpin);
  END Create;

  FUNCTION Create
   (spidev : NOT NULL SPI.Device;
    pwmout : NOT NULL Standard.PWM.Output;
    rstpin : NOT NULL GPIO.Pin) RETURN Display IS

  BEGIN
    RETURN Display'(spidev, null, pwmout, rstpin);
  END Create;

  PROCEDURE Write(self : Display; segs : Segments) IS

    outbuf : SPI.Command(0 .. 1);

  BEGIN
    outbuf(0) := PermuteSegments(SPI.Byte(segs MOD 256));
    outbuf(1) := PermuteSegments(SPI.Byte(segs /   256));
    self.spidev.Write(outbuf, 2);
  END Write;

  PROCEDURE Clear(self : Display) IS

  BEGIN
    self.Write(0);
  END Clear;

  PROCEDURE Put
   (self     : Display;
    n        : Natural;
    features : SevenSegment.Features := FEATURES_7SEG_DEC OR FEATURES_7SEG_LZB) IS

    base : Natural;
    segs : ClickBoard.SevenSegment.Segments;

  BEGIN
    IF (features AND FEATURES_7SEG_HEX) = 0 THEN
      base := 10;
    ELSE
      base := 16;
    END IF;

    IF n >= base**2 THEN
      RAISE Constraint_ERROR WITH "ClickBoard.SevenSegment.Display.Write(): Parameter is out of range";
    END IF;

    segs := GlyphTable(n / base)*256 + GlyphTable(n MOD base);

    -- Blank leading zero, if feature is enabled

    IF ((features AND FEATURES_7SEG_LZB) = FEATURES_7SEG_LZB) AND (n / base = 0) THEN
      segs := segs AND 16#00FF#;
    END IF;

    -- Turn on left decimal point, if feature is enabled

    IF (features AND FEATURES_7SEG_LDP) = FEATURES_7SEG_LDP THEN
      segs := segs OR SEGMENT_LEFT_DP;
    END IF;

    -- Turn on right decimal point, if feature is enabled

    IF (features AND FEATURES_7SEG_RDP) = FEATURES_7SEG_RDP THEN
      segs := segs OR SEGMENT_RIGHT_DP;
    END IF;

    self.Write(segs);
  END Put;

END ClickBoard.SevenSegment;
