-- Raspberry Pi Device Definitions

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

WITH GPIO.libsimpleio;

PACKAGE RaspberryPi IS

  -- The following GPIO pins are available on all Raspberry Pi Models

  GPIO2  : CONSTANT GPIO.libsimpleio.Designator := (0,  2);  -- I2C1 SDA
  GPIO3  : CONSTANT GPIO.libsimpleio.Designator := (0,  3);  -- I2C1 SCL
  GPIO4  : CONSTANT GPIO.libsimpleio.Designator := (0,  4);
  GPIO7  : CONSTANT GPIO.libsimpleio.Designator := (0,  7);  -- SPI0 SS1
  GPIO8  : CONSTANT GPIO.libsimpleio.Designator := (0,  8);  -- SPI0 SS0
  GPIO9  : CONSTANT GPIO.libsimpleio.Designator := (0,  9);  -- SPI0 MISO
  GPIO10 : CONSTANT GPIO.libsimpleio.Designator := (0, 10);  -- SPI0 MOSI
  GPIO11 : CONSTANT GPIO.libsimpleio.Designator := (0, 11);  -- SPI0 SCLK
  GPIO14 : CONSTANT GPIO.libsimpleio.Designator := (0, 14);  -- UART0 TXD
  GPIO15 : CONSTANT GPIO.libsimpleio.Designator := (0, 15);  -- UART0 RXD
  GPIO17 : CONSTANT GPIO.libsimpleio.Designator := (0, 17);
  GPIO18 : CONSTANT GPIO.libsimpleio.Designator := (0, 18);  -- PWM0
  GPIO22 : CONSTANT GPIO.libsimpleio.Designator := (0, 22);
  GPIO23 : CONSTANT GPIO.libsimpleio.Designator := (0, 23);
  GPIO24 : CONSTANT GPIO.libsimpleio.Designator := (0, 24);
  GPIO25 : CONSTANT GPIO.libsimpleio.Designator := (0, 25);
  GPIO27 : CONSTANT GPIO.libsimpleio.Designator := (0, 27);

  -- The following GPIO pins are only available on Raspberry Pi Model
  -- B+ and later, with 40-pin expansion headers

  GPIO5  : CONSTANT GPIO.libsimpleio.Designator := (0,  5);
  GPIO6  : CONSTANT GPIO.libsimpleio.Designator := (0,  6);
  GPIO12 : CONSTANT GPIO.libsimpleio.Designator := (0, 12);
  GPIO13 : CONSTANT GPIO.libsimpleio.Designator := (0, 13);
  GPIO16 : CONSTANT GPIO.libsimpleio.Designator := (0, 16);  -- SPI1 SS0
  GPIO19 : CONSTANT GPIO.libsimpleio.Designator := (0, 19);  -- SPI1 MISO, PWM1
  GPIO20 : CONSTANT GPIO.libsimpleio.Designator := (0, 20);  -- SPI1 MOSI
  GPIO21 : CONSTANT GPIO.libsimpleio.Designator := (0, 21);  -- SPI1 SCLK
  GPIO26 : CONSTANT GPIO.libsimpleio.Designator := (0, 26);

END RaspberryPi;
