-- I/O Resources available from a BeaglePlay Remote I/O Server

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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

PACKAGE RemoteIO.BeaglePlay IS

  LED_USR0     : CONSTANT RemoteIO.ChannelNumber :=  0;
  LED_USR1     : CONSTANT RemoteIO.ChannelNumber :=  1;
  LED_USR2     : CONSTANT RemoteIO.ChannelNumber :=  2;
  LED_USR3     : CONSTANT RemoteIO.ChannelNumber :=  3;
  LED_USR4     : CONSTANT RemoteIO.ChannelNumber :=  4;

  USER_BUTTON  : CONSTANT RemoteIO.ChannelNumber :=  5;

  AN           : CONSTANT RemoteIO.ChannelNumber :=  6;
  RST          : CONSTANT RemoteIO.ChannelNumber :=  7;
  CS           : CONSTANT RemoteIO.ChannelNumber :=  8;
  SCK          : CONSTANT RemoteIO.ChannelNumber :=  9;
  MISO         : CONSTANT RemoteIO.ChannelNumber := 10;
  MOSI         : CONSTANT RemoteIO.ChannelNumber := 11;

  PWM          : CONSTANT RemoteIO.ChannelNumber := 12;
  INT          : CONSTANT RemoteIO.ChannelNumber := 13;
  RX           : CONSTANT RemoteIO.ChannelNumber := 14;
  TX           : CONSTANT RemoteIO.ChannelNumber := 15;
  SCL          : CONSTANT RemoteIO.ChannelNumber := 16;
  SDA          : CONSTANT RemoteIO.ChannelNumber := 17;

  D0           : CONSTANT RemoteIO.ChannelNumber := 18;
  D1           : CONSTANT RemoteIO.ChannelNumber := 19;

  I2C_GROVE    : CONSTANT RemoteIO.ChannelNumber :=  0;
  I2C_MIKROBUS : CONSTANT RemoteIO.ChannelNumber :=  1;
  I2C_QWIIC    : CONSTANT RemoteIO.ChannelNumber :=  2;

  PWM_MIKROBUS : CONSTANT RemoteIO.ChannelNumber :=  0;

  SPI_MIKROBUS : CONSTANT RemoteIO.ChannelNumber :=  0;

END RemoteIO.BeaglePlay;
