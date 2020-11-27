-- Remote I/O Resources available from a USB Grove Adapter
-- (MUNTS-0008 or MUNTS-0009)

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

PACKAGE RemoteIO.USB_Grove_Adapter IS

  -- Analog inputs (10 bit resolution)

  AIN0  : CONSTANT RemoteIO.ChannelNumber := 0;
  AIN1  : CONSTANT RemoteIO.ChannelNumber := 1;
  AIN2  : CONSTANT RemoteIO.ChannelNumber := 2;
  AIN3  : CONSTANT RemoteIO.ChannelNumber := 3;
  AIN4  : CONSTANT RemoteIO.ChannelNumber := 4;

  -- GPIO pins

  GPIO0 : CONSTANT RemoteIO.ChannelNumber := 0;  -- aka LED
  GPIO1 : CONSTANT RemoteIO.ChannelNumber := 1;  -- aka AIN0
  GPIO2 : CONSTANT RemoteIO.ChannelNumber := 2;
  GPIO3 : CONSTANT RemoteIO.ChannelNumber := 3;  -- aka AIN1 aka SS
  GPIO4 : CONSTANT RemoteIO.ChannelNumber := 4;  -- aka AIN2 aka MOSI
  GPIO5 : CONSTANT RemoteIO.ChannelNumber := 5;
  GPIO6 : CONSTANT RemoteIO.ChannelNumber := 6;
  GPIO7 : CONSTANT RemoteIO.ChannelNumber := 7;  -- aka AIN3 aka SCL aka SCLK
  GPIO8 : CONSTANT RemoteIO.ChannelNumber := 8;  -- aka AIN4 aka SDA aka MISO
  LED   : CONSTANT RemoteIO.ChannelNumber := GPIO0;

  -- I2C buses

  I2C0  : CONSTANT RemoteIO.ChannelNumber := 0;

  -- SPI devices

  SPI0  : CONSTANT RemoteIO.ChannelNumber := 0;

END RemoteIO.USB_Grove_Adapter;
