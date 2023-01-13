-- I/O Resources available from a BeagleBone Remote I/O Server

-- Copyright (C)2023, Philip Munts, President, Munts AM Corp.
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

-- NOTE: Not every I/O resource listed below will be available for Remote I/O!
-- e.g. GPIO32, dedicated to MMC1 DAT0 on Beagle Black and Green boards.

PACKAGE RemoteIO.BeagleBone IS

  -- Analog inputs

  AIN0     : CONSTANT RemoteIO.ChannelNumber :=   0;  -- P9.39 1.8V
  AIN1     : CONSTANT RemoteIO.ChannelNumber :=   1;  -- P9.40 1.8V
  AIN2     : CONSTANT RemoteIO.ChannelNumber :=   2;  -- P9.37 1.8V
  AIN3     : CONSTANT RemoteIO.ChannelNumber :=   3;  -- P9.38 1.8V
  AIN4     : CONSTANT RemoteIO.ChannelNumber :=   4;  -- P9.33 1.8V
  AIN5     : CONSTANT RemoteIO.ChannelNumber :=   5;  -- P9.36 1.8V
  AIN6     : CONSTANT RemoteIO.ChannelNumber :=   6;  -- P9.35 1.8V

  -- Digital GPIO pins

  USERLED  : CONSTANT RemoteIO.ChannelNumber :=   0;  -- aka /dev/userled

  GPIO2    : CONSTANT RemoteIO.ChannelNumber :=   2;  -- P9.22  SPI0 SCK  UART2 RXD EHRPWM0B
  GPIO3    : CONSTANT RemoteIO.ChannelNumber :=   3;  -- P9.21  SPI0 MISO UART2 TXD
  GPIO4    : CONSTANT RemoteIO.ChannelNumber :=   4;  -- P9.18  SPI0 MOSI
  GPIO5    : CONSTANT RemoteIO.ChannelNumber :=   5;  -- P9.17  SPI0 SS0
  GPIO7    : CONSTANT RemoteIO.ChannelNumber :=   7;  -- P9.42  SPI1 SS1
  GPIO8    : CONSTANT RemoteIO.ChannelNumber :=   8;  -- P8.35
  GPIO9    : CONSTANT RemoteIO.ChannelNumber :=   9;  -- P8.33
  GPIO10   : CONSTANT RemoteIO.ChannelNumber :=  10;  -- P8.31
  GPIO11   : CONSTANT RemoteIO.ChannelNumber :=  11;  -- P8.32
  GPIO12   : CONSTANT RemoteIO.ChannelNumber :=  12;  -- P9.20  I2C2 SDA
  GPIO13   : CONSTANT RemoteIO.ChannelNumber :=  13;  -- P9.19  I2C2 SCL
  GPIO14   : CONSTANT RemoteIO.ChannelNumber :=  14;  -- P9.26  UART1 RXD
  GPIO15   : CONSTANT RemoteIO.ChannelNumber :=  15;  -- P9.24  UART1 TXD
  GPIO20   : CONSTANT RemoteIO.ChannelNumber :=  20;  -- P9.41
  GPIO22   : CONSTANT RemoteIO.ChannelNumber :=  22;  -- P8.19  EHRPWM2A
  GPIO23   : CONSTANT RemoteIO.ChannelNumber :=  23;  -- P8.13  EHRPWM2B
  GPIO26   : CONSTANT RemoteIO.ChannelNumber :=  26;  -- P8.14
  GPIO27   : CONSTANT RemoteIO.ChannelNumber :=  27;  -- P8.17
  GPIO30   : CONSTANT RemoteIO.ChannelNumber :=  30;  -- P9.11  UART4 RXD
  GPIO31   : CONSTANT RemoteIO.ChannelNumber :=  31;  -- P9.13  UART4 TXD
  GPIO32   : CONSTANT RemoteIO.ChannelNumber :=  32;  -- P8.25  MMC1 DAT0
  GPIO33   : CONSTANT RemoteIO.ChannelNumber :=  33;  -- P8.24  MMC1 DAT1
  GPIO34   : CONSTANT RemoteIO.ChannelNumber :=  34;  -- P8.5   MMC1 DAT2
  GPIO35   : CONSTANT RemoteIO.ChannelNumber :=  35;  -- P8.6   MMC1 DAT3
  GPIO36   : CONSTANT RemoteIO.ChannelNumber :=  36;  -- P8.23  MMC1 DAT4
  GPIO37   : CONSTANT RemoteIO.ChannelNumber :=  37;  -- P8.22  MMC1 DAT5
  GPIO38   : CONSTANT RemoteIO.ChannelNumber :=  38;  -- P8.3   MMC1 DAT6
  GPIO39   : CONSTANT RemoteIO.ChannelNumber :=  39;  -- P8.4   MMC1 DAT7
  GPIO44   : CONSTANT RemoteIO.ChannelNumber :=  44;  -- P8.12
  GPIO45   : CONSTANT RemoteIO.ChannelNumber :=  45;  -- P8.11
  GPIO46   : CONSTANT RemoteIO.ChannelNumber :=  46;  -- P8.16
  GPIO47   : CONSTANT RemoteIO.ChannelNumber :=  47;  -- P8.15
  GPIO48   : CONSTANT RemoteIO.ChannelNumber :=  48;  -- P9.15
  GPIO49   : CONSTANT RemoteIO.ChannelNumber :=  49;  -- P9.23
  GPIO50   : CONSTANT RemoteIO.ChannelNumber :=  50;  -- P9.14  EHRPWM1A
  GPIO51   : CONSTANT RemoteIO.ChannelNumber :=  51;  -- P9.16  EHRPWM1B
  GPIO60   : CONSTANT RemoteIO.ChannelNumber :=  60;  -- P9.12
  GPIO61   : CONSTANT RemoteIO.ChannelNumber :=  61;  -- P8.26
  GPIO62   : CONSTANT RemoteIO.ChannelNumber :=  62;  -- P8.21  MMC1 CLK
  GPIO63   : CONSTANT RemoteIO.ChannelNumber :=  63;  -- P8.20  MMC1 CMD
  GPIO65   : CONSTANT RemoteIO.ChannelNumber :=  65;  -- P8.18
  GPIO66   : CONSTANT RemoteIO.ChannelNumber :=  66;  -- P8.7
  GPIO67   : CONSTANT RemoteIO.ChannelNumber :=  67;  -- P8.8
  GPIO68   : CONSTANT RemoteIO.ChannelNumber :=  68;  -- P8.10
  GPIO69   : CONSTANT RemoteIO.ChannelNumber :=  69;  -- P8.9
  GPIO70   : CONSTANT RemoteIO.ChannelNumber :=  70;  -- P8.45  EHRPWM2A
  GPIO71   : CONSTANT RemoteIO.ChannelNumber :=  71;  -- P8.46  EHRPWM2B
  GPIO72   : CONSTANT RemoteIO.ChannelNumber :=  72;  -- P8.43
  GPIO73   : CONSTANT RemoteIO.ChannelNumber :=  73;  -- P8.44
  GPIO74   : CONSTANT RemoteIO.ChannelNumber :=  74;  -- P8.41
  GPIO75   : CONSTANT RemoteIO.ChannelNumber :=  75;  -- P8.42
  GPIO76   : CONSTANT RemoteIO.ChannelNumber :=  76;  -- P8.39
  GPIO77   : CONSTANT RemoteIO.ChannelNumber :=  77;  -- P8.40
  GPIO78   : CONSTANT RemoteIO.ChannelNumber :=  78;  -- P8.37  UART5 TXD
  GPIO79   : CONSTANT RemoteIO.ChannelNumber :=  79;  -- P8.38  UART5 RXD
  GPIO80   : CONSTANT RemoteIO.ChannelNumber :=  80;  -- P8.36  EHRPWM1A
  GPIO81   : CONSTANT RemoteIO.ChannelNumber :=  81;  -- P8.34  EHRPWM1B
  GPIO86   : CONSTANT RemoteIO.ChannelNumber :=  86;  -- P8.27
  GPIO87   : CONSTANT RemoteIO.ChannelNumber :=  87;  -- P8.29
  GPIO88   : CONSTANT RemoteIO.ChannelNumber :=  88;  -- P8.28
  GPIO89   : CONSTANT RemoteIO.ChannelNumber :=  89;  -- P8.30
  GPIO110  : CONSTANT RemoteIO.ChannelNumber := 110;  -- P9.31  SPI1 SCLK EHRPWM0A
  GPIO111  : CONSTANT RemoteIO.ChannelNumber := 111;  -- P9.29  SPI1 MISO
  GPIO112  : CONSTANT RemoteIO.ChannelNumber := 112;  -- P9.30  SPI1 MOSI
  GPIO113  : CONSTANT RemoteIO.ChannelNumber := 113;  -- P9.28  SPI1 SS0
  GPIO115  : CONSTANT RemoteIO.ChannelNumber := 115;  -- P9.27
  GPIO117  : CONSTANT RemoteIO.ChannelNumber := 117;  -- P9.25

  -- I2C bus controllers

  I2C2     : CONSTANT RemoteIO.ChannelNumber :=   0;  -- P9.19 and P9.20;

  -- PWM outputs

  EHRPWM1A : CONSTANT RemoteIO.ChannelNumber :=   0;  -- P8.36 or P9.14
  EHRPWM1B : CONSTANT RemoteIO.ChannelNumber :=   1;  -- P8.34 or P9.16
  EHRPWM2A : CONSTANT RemoteIO.ChannelNumber :=   2;  -- P8.19 or P8.45
  EHRPWM2B : CONSTANT RemoteIO.ChannelNumber :=   3;  -- P8.13 or P8.46

  -- SPI slave devices

  SPI1_0   : CONSTANT RemoteIO.ChannelNumber :=   0;  -- P9.28
  SPI1_1   : CONSTANT RemoteIO.ChannelNumber :=   1;  -- P9.42
  SPI0_0   : CONSTANT RemoteIO.ChannelNumber :=   2;  -- P9.17

END RemoteIO.BeagleBone;
