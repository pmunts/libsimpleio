-- Remote I/O Resources available from a Spark Fun Electronics Qwiic HAT

-- Copyright (C)2019-2024, Philip Munts dba Munts Technologies.
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

PACKAGE RemoteIO.Qwiic_HAT IS

  -- GPIO pins

  LED    : CONSTANT RemoteIO.ChannelNumber := 0;  -- Raspberry Pi user LED
  GPIO6  : CONSTANT RemoteIO.ChannelNumber := 6;
  GPIO7  : CONSTANT RemoteIO.ChannelNumber := 7;
  GPIO12 : CONSTANT RemoteIO.ChannelNumber := 12;
  GPIO16 : CONSTANT RemoteIO.ChannelNumber := 16;
  GPIO20 : CONSTANT RemoteIO.ChannelNumber := 20;
  GPIO21 : CONSTANT RemoteIO.ChannelNumber := 21;

  -- I2C bus

  I2C0   : CONSTANT RemoteIO.ChannelNumber := 0;

  -- SPI bus

  SPI0   : CONSTANT RemoteIO.ChannelNumber := 0;

END RemoteIO.Qwiic_HAT;