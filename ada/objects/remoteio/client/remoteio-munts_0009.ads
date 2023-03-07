-- Remote I/O Resources available from the MUNTS-0009 USB Grove Adapter

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

PACKAGE RemoteIO.MUNTS_0009 IS

  -- Analog inputs (10 bit resolution)

  AIN0  : CONSTANT RemoteIO.ChannelNumber := 0;  -- J3 pin 1
  AIN1  : CONSTANT RemoteIO.ChannelNumber := 1;  -- J4 pin 1
  AIN2  : CONSTANT RemoteIO.ChannelNumber := 2;  -- J4 pin 2
  AIN3  : CONSTANT RemoteIO.ChannelNumber := 3;  -- J6 pin 1
  AIN4  : CONSTANT RemoteIO.ChannelNumber := 4;  -- J6 pin 2

  -- GPIO pins

  LED   : CONSTANT RemoteIO.ChannelNumber := 0;  -- Output only
  GPIO1 : CONSTANT RemoteIO.ChannelNumber := 1;  -- J3 pin 1, aka AIN0
  GPIO2 : CONSTANT RemoteIO.ChannelNumber := 2;  -- J3 pin 2, Input only
  GPIO3 : CONSTANT RemoteIO.ChannelNumber := 3;  -- J4 pin 1, aka AIN1 SS
  GPIO4 : CONSTANT RemoteIO.ChannelNumber := 4;  -- J4 pin 2, aka AIN2 MOSI
  GPIO5 : CONSTANT RemoteIO.ChannelNumber := 5;  -- J5 pin 1
  GPIO6 : CONSTANT RemoteIO.ChannelNumber := 6;  -- J5 pin 2
  GPIO7 : CONSTANT RemoteIO.ChannelNumber := 7;  -- J6 pin 1, aka AIN3 SCL SCLK
  GPIO8 : CONSTANT RemoteIO.ChannelNumber := 8;  -- J6 pin 2, aka AIN4 SDA MISO

  -- I2C buses

  I2C0  : CONSTANT RemoteIO.ChannelNumber := 0;  -- J6

  -- SPI devices

  SPI0  : CONSTANT RemoteIO.ChannelNumber := 0;  -- J4 and J6

END RemoteIO.MUNTS_0009;
