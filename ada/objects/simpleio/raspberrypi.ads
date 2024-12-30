-- Raspberry Pi I/O Resource Definitions

-- Copyright (C)2018-2024, Philip Munts dba Munts Technologies.
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

WITH Device;
WITH CPUInfo;
WITH OrangePiZero2W;
WITH RaspberryPi5;

USE TYPE CPUInfo.Kinds;

PACKAGE RaspberryPi IS
  
  Orange : CONSTANT Boolean := (CPUInfo.ModelName = OrangePiZero2W.ModelName);
  Pi5    : CONSTANT Boolean := (CPUInfo.Kind = CPUInfo.BCM2712);

  ----------------------------------------------------------------------------

  -- The canonical 40-pin expansion header I/O resources, common across all
  -- Raspberry Pi platforms including the Orange Pi Zero 2W:

  -- Raspberry Pi boards don't have a built-in ADC (Analog to Digital
  -- Converter) subsystem, so the following analog input designators are
  -- placeholders for the first IIO (Industrial I/O) ADC device, which is
  -- often on a HAT like the Pi 3 Click Shield or an expansion board like
  -- the MUNTS-0018 Raspberry Pi Tutorial I/O Board.

  AIN0   : CONSTANT Device.Designator := (0, 0);
  AIN1   : CONSTANT Device.Designator := (0, 1);
  AIN2   : CONSTANT Device.Designator := (0, 2);
  AIN3   : CONSTANT Device.Designator := (0, 3);
  AIN4   : CONSTANT Device.Designator := (0, 4);
  AIN5   : CONSTANT Device.Designator := (0, 5);
  AIN6   : CONSTANT Device.Designator := (0, 6);
  AIN7   : CONSTANT Device.Designator := (0, 7);

  GPIO2  : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO2  ELSE (0,  2));  -- Pin 3  I2C1 SDA
  GPIO3  : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO3  ELSE (0,  3));  -- Pin 5  I2C1 SCL
  GPIO4  : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO4  ELSE (0,  4));  -- Pin 7
  GPIO5  : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO5  ELSE (0,  5));  -- Pin 29
  GPIO6  : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO6  ELSE (0,  6));  -- Pin 30
  GPIO7  : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO7  ELSE (0,  7));  -- Pin 26 SPI0 SS1
  GPIO8  : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO8  ELSE (0,  8));  -- Pin 24 SPI0 SS0
  GPIO9  : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO9  ELSE (0,  9));  -- Pin 21 SPI0 MISO
  GPIO10 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO10 ELSE (0, 10));  -- Pin 19 SPI0 MOSI
  GPIO11 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO11 ELSE (0, 11));  -- Pin 23 SPI0 SCLK
  GPIO12 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO12 ELSE (0, 12));  -- Pin 32 PWM0
  GPIO13 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO13 ELSE (0, 13));  -- Pin 33 PWM1
  GPIO14 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO14 ELSE (0, 14));  -- Pin 8  UART0 TXD
  GPIO15 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO15 ELSE (0, 15));  -- Pin 10 UART0 RXD
  GPIO16 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO16 ELSE (0, 16));  -- Pin 36 SPI1 SS2
  GPIO17 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO17 ELSE (0, 17));  -- Pin 11 SPI1 SS1
  GPIO18 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO18 ELSE (0, 18));  -- Pin 12 PWM0 SPI1 SS0
  GPIO19 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO19 ELSE (0, 19));  -- Pin 35 PWM1 SPI1 MISO
  GPIO20 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO20 ELSE (0, 20));  -- Pin 38 SPI1 MOSI
  GPIO21 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO21 ELSE (0, 21));  -- Pin 40 SPI1 SCLK
  GPIO22 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO22 ELSE (0, 22));  -- Pin 15
  GPIO23 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO23 ELSE (0, 23));  -- Pin 16
  GPIO24 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO24 ELSE (0, 24));  -- Pin 18
  GPIO25 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO25 ELSE (0, 25));  -- Pin 22
  GPIO26 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO26 ELSE (0, 26));  -- Pin 37
  GPIO27 : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.GPIO27 ELSE (0, 27));  -- Pin 13

  I2C1   : CONSTANT Device.Designator := (0, 1); -- Pins 3 and 5

  PWM0   : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.PWM1 ELSIF Pi5 THEN RaspberryPi5.PWM0 ELSE (0, 0)); -- Pin 32
  PWM1   : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.PWM2 ELSIF Pi5 THEN RaspberryPi5.PWM1 ELSE (0, 1)); -- Pin 33

  SPI0_0 : CONSTANT Device.Designator := (0, 0); -- Pins 19, 21, 23, 24
  SPI0_1 : CONSTANT Device.Designator := (0, 1); -- Pins 19, 21, 23, 26

  ----------------------------------------------------------------------------

  -- The Orange Pi Zero 2W has two more GPIO pins or an I2C bus on pins 27
  -- and 28, which are supposed to be reserved for the VideoCore subsystem
  -- on Raspberry Pis.

  GPIO0  : CONSTANT Device.Designator := (IF Orange Then OrangePiZero2W.GPIO0 ELSE Device.Unavailable); -- Pin 27
  GPIO1  : CONSTANT Device.Designator := (IF Orange Then OrangePiZero2W.GPIO1 ELSE Device.Unavailable); -- Pin 28

  I2C2   : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.I2C2  ELSE Device.Unavailable); -- Pins 27 and 28

  -- Raspberry Pis 1 to 4 have PWM0 and PWM1 multiplexed to GPIO18 and GPIO19
  -- on a secondary basis.  Some HAT's like the Pi 3 Click Shield need PWM0
  -- on GPIO18.  The definitions below make PWM2 and PWM3 synonyms for PWM0
  -- and PWM1, to make the best of a bad situation.
  --
  -- Raspberry Pi 5 has its two additional PWM outputs PWM3 and PWM4 routed
  -- to GPIO14 and GPIO15.  PWM2 and PWM3 are also multiplexed to GPIO18 and
  -- GPIO19 on a secondary basis.
  --
  -- Unlike Raspberry Pis, the Orange Pi Zero 2W numbers its PWM outputs from
  -- 1.  It two additional PWM outputs PWM3 and PWM4 are routed to GPIO4
  -- and GPIO23 (apparently chosen at random).

  PWM2   : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.PWM3 ELSIF Pi5 THEN RaspberryPi5.PWM2 ELSE (0, 0)); -- Orange Pi Zero 2W Pin 7,  Raspberry Pi Pin 12 aka GPIO18
  PWM3   : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.PWM4 ELSIF Pi5 THEN RaspberryPi5.PWM3 ELSE (0, 1)); -- Orange Pi Zero 2W Pin 16, Raspberry Pi Pin 35 aka GPIO19

  -- The Orange Pi Zero 2W does not have SPI1.

  SPI1_0 : CONSTANT Device.Designator := (IF Orange THEN Device.Unavailable ELSE (1, 0));  -- GPIO18, GPIO19, GPIO20, and GPIO21
  SPI1_1 : CONSTANT Device.Designator := (IF Orange THEN Device.Unavailable ELSE (1, 1));  -- GPIO17, GPIO19, GPIO20, and GPIO21
  SPI1_2 : CONSTANT Device.Designator := (IF Orange THEN Device.Unavailable ELSE (1, 2));  -- GPIO16, GPIO19, GPIO20, and GPIO21

END RaspberryPi;
