-- PocketBeagle GPIO Pins

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE GPIO.libsimpleio.PocketBeagle IS

  GPIO2   : CONSTANT Designator := (0,  2);  -- P1.8   SPI0 SCLK
  GPIO3   : CONSTANT Designator := (0,  3);  -- P1.10  SPI0 MISO
  GPIO4   : CONSTANT Designator := (0,  4);  -- P1.12  SPI0 MOSI
  GPIO5   : CONSTANT Designator := (0,  5);  -- P1.6   SPI0 CS
  GPIO7   : CONSTANT Designator := (0,  7);  -- P2.29  SPI1 SCLK
  GPIO12  : CONSTANT Designator := (0, 12);  -- P1.26  I2C2 SDA
  GPIO13  : CONSTANT Designator := (0, 13);  -- P1.28  I2C2 SCL
  GPIO14  : CONSTANT Designator := (0, 14);  -- P2.11  I2C1 SDA
  GPIO15  : CONSTANT Designator := (0, 15);  -- P2.9   I2C1 SCL
  GPIO19  : CONSTANT Designator := (0, 19);  -- P2.31  SPI1 CS
  GPIO20  : CONSTANT Designator := (0, 20);  -- P1.20
  GPIO23  : CONSTANT Designator := (0, 23);  -- P2.3
  GPIO26  : CONSTANT Designator := (0, 26);  -- P1.34
  GPIO27  : CONSTANT Designator := (0, 27);  -- P2.19
  GPIO30  : CONSTANT Designator := (0, 30);  -- P2.5   RXD4
  GPIO31  : CONSTANT Designator := (0, 31);  -- P2.7   TXD4
  GPIO40  : CONSTANT Designator := (1,  8);  -- P2.27  SPI1 MISO
  GPIO41  : CONSTANT Designator := (1,  9);  -- P2.25  SPI1 MOSI
  GPIO42  : CONSTANT Designator := (1, 10);  -- P1.32  RXD0
  GPIO43  : CONSTANT Designator := (1, 11);  -- P1.30  TXD0
  GPIO44  : CONSTANT Designator := (1, 12);  -- P2.24
  GPIO45  : CONSTANT Designator := (1, 13);  -- P2.33
  GPIO46  : CONSTANT Designator := (1, 14);  -- P2.22
  GPIO47  : CONSTANT Designator := (1, 15);  -- P2.18
  GPIO50  : CONSTANT Designator := (1, 18);  -- P2.1
  GPIO52  : CONSTANT Designator := (1, 20);  -- P2.10
  GPIO57  : CONSTANT Designator := (1, 25);  -- P2.6
  GPIO58  : CONSTANT Designator := (1, 26);  -- P2.4
  GPIO59  : CONSTANT Designator := (1, 27);  -- P2.2
  GPIO60  : CONSTANT Designator := (1, 28);  -- P2.8
  GPIO64  : CONSTANT Designator := (2,  0);  -- P2.20
  GPIO65  : CONSTANT Designator := (2,  1);  -- P2.17
  GPIO86  : CONSTANT Designator := (2, 22);  -- P2.35  AIN5 3.3V
  GPIO87  : CONSTANT Designator := (2, 23);  -- P1.2   AIN6 3.3V
  GPIO88  : CONSTANT Designator := (2, 24);  -- P1.35
  GPIO89  : CONSTANT Designator := (2, 25);  -- P1.4
  GPIO110 : CONSTANT Designator := (3, 14);  -- P1.36
  GPIO111 : CONSTANT Designator := (3, 15);  -- P1.33
  GPIO112 : CONSTANT Designator := (3, 16);  -- P2.32
  GPIO113 : CONSTANT Designator := (3, 17);  -- P2.30
  GPIO114 : CONSTANT Designator := (3, 18);  -- P1.31
  GPIO115 : CONSTANT Designator := (3, 19);  -- P2.34
  GPIO116 : CONSTANT Designator := (3, 20);  -- P2.28
  GPIO117 : CONSTANT Designator := (3, 21);  -- P1.29

  -- Create an array to map a sysfs pin number to its gpiod descriptor

  SUBTYPE PinNumbers IS Natural RANGE 0 .. 127;

  Map : CONSTANT ARRAY (PinNumbers) OF Designator :=
   (2   => GPIO2,
    3   => GPIO3,
    4   => GPIO4,
    5   => GPIO5,
    7   => GPIO7,
    12  => GPIO12,
    13  => GPIO13,
    14  => GPIO14,
    15  => GPIO15,
    19  => GPIO19,
    20  => GPIO20,
    23  => GPIO23,
    26  => GPIO26,
    27  => GPIO27,
    30  => GPIO30,
    31  => GPIO31,
    40  => GPIO40,
    41  => GPIO41,
    42  => GPIO42,
    43  => GPIO43,
    44  => GPIO44,
    45  => GPIO45,
    46  => GPIO46,
    47  => GPIO47,
    50  => GPIO50,
    52  => GPIO52,
    57  => GPIO57,
    58  => GPIO58,
    59  => GPIO59,
    60  => GPIO60,
    64  => GPIO64,
    65  => GPIO65,
    86  => GPIO86,
    87  => GPIO87,
    88  => GPIO88,
    89  => GPIO89,
    110 => GPIO110,
    111 => GPIO111,
    112 => GPIO112,
    113 => GPIO113,
    114 => GPIO114,
    115 => GPIO115,
    116 => GPIO116,
    117 => GPIO117,

    OTHERS => Unavailable);

END GPIO.libsimpleio.PocketBeagle;
