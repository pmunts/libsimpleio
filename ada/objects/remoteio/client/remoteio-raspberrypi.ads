-- I/O Resources available from a Raspberry Pi Remote I/O Server

-- Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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

PACKAGE RemoteIO.RaspberryPi IS

  -- The following analog inputs are only available if a Mikroelektronika
  -- Pi 3 Click Shield (MIKROE-2756) *and* its device tree overlay are
  -- installed

  AIN0    : CONSTANT RemoteIO.ChannelNumber :=  0;
  AIN1    : CONSTANT RemoteIO.ChannelNumber :=  1;

  -- The following GPIO pins are available on all Raspberry Pi Models

  USERLED : CONSTANT RemoteIO.ChannelNumber :=  0;  -- /dev/userled

  GPIO2   : CONSTANT RemoteIO.ChannelNumber :=  2;  -- I2C1 SDA
  GPIO3   : CONSTANT RemoteIO.ChannelNumber :=  3;  -- I2C1 SCL
  GPIO4   : CONSTANT RemoteIO.ChannelNumber :=  4;
  GPIO7   : CONSTANT RemoteIO.ChannelNumber :=  7;  -- SPI0 SS1
  GPIO8   : CONSTANT RemoteIO.ChannelNumber :=  8;  -- SPI0 SS0
  GPIO9   : CONSTANT RemoteIO.ChannelNumber :=  9;  -- SPI0 MISO
  GPIO10  : CONSTANT RemoteIO.ChannelNumber := 10;  -- SPI0 MOSI
  GPIO11  : CONSTANT RemoteIO.ChannelNumber := 11;  -- SPI0 SCLK
  GPIO14  : CONSTANT RemoteIO.ChannelNumber := 14;  -- UART0 TXD
  GPIO15  : CONSTANT RemoteIO.ChannelNumber := 15;  -- UART0 RXD
  GPIO17  : CONSTANT RemoteIO.ChannelNumber := 17;
  GPIO18  : CONSTANT RemoteIO.ChannelNumber := 18;
  GPIO22  : CONSTANT RemoteIO.ChannelNumber := 22;
  GPIO23  : CONSTANT RemoteIO.ChannelNumber := 23;
  GPIO24  : CONSTANT RemoteIO.ChannelNumber := 24;
  GPIO25  : CONSTANT RemoteIO.ChannelNumber := 25;
  GPIO27  : CONSTANT RemoteIO.ChannelNumber := 27;

  -- The following GPIO pins are only available on Raspberry Pi Model
  -- B+ and later, with 40-pin expansion headers

  GPIO5   : CONSTANT RemoteIO.ChannelNumber :=  5;
  GPIO6   : CONSTANT RemoteIO.ChannelNumber :=  6;
  GPIO12  : CONSTANT RemoteIO.ChannelNumber := 12;
  GPIO13  : CONSTANT RemoteIO.ChannelNumber := 13;
  GPIO16  : CONSTANT RemoteIO.ChannelNumber := 16;  -- SPI1 SS0
  GPIO19  : CONSTANT RemoteIO.ChannelNumber := 19;  -- SPI1 MISO, PWM1
  GPIO20  : CONSTANT RemoteIO.ChannelNumber := 20;  -- SPI1 MOSI
  GPIO21  : CONSTANT RemoteIO.ChannelNumber := 21;  -- SPI1 SCLK
  GPIO26  : CONSTANT RemoteIO.ChannelNumber := 26;

  -- I2C bus controllers

  I2C1    : CONSTANT RemoteIO.ChannelNumber :=  0;  -- GPIO2 and GPIO3

  -- PWM outputs -- require device tree overlay

  PWM0    : CONSTANT RemoteIO.ChannelNumber := 0;   -- GPIO18
  PWM1    : CONSTANT RemoteIO.ChannelNumber := 1;   -- GPIO19

  -- SPI slave devices

  SPI0    : CONSTANT RemoteIO.ChannelNumber :=  0;  -- SPI0_0 aka GPIO8
  SPI1    : CONSTANT RemoteIO.ChannelNumber :=  1;  -- SPI0_1 aka GPIO7
  SPI2    : CONSTANT RemoteIO.ChannelNumber :=  2;  -- SPI1_0 aka GPIO18
  SPI3    : CONSTANT RemoteIO.ChannelNumber :=  3;  -- SPI1_1 aka GPIO17
  SPI4    : CONSTANT RemoteIO.ChannelNumber :=  4;  -- SPI1_2 aka GPIO16

END RemoteIO.RaspberryPi;
