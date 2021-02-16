-- I/O Resources available from an Arduino compatible Remote I/O server

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

-- The following I/O resource definitions are for the Arduino Uno Rev 3 and
-- compatible boards such as those in ST Microelectronics Nucleo-64 family.
-- Not all boards will necessarily provide all of the following I/O resources.

PACKAGE RemoteIO.Arduino IS

  -- Analog inputs

  AIN0  : CONSTANT RemoteIO.ChannelNumber := 0;
  AIN1  : CONSTANT RemoteIO.ChannelNumber := 1;
  AIN2  : CONSTANT RemoteIO.ChannelNumber := 2;
  AIN3  : CONSTANT RemoteIO.ChannelNumber := 3;
  AIN4  : CONSTANT RemoteIO.ChannelNumber := 4;
  AIN5  : CONSTANT RemoteIO.ChannelNumber := 5;

  -- Digital I/O pins

  D0    : CONSTANT RemoteIO.ChannelNumber := 0;  -- aka RXD
  D1    : CONSTANT RemoteIO.ChannelNumber := 1;  -- aka TXD
  D2    : CONSTANT RemoteIO.ChannelNumber := 2;
  D3    : CONSTANT RemoteIO.ChannelNumber := 3;
  D4    : CONSTANT RemoteIO.ChannelNumber := 4;
  D5    : CONSTANT RemoteIO.ChannelNumber := 5;
  D6    : CONSTANT RemoteIO.ChannelNumber := 6;
  D7    : CONSTANT RemoteIO.ChannelNumber := 7;
  D8    : CONSTANT RemoteIO.ChannelNumber := 8;
  D9    : CONSTANT RemoteIO.ChannelNumber := 9;  -- aka SPI SS1
  D10   : CONSTANT RemoteIO.ChannelNumber := 10; -- aka SPI SS0
  D11   : CONSTANT RemoteIO.ChannelNumber := 11; -- aka SPI MOSI
  D12   : CONSTANT RemoteIO.ChannelNumber := 12; -- aka SPI MISO
  D13   : CONSTANT RemoteIO.ChannelNumber := 13; -- aka SPI SCK
  A0    : CONSTANT RemoteIO.ChannelNumber := 14; -- aka AIN0
  A1    : CONSTANT RemoteIO.ChannelNumber := 15; -- aka AIN1
  A2    : CONSTANT RemoteIO.ChannelNumber := 16; -- aka AIN2
  A3    : CONSTANT RemoteIO.ChannelNumber := 17; -- aka AIN3
  A4    : CONSTANT RemoteIO.ChannelNumber := 18; -- aka AIN4, I2C SDA
  A5    : CONSTANT RemoteIO.ChannelNumber := 19; -- aka AIN5, I2C SCL

  -- I2C bus controllers

  I2C0  : CONSTANT RemoteIO.ChannelNumber := 0;

  -- SPI slave devices

  SPI0  : CONSTANT RemoteIO.ChannelNumber := 0;
  SPI1  : CONSTANT RemoteIO.ChannelNumber := 1;

END RemoteIO.Arduino;
