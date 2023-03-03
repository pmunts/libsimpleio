-- I/O Resources available from a PocketBeagle Remote I/O Server

-- Copyright (C)2018-2023, Philip Munts.
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

PACKAGE RemoteIO.PocketBeagle IS

  -- Analog inputs

  AIN0    : CONSTANT RemoteIO.ChannelNumber :=   0;  -- P1.19 1.8V
  AIN1    : CONSTANT RemoteIO.ChannelNumber :=   1;  -- P1.21 1.8V
  AIN2    : CONSTANT RemoteIO.ChannelNumber :=   2;  -- P1.23 1.8V
  AIN3    : CONSTANT RemoteIO.ChannelNumber :=   3;  -- P1.24 1.8V
  AIN4    : CONSTANT RemoteIO.ChannelNumber :=   4;  -- P1.25 1.8V
  AIN5    : CONSTANT RemoteIO.ChannelNumber :=   5;  -- P2.35 3.6V
  AIN6    : CONSTANT RemoteIO.ChannelNumber :=   6;  -- P1.2  3.6V
  AIN7    : CONSTANT RemoteIO.ChannelNumber :=   7;  -- P2.36 1.8V

  -- Digital GPIO pins

  USERLED : CONSTANT RemoteIO.ChannelNumber :=   0;  -- aka /dev/userled

  GPIO2   : CONSTANT RemoteIO.ChannelNumber :=   2;  -- P1.8   SPI0 SCLK
  GPIO3   : CONSTANT RemoteIO.ChannelNumber :=   3;  -- P1.10  SPI0 MISO
  GPIO4   : CONSTANT RemoteIO.ChannelNumber :=   4;  -- P1.12  SPI0 MOSI
  GPIO5   : CONSTANT RemoteIO.ChannelNumber :=   5;  -- P1.6   SPI0 CS0
  GPIO7   : CONSTANT RemoteIO.ChannelNumber :=   7;  -- P2.29  SPI1 SCLK
  GPIO12  : CONSTANT RemoteIO.ChannelNumber :=  12;  -- P1.26  I2C2 SDA
  GPIO13  : CONSTANT RemoteIO.ChannelNumber :=  13;  -- P1.28  I2C2 SCL
  GPIO14  : CONSTANT RemoteIO.ChannelNumber :=  14;  -- P2.11  I2C1 SDA
  GPIO15  : CONSTANT RemoteIO.ChannelNumber :=  15;  -- P2.9   I2C1 SCL
  GPIO19  : CONSTANT RemoteIO.ChannelNumber :=  19;  -- P2.31  SPI1 CS1
  GPIO20  : CONSTANT RemoteIO.ChannelNumber :=  20;  -- P1.20
  GPIO23  : CONSTANT RemoteIO.ChannelNumber :=  23;  -- P2.3
  GPIO26  : CONSTANT RemoteIO.ChannelNumber :=  26;  -- P1.34
  GPIO27  : CONSTANT RemoteIO.ChannelNumber :=  27;  -- P2.19
  GPIO30  : CONSTANT RemoteIO.ChannelNumber :=  30;  -- P2.5   RXD4
  GPIO31  : CONSTANT RemoteIO.ChannelNumber :=  31;  -- P2.7   TXD4
  GPIO40  : CONSTANT RemoteIO.ChannelNumber :=  40;  -- P2.27  SPI1 MISO
  GPIO41  : CONSTANT RemoteIO.ChannelNumber :=  41;  -- P2.25  SPI1 MOSI
  GPIO42  : CONSTANT RemoteIO.ChannelNumber :=  42;  -- P1.32  RXD0
  GPIO43  : CONSTANT RemoteIO.ChannelNumber :=  43;  -- P1.30  TXD0
  GPIO44  : CONSTANT RemoteIO.ChannelNumber :=  44;  -- P2.24
  GPIO45  : CONSTANT RemoteIO.ChannelNumber :=  45;  -- P2.33
  GPIO46  : CONSTANT RemoteIO.ChannelNumber :=  46;  -- P2.22
  GPIO47  : CONSTANT RemoteIO.ChannelNumber :=  47;  -- P2.18
  GPIO50  : CONSTANT RemoteIO.ChannelNumber :=  50;  -- P2.1   PWM2:0
  GPIO52  : CONSTANT RemoteIO.ChannelNumber :=  52;  -- P2.10
  GPIO57  : CONSTANT RemoteIO.ChannelNumber :=  57;  -- P2.6
  GPIO58  : CONSTANT RemoteIO.ChannelNumber :=  58;  -- P2.4
  GPIO59  : CONSTANT RemoteIO.ChannelNumber :=  59;  -- P2.2
  GPIO60  : CONSTANT RemoteIO.ChannelNumber :=  60;  -- P2.8
  GPIO64  : CONSTANT RemoteIO.ChannelNumber :=  64;  -- P2.20
  GPIO65  : CONSTANT RemoteIO.ChannelNumber :=  65;  -- P2.17
  GPIO86  : CONSTANT RemoteIO.ChannelNumber :=  86;  -- P2.35  AIN5 3.3V
  GPIO87  : CONSTANT RemoteIO.ChannelNumber :=  87;  -- P1.2   AIN6 3.3V
  GPIO88  : CONSTANT RemoteIO.ChannelNumber :=  88;  -- P1.35
  GPIO89  : CONSTANT RemoteIO.ChannelNumber :=  89;  -- P1.4
  GPIO110 : CONSTANT RemoteIO.ChannelNumber := 110;  -- P1.36  PWM0:0
  GPIO111 : CONSTANT RemoteIO.ChannelNumber := 111;  -- P1.33
  GPIO112 : CONSTANT RemoteIO.ChannelNumber := 112;  -- P2.32
  GPIO113 : CONSTANT RemoteIO.ChannelNumber := 113;  -- P2.30
  GPIO114 : CONSTANT RemoteIO.ChannelNumber := 114;  -- P1.31
  GPIO115 : CONSTANT RemoteIO.ChannelNumber := 115;  -- P2.34
  GPIO116 : CONSTANT RemoteIO.ChannelNumber := 116;  -- P2.28
  GPIO117 : CONSTANT RemoteIO.ChannelNumber := 117;  -- P1.29

  -- I2C bus controllers

  I2C1    : CONSTANT RemoteIO.ChannelNumber :=   1;  -- P2.9,11
  I2C2    : CONSTANT RemoteIO.ChannelNumber :=   2;  -- P1.26,28

  -- PWM outputs

  PWM0_0  : CONSTANT RemoteIO.ChannelNumber :=   0;  -- PWM0:0 P1.36
  PWM2_0  : CONSTANT RemoteIO.ChannelNumber :=   1;  -- PWM2:0 P2.1

  -- SPI slave devices

  SPI0_0  : CONSTANT RemoteIO.ChannelNumber :=   0;  -- SPI0 CS0 P1.6,8,10,12
  SPI1_1  : CONSTANT RemoteIO.ChannelNumber :=   1;  -- SPI1 CS1 P2.25,27,29,31

END RemoteIO.PocketBeagle;
