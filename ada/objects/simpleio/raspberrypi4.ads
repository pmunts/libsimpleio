-- Raspberry Pi 4 Device Definitions

-- Copyright (C)2024, Philip Munts dba Munts Technologies.
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

PACKAGE RaspberryPi4 IS

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

  GPIO2  : CONSTANT Device.Designator := (0,  2);  -- I2C1 SDA
  GPIO3  : CONSTANT Device.Designator := (0,  3);  -- I2C1 SCL
  GPIO4  : CONSTANT Device.Designator := (0,  4);
  GPIO5  : CONSTANT Device.Designator := (0,  5);
  GPIO6  : CONSTANT Device.Designator := (0,  6);
  GPIO7  : CONSTANT Device.Designator := (0,  7);  -- SPI0 SS1
  GPIO8  : CONSTANT Device.Designator := (0,  8);  -- SPI0 SS0
  GPIO9  : CONSTANT Device.Designator := (0,  9);  -- SPI0 MISO
  GPIO10 : CONSTANT Device.Designator := (0, 10);  -- SPI0 MOSI
  GPIO11 : CONSTANT Device.Designator := (0, 11);  -- SPI0 SCLK
  GPIO12 : CONSTANT Device.Designator := (0, 12);  -- PWM0
  GPIO13 : CONSTANT Device.Designator := (0, 13);  -- PWM1
  GPIO14 : CONSTANT Device.Designator := (0, 14);  -- UART0 TXD
  GPIO15 : CONSTANT Device.Designator := (0, 15);  -- UART0 RXD
  GPIO16 : CONSTANT Device.Designator := (0, 16);  -- SPI1 SS2
  GPIO17 : CONSTANT Device.Designator := (0, 17);  -- SPI1 SS1
  GPIO18 : CONSTANT Device.Designator := (0, 18);  -- PWM0, SPI1 SS0
  GPIO19 : CONSTANT Device.Designator := (0, 19);  -- PWM1, SPI1 MISO
  GPIO20 : CONSTANT Device.Designator := (0, 20);  -- SPI1 MOSI
  GPIO21 : CONSTANT Device.Designator := (0, 21);  -- SPI1 SCLK
  GPIO22 : CONSTANT Device.Designator := (0, 22);
  GPIO23 : CONSTANT Device.Designator := (0, 23);
  GPIO24 : CONSTANT Device.Designator := (0, 24);
  GPIO25 : CONSTANT Device.Designator := (0, 25);
  GPIO26 : CONSTANT Device.Designator := (0, 26);
  GPIO27 : CONSTANT Device.Designator := (0, 27);

  -- All of the following subsystems require device tree overlays

  I2C1   : CONSTANT Device.Designator := (0,  1);  -- GPIO2/GPIO3

  -- The Raspberry Pi 4 has additional I2C bus controllers, which can be
  -- enabled by device tree overlays i2c3, i2c4, i2c5, or i2c6.

  I2C3   : CONSTANT Device.Designator := (0,  3);  -- GPIO2/GPIO3   or GPIO4/GPIO5
  I2C4   : CONSTANT Device.Designator := (0,  4);  -- GPIO6/GPIO7   or GPIO8/GPIO9
  I2C5   : CONSTANT Device.Designator := (0,  5);  -- GPIO10/GPIO11 or GPIO12/GPIO13
  I2C6   : CONSTANT Device.Designator := (0,  6);  -- GPIO0/GPIO1   or GPIO22/GPIO23

  PWM0   : CONSTANT Device.Designator := (0,  0);  -- GPIO12 or GPIO18
  PWM1   : CONSTANT Device.Designator := (0,  1);  -- GPIO13 or GPIO19

  SPI0_0 : CONSTANT Device.Designator := (0,  0);  -- GPIO8,  GPIO9,  GPIO10, and GPIO11
  SPI0_1 : CONSTANT Device.Designator := (0,  1);  -- GPIO7,  GPIO9,  GPIO10, and GPIO11
  SPI1_0 : CONSTANT Device.Designator := (1,  0);  -- GPIO18, GPIO19, GPIO20, and GPIO21
  SPI1_1 : CONSTANT Device.Designator := (1,  1);  -- GPIO17, GPIO19, GPIO20, and GPIO21
  SPI1_2 : CONSTANT Device.Designator := (1,  2);  -- GPIO16, GPIO19, GPIO20, and GPIO21

END RaspberryPi4;
