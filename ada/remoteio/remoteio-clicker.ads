-- Definitions for MikroElektronika Clicker Boards, which have one mikroBUS

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
-- POSSIBILITY OF SUCH DAMAGE.i2c-remoteio.ads

PACKAGE RemoteIO.Clicker IS

  GPIO0  : CONSTANT ChannelNumber := 0;   -- LD1 aka left LED
  GPIO1  : CONSTANT ChannelNumber := 1;   -- T1  aka left button
  GPIO2  : CONSTANT ChannelNumber := 2;   -- LD2 aka right LED
  GPIO3  : CONSTANT ChannelNumber := 3;   -- T2  aka right button

  GPIO4  : CONSTANT ChannelNumber := 4;   -- HD2 Pin 10
  GPIO5  : CONSTANT ChannelNumber := 5;   -- HD2 Pin 9
  GPIO6  : CONSTANT ChannelNumber := 6;   -- HD2 Pin 8
  GPIO7  : CONSTANT ChannelNumber := 7;   -- HD2 Pin 7
  GPIO8  : CONSTANT ChannelNumber := 8;   -- HD2 Pin 6
  GPIO9  : CONSTANT ChannelNumber := 9;   -- HD2 Pin 5
  GPIO10 : CONSTANT ChannelNumber := 10;  -- HD2 Pin 4
  GPIO11 : CONSTANT ChannelNumber := 11;  -- HD2 Pin 3

  GPIO12 : CONSTANT ChannelNumber := 12;  -- mikroBUS AN
  GPIO13 : CONSTANT ChannelNumber := 13;  -- mikroBUS RST
  GPIO14 : CONSTANT ChannelNumber := 14;  -- mikroBUS CS
  GPIO15 : CONSTANT ChannelNumber := 15;  -- mikroBUS SCK
  GPIO16 : CONSTANT ChannelNumber := 16;  -- mikroBUS MISO
  GPIO17 : CONSTANT ChannelNumber := 17;  -- mikroBUS MOSI

  GPIO18 : CONSTANT ChannelNumber := 18;  -- mikroBUS PWM
  GPIO19 : CONSTANT ChannelNumber := 19;  -- mikroBUS INT
  GPIO20 : CONSTANT ChannelNumber := 20;  -- mikroBUS RX
  GPIO21 : CONSTANT ChannelNumber := 21;  -- mikroBUS TX
  GPIO22 : CONSTANT ChannelNumber := 22;  -- mikroBUS SCL
  GPIO23 : CONSTANT ChannelNumber := 23;  -- mikroBUS SDA

  -- Useful GPIO synonyms

  LD1    : CONSTANT ChannelNumber := GPIO0;
  T1     : CONSTANT ChannelNumber := GPIO1;
  LD2    : CONSTANT ChannelNumber := GPIO2;
  T2     : CONSTANT ChannelNumber := GPIO3;

  HD2_10 : CONSTANT ChannelNumber := GPIO4;
  HD2_9  : CONSTANT ChannelNumber := GPIO5;
  HD2_8  : CONSTANT ChannelNumber := GPIO6;
  HD2_7  : CONSTANT ChannelNumber := GPIO7;
  HD2_6  : CONSTANT ChannelNumber := GPIO8;
  HD2_5  : CONSTANT ChannelNumber := GPIO9;
  HD2_4  : CONSTANT ChannelNumber := GPIO10;
  HD2_3  : CONSTANT ChannelNumber := GPIO11;

  AN     : CONSTANT ChannelNumber := GPIO12;
  RST    : CONSTANT ChannelNumber := GPIO13;
  CS     : CONSTANT ChannelNumber := GPIO14;
  SCK    : CONSTANT ChannelNumber := GPIO15;
  MISO   : CONSTANT ChannelNumber := GPIO16;
  MOSI   : CONSTANT ChannelNumber := GPIO17;

  PWM    : CONSTANT ChannelNumber := GPIO18;
  INT    : CONSTANT ChannelNumber := GPIO19;
  RX     : CONSTANT ChannelNumber := GPIO20;
  TX     : CONSTANT ChannelNumber := GPIO21;
  SCL    : CONSTANT ChannelNumber := GPIO22;
  SDA    : CONSTANT ChannelNumber := GPIO23;

END RemoteIO.Clicker;
