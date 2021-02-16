-- Remote I/O Resources available from the MUNTS-0015 USB Flexible I/O Adapter

-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

-- NOTE: The MUNTS-0015 USB Flexible I/O Adapter is available for purchase at:
--
-- https://www.tindie.com/products/pmunts/usb-flexible-io-adapter

PACKAGE RemoteIO.MUNTS_0015 IS

  -- Analog inputs (10 bit resolution)

  AIN0  : CONSTANT RemoteIO.ChannelNumber := 0;
  AIN1  : CONSTANT RemoteIO.ChannelNumber := 1;
  AIN2  : CONSTANT RemoteIO.ChannelNumber := 2;
  AIN3  : CONSTANT RemoteIO.ChannelNumber := 3;
  AIN4  : CONSTANT RemoteIO.ChannelNumber := 4;

  -- GPIO pins

  GPIO0 : CONSTANT RemoteIO.ChannelNumber := 0;  -- aka G0
  GPIO1 : CONSTANT RemoteIO.ChannelNumber := 1;  -- aka G1 aka AIN0
  GPIO2 : CONSTANT RemoteIO.ChannelNumber := 2;  -- aka G2 aka AIN1 aka SS
  GPIO3 : CONSTANT RemoteIO.ChannelNumber := 3;  -- aka G3 aka AIN2 aka MOSI
  GPIO4 : CONSTANT RemoteIO.ChannelNumber := 4;  -- aka TX
  GPIO5 : CONSTANT RemoteIO.ChannelNumber := 5;  -- aka RX
  GPIO6 : CONSTANT RemoteIO.ChannelNumber := 6;  -- aka SDA aka AIN3 aka MISO
  GPIO7 : CONSTANT RemoteIO.ChannelNumber := 7;  -- aka SCL aka AIN4 aka SCLK

  -- GPIO pin aliases (as labeled on the PCB)

  G0    : CONSTANT RemoteIO.ChannelNUmber := GPIO0;
  G1    : CONSTANT RemoteIO.ChannelNUmber := GPIO1;
  G2    : CONSTANT RemoteIO.ChannelNUmber := GPIO2;
  G3    : CONSTANT RemoteIO.ChannelNUmber := GPIO3;
  TX    : CONSTANT RemoteIO.ChannelNUmber := GPIO4;
  RX    : CONSTANT RemoteIO.ChannelNUmber := GPIO5;
  SDA   : CONSTANT RemoteIO.ChannelNUmber := GPIO6;
  SCL   : CONSTANT RemoteIO.ChannelNUmber := GPIO7;

  -- I2C buses

  I2C0  : CONSTANT RemoteIO.ChannelNumber := 0;

  -- SPI devices

  SPI0  : CONSTANT RemoteIO.ChannelNumber := 0;

END RemoteIO.MUNTS_0015;
