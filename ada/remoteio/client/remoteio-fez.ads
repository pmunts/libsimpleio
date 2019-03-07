-- Remote I/O Resources available from a GHI Electronics FEZ board
-- running MUNTS-0012 firmware

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

PACKAGE RemoteIO.FEZ IS

  -- Analog inputs

  ADC0 : CONSTANT RemoteIO.ChannelNumber := 0;  -- aka PA4
  ADC1 : CONSTANT RemoteIO.ChannelNumber := 1;  -- aka PA5
  ADC2 : CONSTANT RemoteIO.ChannelNumber := 2;  -- aka PA6
  ADC3 : CONSTANT RemoteIO.ChannelNumber := 3;  -- aka PA7
  ADC4 : CONSTANT RemoteIO.ChannelNumber := 4;  -- aka PB0
  ADC5 : CONSTANT RemoteIO.ChannelNumber := 5;  -- aka PB1

  -- GPIO pins

  D0   : CONSTANT RemoteIO.ChannelNumber := 0;   -- aka PA10
  D1   : CONSTANT RemoteIO.ChannelNumber := 1;   -- aka PA9
  D2   : CONSTANT RemoteIO.ChannelNumber := 2;   -- aka PC1
  D3   : CONSTANT RemoteIO.ChannelNumber := 3;   -- aka PA8 aka PWM0
  D4   : CONSTANT RemoteIO.ChannelNumber := 4;   -- aka PC15
  D5   : CONSTANT RemoteIO.ChannelNumber := 5;   -- aka PB8 aka PWM1
  D6   : CONSTANT RemoteIO.ChannelNumber := 6;   -- aka PC6 aka PWM2
  D7   : CONSTANT RemoteIO.ChannelNumber := 7;   -- aka PC14
  D8   : CONSTANT RemoteIO.ChannelNumber := 8;   -- aka PC0
  D9   : CONSTANT RemoteIO.ChannelNumber := 9;   -- aka PC9 aka PWM3 aka SS1
  D10  : CONSTANT RemoteIO.ChannelNumber := 10;  -- aka PC8 aka PWM4 aka SS0
  D11  : CONSTANT RemoteIO.ChannelNumber := 11;  -- aka PB5 aka PWM5 aka MOSI
  D12  : CONSTANT RemoteIO.ChannelNumber := 12;  -- aka PB4 aka MISO
  D13  : CONSTANT RemoteIO.ChannelNumber := 13;  -- aka PB3 aka SCLK

  A0   : CONSTANT RemoteIO.ChannelNumber := 14;  -- aka PA4 aka ADC0
  A1   : CONSTANT RemoteIO.ChannelNumber := 15;  -- aka PA5 aka ADC1
  A2   : CONSTANT RemoteIO.ChannelNumber := 16;  -- aka PA6 aka ADC2
  A3   : CONSTANT RemoteIO.ChannelNumber := 17;  -- aka PA7 aka ADC3
  A4   : CONSTANT RemoteIO.ChannelNumber := 18;  -- aka PB0 aka ADC4
  A5   : CONSTANT RemoteIO.ChannelNumber := 19;  -- aka PB1 aka ADC5

  LED1 : CONSTANT RemoteIO.ChannelNumber := 20;  -- aka PB9
  LED2 : CONSTANT RemoteIO.ChannelNumber := 21;  -- aka PC10
  BTN1 : CONSTANT RemoteIO.ChannelNumber := 22;  -- aka PA15
  BTN2 : CONSTANT RemoteIO.ChannelNumber := 23;  -- aka PC13

  -- PWM outputs

  PWM0 : CONSTANT RemoteIO.ChannelNumber := 0;   -- aka PA8
  PWM1 : CONSTANT RemoteIO.ChannelNumber := 1;   -- aka PB8
  PWM2 : CONSTANT RemoteIO.ChannelNumber := 2;   -- aka PC6
  PWM3 : CONSTANT RemoteIO.ChannelNumber := 3;   -- aka PC9
  PWM4 : CONSTANT RemoteIO.ChannelNumber := 4;   -- aka PC8
  PWM5 : CONSTANT RemoteIO.ChannelNumber := 5;   -- aka PB5

  -- I2C buses

  I2C0 : CONSTANT RemoteIO.ChannelNumber := 0;

  -- SPI devices

  SPI0 : CONSTANT RemoteIO.ChannelNumber := 0;
  SPI1 : CONSTANT RemoteIO.ChannelNumber := 1;

END RemoteIO.FEZ;
