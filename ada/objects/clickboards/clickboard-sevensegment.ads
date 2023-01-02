-- Services for the Mikroelektronika 7seg Click

-- Copyright (C)2016-2022, Philip Munts, President, Munts AM Corp.
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

-- WARNING: The MISO (aka SDO) signal from the 7seg Click is NOT a tri-state
-- output enabled by slave select.  You will probably want to remove the MISO
-- pin to prevent bus contention if your system shares MISO between more than
-- one slave device.

WITH GPIO;
WITH PWM;
WITH SPI;

PACKAGE ClickBoard.SevenSegment IS

  -- SPI transfer characteristics

  SPI_Mode      : CONSTANT Natural := 0;
  SPI_WordSize  : CONSTANT Natural := 8;
  SPI_Frequency : CONSTANT Natural := 4_000_000;

  TYPE Display IS TAGGED PRIVATE;

  TYPE Segments IS MOD 2**16;

  SEGMENT_LEFT_A    : CONSTANT Segments := 16#0100#;
  SEGMENT_LEFT_B    : CONSTANT Segments := 16#0200#;
  SEGMENT_LEFT_C    : CONSTANT Segments := 16#0400#;
  SEGMENT_LEFT_D    : CONSTANT Segments := 16#0800#;
  SEGMENT_LEFT_E    : CONSTANT Segments := 16#1000#;
  SEGMENT_LEFT_F    : CONSTANT Segments := 16#2000#;
  SEGMENT_LEFT_G    : CONSTANT Segments := 16#4000#;
  SEGMENT_LEFT_DP   : CONSTANT Segments := 16#8000#;

  SEGMENT_RIGHT_A   : CONSTANT Segments := 16#0001#;
  SEGMENT_RIGHT_B   : CONSTANT Segments := 16#0002#;
  SEGMENT_RIGHT_C   : CONSTANT Segments := 16#0004#;
  SEGMENT_RIGHT_D   : CONSTANT Segments := 16#0008#;
  SEGMENT_RIGHT_E   : CONSTANT Segments := 16#0010#;
  SEGMENT_RIGHT_F   : CONSTANT Segments := 16#0020#;
  SEGMENT_RIGHT_G   : CONSTANT Segments := 16#0040#;
  SEGMENT_RIGHT_DP  : CONSTANT Segments := 16#0080#;

  SEGMENT_BLANK     : CONSTANT Segments := 0;

  TYPE Features IS MOD 2**32;

  FEATURES_7SEG_DEC : CONSTANT Features := 16#00#; -- Display decimal number 0-99
  FEATURES_7SEG_HEX : CONSTANT Features := 16#01#; -- Display hexadecimal number 0-FF
  FEATURES_7SEG_LZB : CONSTANT Features := 16#02#; -- Leading zero blanking
  FEATURES_7SEG_RDP : CONSTANT Features := 16#04#; -- Right decimal point
  FEATURES_7SEG_LDP : CONSTANT Features := 16#08#; -- Left decimal point

  FUNCTION Create
   (spidev : NOT NULL SPI.Device;
    pwmpin : NOT NULL GPIO.PIN;
    rstpin : NOT NULL GPIO.Pin) RETURN Display;

  FUNCTION Create
   (spidev : NOT NULL SPI.Device;
    pwmout : NOT NULL Standard.PWM.Output;
    rstpin : NOT NULL GPIO.Pin) RETURN Display;

  PROCEDURE Write
   (self : Display;
    segs : Segments);

  PROCEDURE Clear
   (self : Display);

  PROCEDURE Put
   (self     : Display;
    n        : Natural;
    features : SevenSegment.Features := FEATURES_7SEG_DEC OR FEATURES_7SEG_LZB);

PRIVATE

  TYPE Display IS TAGGED RECORD
    spidev : SPI.Device;
    pwmpin : GPIO.Pin;
    pwmout : Standard.PWM.Output;
    rstpin : GPIO.Pin;
  END RECORD;

END ClickBoard.SevenSegment;
