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
WITH libLinux;
WITH OrangePiZero2W;

PACKAGE RaspberryPi IS
  
  Orange : CONSTANT Boolean := (libLinux.ModelName = OrangePiZero2W.ModelName);

  -- Raspberry Pi boards don't have a built-in ADC (Analog to Digital
  -- Converter) subsystem, so the following analog input designators are
  -- placeholders for the first IIO (Industrial I/O) ADC device.

  AIN0   : CONSTANT Device.Designator := (0,  0);
  AIN1   : CONSTANT Device.Designator := (0,  1);
  AIN2   : CONSTANT Device.Designator := (0,  2);
  AIN3   : CONSTANT Device.Designator := (0,  3);
  AIN4   : CONSTANT Device.Designator := (0,  4);
  AIN5   : CONSTANT Device.Designator := (0,  5);
  AIN6   : CONSTANT Device.Designator := (0,  6);
  AIN7   : CONSTANT Device.Designator := (0,  7);

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

  I2C1   : CONSTANT Device.Designator := (0,  1);  -- GPIO2/GPIO3

  PWM0   : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.PWM1   ELSE (0,  0));  -- GPIO12 or GPIO18
  PWM1   : CONSTANT Device.Designator := (IF Orange THEN OrangePiZero2W.PWM2   ELSE (0,  1));  -- GPIO13 or GPIO19

  SPI0_0 : CONSTANT Device.Designator := (0,  0);  -- GPIO8,  GPIO9,  GPIO10, and GPIO11
  SPI0_1 : CONSTANT Device.Designator := (0,  1);  -- GPIO7,  GPIO9,  GPIO10, and GPIO11
  SPI1_0 : CONSTANT Device.Designator := (1,  0);  -- GPIO18, GPIO19, GPIO20, and GPIO21
  SPI1_1 : CONSTANT Device.Designator := (1,  1);  -- GPIO17, GPIO19, GPIO20, and GPIO21
  SPI1_2 : CONSTANT Device.Designator := (1,  2);  -- GPIO16, GPIO19, GPIO20, and GPIO21

  -- Raspberry Pi CPU generations

  TYPE CPUs IS
   (BCM2708,  -- Raspberry Pi 1
    BCM2709,  -- Raspberry Pi 2
    BCM2710,  -- Raspberry Pi 3
    BCM2711,  -- Raspberry Pi 4
    BCM2712,  -- Raspberry Pi 5
    H618,     -- Orange Pi Zero 2W
    UNKNOWN);

  -- CPU synonyms

  BCM2835   : CONSTANT CPUs := BCM2708; -- Raspberry Pi 1
  BCM2836   : CONSTANT CPUs := BCM2709; -- Raspberry Pi 2
  BCM2837   : CONSTANT CPUs := BCM2710; -- Raspberry Pi 3
  BCM2837B0 : CONSTANT CPUs := BCM2710; -- Raspberry Pi 3+
  RP3A0     : CONSTANT CPUs := BCM2710; -- Raspberry Pi Zero 2 W

  -- Detect the CPU generation

  FUNCTION GetCPU RETURN CPUs;

END RaspberryPi;
