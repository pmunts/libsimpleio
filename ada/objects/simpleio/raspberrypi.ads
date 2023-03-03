-- Raspberry Pi Device Definitions

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

PACKAGE RaspberryPi IS

  -- The following analog inputs are only available if the Mikroelektronika
  -- Pi 3 Click Shield (MIKROE-2756) and its device tree overlay are installed

  AIN0   : CONSTANT Device.Designator := (0,  0);  -- 12-bit, 0.0 to 4.096V range
  AIN1   : CONSTANT Device.Designator := (0,  1);  -- 12-bit, 0.0 to 4.096V range

  -- The following GPIO pins are available on all Raspberry Pi Models

  GPIO2  : CONSTANT Device.Designator := (0,  2);  -- I2C1 SDA
  GPIO3  : CONSTANT Device.Designator := (0,  3);  -- I2C1 SCL
  GPIO4  : CONSTANT Device.Designator := (0,  4);
  GPIO7  : CONSTANT Device.Designator := (0,  7);  -- SPI0 SS1
  GPIO8  : CONSTANT Device.Designator := (0,  8);  -- SPI0 SS0
  GPIO9  : CONSTANT Device.Designator := (0,  9);  -- SPI0 MISO
  GPIO10 : CONSTANT Device.Designator := (0, 10);  -- SPI0 MOSI
  GPIO11 : CONSTANT Device.Designator := (0, 11);  -- SPI0 SCLK
  GPIO14 : CONSTANT Device.Designator := (0, 14);  -- UART0 TXD
  GPIO15 : CONSTANT Device.Designator := (0, 15);  -- UART0 RXD
  GPIO17 : CONSTANT Device.Designator := (0, 17);  -- SPI1 SS1
  GPIO18 : CONSTANT Device.Designator := (0, 18);  -- PWM0, SPI1 SS0
  GPIO22 : CONSTANT Device.Designator := (0, 22);
  GPIO23 : CONSTANT Device.Designator := (0, 23);
  GPIO24 : CONSTANT Device.Designator := (0, 24);
  GPIO25 : CONSTANT Device.Designator := (0, 25);
  GPIO27 : CONSTANT Device.Designator := (0, 27);

  -- The following GPIO pins are only available on Raspberry Pi Model
  -- B+ and later, with 40-pin expansion headers

  GPIO5  : CONSTANT Device.Designator := (0,  5);
  GPIO6  : CONSTANT Device.Designator := (0,  6);
  GPIO12 : CONSTANT Device.Designator := (0, 12);  -- PWM0
  GPIO13 : CONSTANT Device.Designator := (0, 13);  -- PWM1
  GPIO16 : CONSTANT Device.Designator := (0, 16);  -- SPI1 SS2
  GPIO19 : CONSTANT Device.Designator := (0, 19);  -- SPI1 MISO, PWM1
  GPIO20 : CONSTANT Device.Designator := (0, 20);  -- SPI1 MOSI
  GPIO21 : CONSTANT Device.Designator := (0, 21);  -- SPI1 SCLK
  GPIO26 : CONSTANT Device.Designator := (0, 26);

  -- All of the following subsystems require the proper device tree overlays

  I2C1   : CONSTANT Device.Designator := (0,  1);  -- GPIO2 and GPIO3
  I2C3   : CONSTANT Device.Designator := (0,  3);  -- Raspberry Pi 4 only
  I2C4   : CONSTANT Device.Designator := (0,  4);  -- Raspberry Pi 4 only
  I2C5   : CONSTANT Device.Designator := (0,  5);  -- Raspberry Pi 4 only
  I2C6   : CONSTANT Device.Designator := (0,  6);  -- Raspberry Pi 4 only

  PWM0   : CONSTANT Device.Designator := (0,  0);  -- GPIO12 or GPIO18
  PWM1   : CONSTANT Device.Designator := (0,  1);  -- GPIO13 or GPIO19

  SPI0_0 : CONSTANT Device.Designator := (0,  0);  -- GPIO8, GPIO9, GPIO10, and GPIO11
  SPI0_1 : CONSTANT Device.Designator := (0,  1);  -- GPIO7, GPIO9, GPIO10, and GPIO11

  SPI1_0 : CONSTANT Device.Designator := (1,  0);  -- GPIO18, GPIO19, GPIO20, and GPIO21
  SPI1_1 : CONSTANT Device.Designator := (1,  1);  -- GPIO17, GPIO19, GPIO20, and GPIO21
  SPI1_2 : CONSTANT Device.Designator := (1,  2);  -- GPIO16, GPIO19, GPIO20, and GPIO21

END RaspberryPi;
