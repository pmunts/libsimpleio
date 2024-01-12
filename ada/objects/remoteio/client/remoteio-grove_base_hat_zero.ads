-- Remote I/O Resources available from a Grove Base Hat Zero (SKU 103030276)

-- Copyright (C)2024, Philip Munts dba Munts Technologies.
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

PACKAGE RemoteIO.Grove_Base_Hat_Zero IS

  -- Analog inputs

  AIN0  : CONSTANT RemoteIO.ChannelNumber := 0;  -- Socket A0 pin 1
  AIN1  : CONSTANT RemoteIO.ChannelNumber := 1;  -- Socket A0 pin 2
  AIN2  : CONSTANT RemoteIO.ChannelNumber := 2;  -- Socket A2 pin 1
  AIN3  : CONSTANT RemoteIO.ChannelNumber := 3;  -- Socket A2 pin 2
  AIN4  : CONSTANT RemoteIO.ChannelNumber := 4;  -- Socket A4 pin 1
  AIN5  : CONSTANT RemoteIO.ChannelNumber := 5;  -- Socket A4 pin 2

  -- GPIO pins

  LED   : CONSTANT RemoteIO.ChannelNumber := 0;  -- Raspberry Pi user LED
  D5    : CONSTANT RemoteIO.ChannelNumber := 5;  -- Socket D5 pin 1
  D6    : CONSTANT RemoteIO.ChannelNumber := 6;  -- Socket D5 pin 2
  D9    : CONSTANT RemoteIO.ChannelNumber := 9;  -- Header J10 pin 3
  D10   : CONSTANT RemoteIO.ChannelNumber := 10; -- Header J10 pin 4
  D11   : CONSTANT RemoteIO.ChannelNumber := 11; -- Header J10 pin 2
  D12   : CONSTANT RemoteIO.ChannelNumber := 12; -- Socket PWM pin 1
  D13   : CONSTANT RemoteIO.ChannelNumber := 13; -- Socket PWM pin 2
  D16   : CONSTANT RemoteIO.ChannelNumber := 16; -- Socket D16 pin 1
  D17   : CONSTANT RemoteIO.ChannelNumber := 17; -- Socket D16 pin 2

  -- I2C bus

  I2C0  : CONSTANT RemoteIO.ChannelNumber := 0;  -- Socket I2C

END RemoteIO.Grove_Base_Hat_Zero;
