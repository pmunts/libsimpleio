-- BeagleBone GPIO Pins

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

PACKAGE GPIO.libsimpleio.BeagleBone IS

  GPIO2   : CONSTANT Designator := (0,  2);  -- P9.22  UART2 RXD
  GPIO3   : CONSTANT Designator := (0,  3);  -- P9.21  UART2 TXD
  GPIO4   : CONSTANT Designator := (0,  4);  -- P9.18
  GPIO5   : CONSTANT Designator := (0,  5);  -- P9.17
  GPIO7   : CONSTANT Designator := (0,  7);  -- P9.42  SPI1 SS1
  GPIO8   : CONSTANT Designator := (0,  8);  -- P8.35
  GPIO9   : CONSTANT Designator := (0,  9);  -- P8.33
  GPIO10  : CONSTANT Designator := (0, 10);  -- P8.31
  GPIO11  : CONSTANT Designator := (0, 11);  -- P8.32
  GPIO12  : CONSTANT Designator := (0, 12);  -- P9.20  I2C2 SDA
  GPIO13  : CONSTANT Designator := (0, 13);  -- P9.19  I2C2 SCL
  GPIO14  : CONSTANT Designator := (0, 14);  -- P9.26  UART1 RXD
  GPIO15  : CONSTANT Designator := (0, 15);  -- P9.24  UART1 TXD
  GPIO20  : CONSTANT Designator := (0, 20);  -- P9.41
  GPIO22  : CONSTANT Designator := (0, 22);  -- P8.19
  GPIO23  : CONSTANT Designator := (0, 23);  -- P8.13
  GPIO26  : CONSTANT Designator := (0, 26);  -- P8.14
  GPIO27  : CONSTANT Designator := (0, 27);  -- P8.17
  GPIO30  : CONSTANT Designator := (0, 30);  -- P9.11  UART4 RXD
  GPIO31  : CONSTANT Designator := (0, 31);  -- P9.13  UART4 TXD
  GPIO32  : CONSTANT Designator := (1,  0);  -- P8.25  MMC1 DAT0
  GPIO33  : CONSTANT Designator := (1,  1);  -- P8.24  MMC1 DAT1
  GPIO34  : CONSTANT Designator := (1,  2);  -- P8.5   MMC1 DAT2
  GPIO35  : CONSTANT Designator := (1,  3);  -- P8.6   MMC1 DAT3
  GPIO36  : CONSTANT Designator := (1,  4);  -- P8.23  MMC1 DAT4
  GPIO37  : CONSTANT Designator := (1,  5);  -- P8.22  MMC1 DAT5
  GPIO38  : CONSTANT Designator := (1,  6);  -- P8.3   MMC1 DAT6
  GPIO39  : CONSTANT Designator := (1,  7);  -- P8.4   MMC1 DAT7
  GPIO44  : CONSTANT Designator := (1, 12);  -- P8.12
  GPIO45  : CONSTANT Designator := (1, 13);  -- P8.11
  GPIO46  : CONSTANT Designator := (1, 14);  -- P8.16
  GPIO47  : CONSTANT Designator := (1, 15);  -- P8.15
  GPIO48  : CONSTANT Designator := (1, 16);  -- P9.15
  GPIO49  : CONSTANT Designator := (1, 17);  -- P9.23
  GPIO50  : CONSTANT Designator := (1, 18);  -- P9.14
  GPIO51  : CONSTANT Designator := (1, 19);  -- P9.16
  GPIO60  : CONSTANT Designator := (1, 28);  -- P9.12
  GPIO61  : CONSTANT Designator := (1, 29);  -- P8.26
  GPIO62  : CONSTANT Designator := (1, 30);  -- P8.21  MMC1 CLK
  GPIO63  : CONSTANT Designator := (1, 31);  -- P8.20  MMC1 CMD
  GPIO65  : CONSTANT Designator := (2,  1);  -- P8.18
  GPIO66  : CONSTANT Designator := (2,  2);  -- P8.7
  GPIO67  : CONSTANT Designator := (2,  3);  -- P8.8
  GPIO68  : CONSTANT Designator := (2,  4);  -- P8.10
  GPIO69  : CONSTANT Designator := (2,  5);  -- P8.9
  GPIO70  : CONSTANT Designator := (2,  6);  -- P8.45
  GPIO71  : CONSTANT Designator := (2,  7);  -- P8.46
  GPIO72  : CONSTANT Designator := (2,  8);  -- P8.43
  GPIO73  : CONSTANT Designator := (2,  9);  -- P8.44
  GPIO74  : CONSTANT Designator := (2, 10);  -- P8.41
  GPIO75  : CONSTANT Designator := (2, 11);  -- P8.42
  GPIO76  : CONSTANT Designator := (2, 12);  -- P8.39
  GPIO77  : CONSTANT Designator := (2, 13);  -- P8.40
  GPIO78  : CONSTANT Designator := (2, 14);  -- P8.37  UART5 TXD
  GPIO79  : CONSTANT Designator := (2, 15);  -- P8.38  UART5 RXD
  GPIO80  : CONSTANT Designator := (2, 16);  -- P8.36
  GPIO81  : CONSTANT Designator := (2, 17);  -- P8.34
  GPIO86  : CONSTANT Designator := (2, 22);  -- P8.27
  GPIO87  : CONSTANT Designator := (2, 23);  -- P8.29
  GPIO88  : CONSTANT Designator := (2, 24);  -- P8.28
  GPIO89  : CONSTANT Designator := (2, 25);  -- P8.30
  GPIO110 : CONSTANT Designator := (3, 14);  -- P9.31  SPI1 SCLK
  GPIO111 : CONSTANT Designator := (3, 15);  -- P9.29  SPI1 MISO
  GPIO112 : CONSTANT Designator := (3, 16);  -- P9.30  SPI1 MOSI
  GPIO113 : CONSTANT Designator := (3, 17);  -- P9.28  SPI1 SS0
  GPIO115 : CONSTANT Designator := (3, 19);  -- P9.27
  GPIO117 : CONSTANT Designator := (3, 21);  -- P9.25

  -- Create an array to map a sysfs pin number to its gpiod descriptor

  SUBTYPE PinNumbers IS Natural RANGE 0 .. 127;

  Map : CONSTANT ARRAY (PinNumbers) OF Designator :=
   (2   => GPIO2,
    3   => GPIO3,
    4   => GPIO4,
    5   => GPIO5,
    7   => GPIO7,
    8   => GPIO8,
    9   => GPIO9,
    10  => GPIO10,
    11  => GPIO11,
    12  => GPIO12,
    13  => GPIO13,
    14  => GPIO14,
    15  => GPIO15,
    20  => GPIO20,
    22  => GPIO22,
    23  => GPIO23,
    26  => GPIO26,
    27  => GPIO27,
    30  => GPIO30,
    31  => GPIO31,
    32  => GPIO32,
    33  => GPIO33,
    34  => GPIO34,
    35  => GPIO35,
    36  => GPIO36,
    37  => GPIO37,
    38  => GPIO38,
    39  => GPIO39,
    44  => GPIO44,
    45  => GPIO45,
    46  => GPIO46,
    47  => GPIO47,
    48  => GPIO48,
    49  => GPIO49,
    50  => GPIO50,
    51  => GPIO51,
    60  => GPIO60,
    61  => GPIO61,
    62  => GPIO62,
    63  => GPIO63,
    65  => GPIO65,
    66  => GPIO66,
    67  => GPIO67,
    68  => GPIO68,
    69  => GPIO69,
    70  => GPIO70,
    71  => GPIO71,
    72  => GPIO72,
    73  => GPIO73,
    74  => GPIO74,
    75  => GPIO75,
    76  => GPIO76,
    77  => GPIO77,
    78  => GPIO78,
    79  => GPIO79,
    80  => GPIO80,
    81  => GPIO81,
    86  => GPIO86,
    87  => GPIO87,
    88  => GPIO88,
    89  => GPIO89,
    110 => GPIO110,
    111 => GPIO111,
    112 => GPIO112,
    113 => GPIO113,
    115 => GPIO115,
    117 => GPIO117,

    OTHERS => Unavailable);

END GPIO.libsimpleio.BeagleBone;
