-- I/O Resources available from a MikroElektronika Clicker Board Remote I/O
-- Server

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE RemoteIO.Clicker IS

  AIN0   : CONSTANT RemoteIO.ChannelNumber := 0;

  GPIO0  : CONSTANT RemoteIO.ChannelNumber := 0;   -- LD1 aka left LED
  GPIO1  : CONSTANT RemoteIO.ChannelNumber := 1;   -- T1  aka left button
  GPIO2  : CONSTANT RemoteIO.ChannelNumber := 2;   -- LD2 aka right LED
  GPIO3  : CONSTANT RemoteIO.ChannelNumber := 3;   -- T2  aka right button

  GPIO4  : CONSTANT RemoteIO.ChannelNumber := 4;   -- HD2 Pin 10
  GPIO5  : CONSTANT RemoteIO.ChannelNumber := 5;   -- HD2 Pin 9
  GPIO6  : CONSTANT RemoteIO.ChannelNumber := 6;   -- HD2 Pin 8
  GPIO7  : CONSTANT RemoteIO.ChannelNumber := 7;   -- HD2 Pin 7
  GPIO8  : CONSTANT RemoteIO.ChannelNumber := 8;   -- HD2 Pin 6
  GPIO9  : CONSTANT RemoteIO.ChannelNumber := 9;   -- HD2 Pin 5
  GPIO10 : CONSTANT RemoteIO.ChannelNumber := 10;  -- HD2 Pin 4
  GPIO11 : CONSTANT RemoteIO.ChannelNumber := 11;  -- HD2 Pin 3

  GPIO12 : CONSTANT RemoteIO.ChannelNumber := 12;  -- mikroBUS AN
  GPIO13 : CONSTANT RemoteIO.ChannelNumber := 13;  -- mikroBUS RST
  GPIO14 : CONSTANT RemoteIO.ChannelNumber := 14;  -- mikroBUS CS
  GPIO15 : CONSTANT RemoteIO.ChannelNumber := 15;  -- mikroBUS SCK
  GPIO16 : CONSTANT RemoteIO.ChannelNumber := 16;  -- mikroBUS MISO
  GPIO17 : CONSTANT RemoteIO.ChannelNumber := 17;  -- mikroBUS MOSI

  GPIO18 : CONSTANT RemoteIO.ChannelNumber := 18;  -- mikroBUS PWM
  GPIO19 : CONSTANT RemoteIO.ChannelNumber := 19;  -- mikroBUS INT
  GPIO20 : CONSTANT RemoteIO.ChannelNumber := 20;  -- mikroBUS RX
  GPIO21 : CONSTANT RemoteIO.ChannelNumber := 21;  -- mikroBUS TX
  GPIO22 : CONSTANT RemoteIO.ChannelNumber := 22;  -- mikroBUS SCL
  GPIO23 : CONSTANT RemoteIO.ChannelNumber := 23;  -- mikroBUS SDA

  I2C0   : CONSTANT RemoteIO.ChannelNumber := 0;

  SPI0   : CONSTANT RemoteIO.ChannelNumber := 0;

  -- Useful GPIO synonyms

  LD1    : CONSTANT RemoteIO.ChannelNumber := GPIO0;
  T1     : CONSTANT RemoteIO.ChannelNumber := GPIO1;
  LD2    : CONSTANT RemoteIO.ChannelNumber := GPIO2;
  T2     : CONSTANT RemoteIO.ChannelNumber := GPIO3;

  HD2_10 : CONSTANT RemoteIO.ChannelNumber := GPIO4;
  HD2_9  : CONSTANT RemoteIO.ChannelNumber := GPIO5;
  HD2_8  : CONSTANT RemoteIO.ChannelNumber := GPIO6;
  HD2_7  : CONSTANT RemoteIO.ChannelNumber := GPIO7;
  HD2_6  : CONSTANT RemoteIO.ChannelNumber := GPIO8;
  HD2_5  : CONSTANT RemoteIO.ChannelNumber := GPIO9;
  HD2_4  : CONSTANT RemoteIO.ChannelNumber := GPIO10;
  HD2_3  : CONSTANT RemoteIO.ChannelNumber := GPIO11;

  AN     : CONSTANT RemoteIO.ChannelNumber := GPIO12;
  RST    : CONSTANT RemoteIO.ChannelNumber := GPIO13;
  CS     : CONSTANT RemoteIO.ChannelNumber := GPIO14;
  SCK    : CONSTANT RemoteIO.ChannelNumber := GPIO15;
  MISO   : CONSTANT RemoteIO.ChannelNumber := GPIO16;
  MOSI   : CONSTANT RemoteIO.ChannelNumber := GPIO17;

  PWM    : CONSTANT RemoteIO.ChannelNumber := GPIO18;
  INT    : CONSTANT RemoteIO.ChannelNumber := GPIO19;
  RX     : CONSTANT RemoteIO.ChannelNumber := GPIO20;
  TX     : CONSTANT RemoteIO.ChannelNumber := GPIO21;
  SCL    : CONSTANT RemoteIO.ChannelNumber := GPIO22;
  SDA    : CONSTANT RemoteIO.ChannelNumber := GPIO23;

END RemoteIO.Clicker;
