-- Orange Pi Zero 2W Device Designators for Raspberry Pi Compatibility

-- Copyright (C)2023, Philip Munts dba Munts Technologies.
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

-- The Orange Pi Zero 2W 40-pin expansion header has excellent compatibility
-- with Raspbery Pi boards, with the exception that PWM outputs are not
-- routed to GPIO18 or GPIO19.

WITH Device;

PACKAGE OrangePiZero2W.RaspberryPi IS

  GPIO2  : Device.Designator RENAMES OrangePiZero2W.GPIO264; -- Pin 3
  GPIO3  : Device.Designator RENAMES OrangePiZero2W.GPIO263; -- Pin 5
  GPIO4  : Device.Designator RENAMES OrangePiZero2W.GPIO269; -- Pin 7
  GPIO5  : Device.Designator RENAMES OrangePiZero2W.GPIO256; -- Pin 29
  GPIO6  : Device.Designator RENAMES OrangePiZero2W.GPIO271; -- Pin 31
  GPIO7  : Device.Designator RENAMES OrangePiZero2W.GPIO233; -- Pin 26
  GPIO8  : Device.Designator RENAMES OrangePiZero2W.GPIO229; -- Pin 24
  GPIO9  : Device.Designator RENAMES OrangePiZero2W.GPIO232; -- Pin 21
  GPIO10 : Device.Designator RENAMES OrangePiZero2W.GPIO231; -- Pin 19
  GPIO11 : Device.Designator RENAMES OrangePiZero2W.GPIO230; -- Pin 23
  GPIO12 : Device.Designator RENAMES OrangePiZero2W.GPIO267; -- Pin 32
  GPIO13 : Device.Designator RENAMES OrangePiZero2W.GPIO268; -- Pin 33
  GPIO14 : Device.Designator RENAMES OrangePiZero2W.GPIO224; -- Pin 8
  GPIO15 : Device.Designator RENAMES OrangePiZero2W.GPIO225; -- Pin 10
  GPIO16 : Device.Designator RENAMES OrangePiZero2W.GPIO76;  -- Pin 36
  GPIO17 : Device.Designator RENAMES OrangePiZero2W.GPIO226; -- Pin 11
  GPIO18 : Device.Designator RENAMES OrangePiZero2W.GPIO257; -- Pin 12
  GPIO19 : Device.Designator RENAMES OrangePiZero2W.GPIO258; -- Pin 35
  GPIO20 : Device.Designator RENAMES OrangePiZero2W.GPIO260; -- Pin 38
  GPIO21 : Device.Designator RENAMES OrangePiZero2W.GPIO259; -- Pin 40
  GPIO22 : Device.Designator RENAMES OrangePiZero2W.GPIO261; -- Pin 15
  GPIO23 : Device.Designator RENAMES OrangePiZero2W.GPIO270; -- Pin 16
  GPIO24 : Device.Designator RENAMES OrangePiZero2W.GPIO228; -- Pin 18
  GPIO25 : Device.Designator RENAMES OrangePiZero2W.GPIO262; -- Pin 22
  GPIO26 : Device.Designator RENAMES OrangePiZero2W.GPIO272; -- Pin 37
  GPIO27 : Device.Designator RENAMES OrangePiZero2W.GPIO227; -- Pin 13

  I2C1   : Device.Designator RENAMES OrangePiZero2W.I2C1;    -- Pins 3 and 5

  PWM0   : Device.Designator RENAMES OrangePiZero2W.PWM1;    -- Pin 32;
  PWM1   : Device.Designator RENAMES OrangePiZero2W.PWM2;    -- Pin 33;

  SPI0_0 : Device.Designator RENAMES OrangePiZero2W.SPI1_0;  -- Pin 24;
  SPI0_1 : Device.Designator RENAMES OrangePiZero2W.SPI1_1;  -- Pin 26;

END OrangePiZero2W.RaspberryPi;
