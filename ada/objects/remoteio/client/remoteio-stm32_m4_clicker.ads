-- Remote I/O Resources available from a Mikroelektronika STM32 M4 Clicker
-- board running MUNTS-0011 firmware

-- Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

PACKAGE RemoteIO.STM32_M4_Clicker IS

  -- Analog inputs

  AIN0 : CONSTANT RemoteIO.ChannelNumber := 0;     -- aka AN
  AIN1 : CONSTANT RemoteIO.ChannelNumber := 1;     -- aka HD2_6
  AIN2 : CONSTANT RemoteIO.ChannelNumber := 2;     -- aka HD2_5
  AIN3 : CONSTANT RemoteIO.ChannelNumber := 3;     -- aka HD2_4
  AIN4 : CONSTANT RemoteIO.ChannelNumber := 4;     -- aka HD2_3

  -- GPIO pins

  LED1   : CONSTANT RemoteIO.ChannelNumber := 0;   -- aka PA1
  BTN1   : CONSTANT RemoteIO.ChannelNumber := 1;   -- aka PC0
  LED2   : CONSTANT RemoteIO.ChannelNumber := 2;   -- aka PA2
  BTN2   : CONSTANT RemoteIO.ChannelNumber := 3;   -- aka PC1

  HD2_10 : CONSTANT RemoteIO.ChannelNumber := 4;   -- aka PB6
  HD2_9  : CONSTANT RemoteIO.ChannelNumber := 5;   -- aka PB7
  HD2_8  : CONSTANT RemoteIO.ChannelNumber := 6;   -- aka PB8
  HD2_7  : CONSTANT RemoteIO.ChannelNumber := 7;   -- aka PB9
  HD2_6  : CONSTANT RemoteIO.ChannelNumber := 8;   -- aka PA7
  HD2_5  : CONSTANT RemoteIO.ChannelNumber := 9;   -- aka PA6
  HD2_4  : CONSTANT RemoteIO.ChannelNumber := 10;  -- aka PA5
  HD2_3  : CONSTANT RemoteIO.ChannelNumber := 11;  -- aka PA4

  AN     : CONSTANT RemoteIO.ChannelNumber := 12;  -- aka PA0
  RST    : CONSTANT RemoteIO.ChannelNumber := 13;  -- aka PB5
  CS     : CONSTANT RemoteIO.ChannelNumber := 14;  -- aka PB12
  SCK    : CONSTANT RemoteIO.ChannelNumber := 15;  -- aka PB13
  MISO   : CONSTANT RemoteIO.ChannelNumber := 16;  -- aka PB14
  MOSI   : CONSTANT RemoteIO.ChannelNumber := 17;  -- aka PB15

  PWM    : CONSTANT RemoteIO.ChannelNumber := 18;  -- aka PB0
  INT    : CONSTANT RemoteIO.ChannelNumber := 19;  -- aka PB1
  RX     : CONSTANT RemoteIO.ChannelNumber := 20;  -- aka PC11
  TX     : CONSTANT RemoteIO.ChannelNumber := 21;  -- aka PC10
  SCL    : CONSTANT RemoteIO.ChannelNumber := 22;  -- aka PB10
  SDA    : CONSTANT RemoteIO.ChannelNumber := 23;  -- aka BP11

  GPIO0  : CONSTANT RemoteIO.ChannelNumber := LED1;
  GPIO1  : CONSTANT RemoteIO.ChannelNumber := BTN1;
  GPIO2  : CONSTANT RemoteIO.ChannelNumber := LED2;
  GPIO3  : CONSTANT RemoteIO.ChannelNumber := BTN2;
  GPIO4  : CONSTANT RemoteIO.ChannelNumber := HD2_10;
  GPIO5  : CONSTANT RemoteIO.ChannelNumber := HD2_9;
  GPIO6  : CONSTANT RemoteIO.ChannelNumber := HD2_8;
  GPIO7  : CONSTANT RemoteIO.ChannelNumber := HD2_7;
  GPIO8  : CONSTANT RemoteIO.ChannelNumber := HD2_6;
  GPIO9  : CONSTANT RemoteIO.ChannelNumber := HD2_5;
  GPIO10 : CONSTANT RemoteIO.ChannelNumber := HD2_4;
  GPIO11 : CONSTANT RemoteIO.ChannelNumber := HD2_3;

  -- I2C buses

  I2C0 : CONSTANT RemoteIO.ChannelNumber := 0;

  -- SPI devices

  SPI0 : CONSTANT RemoteIO.ChannelNumber := 0;

END RemoteIO.STM32_M4_Clicker;
