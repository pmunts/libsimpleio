-- Orange Pi Zero 2 W Device Designators for Raspberry Pi Compatibility

-- Copyright (C)2023-2024, Philip Munts dba Munts Technologies.
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

-- The Orange Pi Zero 2 W 40-pin expansion header has excellent compatibility
-- with Raspbery Pi boards, with the exception that PWM outputs are not
-- routed to GPIO18 or GPIO19.

WITH Device;

PACKAGE OrangePiZero2W.RaspberryPi IS

  GPIO2  : Device.Designator RENAMES OrangePiZero2W.PI8;    -- Pin 3  I2C1 SDA
  GPIO3  : Device.Designator RENAMES OrangePiZero2W.PI7;    -- Pin 5  I2C1 SCL
  GPIO4  : Device.Designator RENAMES OrangePiZero2W.PI13;   -- Pin 7  PWM2
  GPIO17 : Device.Designator RENAMES OrangePiZero2W.PH2;    -- Pin 11
  GPIO27 : Device.Designator RENAMES OrangePiZero2W.PH3;    -- Pin 13
  GPIO22 : Device.Designator RENAMES OrangePiZero2W.PI5;    -- Pin 15
  GPIO10 : Device.Designator RENAMES OrangePiZero2W.PH7;    -- Pin 19 SPI0 MOSI
  GPIO9  : Device.Designator RENAMES OrangePiZero2W.PH8;    -- Pin 21 SPI0 MISO
  GPIO11 : Device.Designator RENAMES OrangePiZero2W.PH6;    -- Pin 23 SPI0 SCLK
  GPIO0  : Device.Designator RENAMES OrangePiZero2W.PI10;   -- Pin 27 I2C2 SDA
  GPIO5  : Device.Designator RENAMES OrangePiZero2W.PI0;    -- Pin 29
  GPIO6  : Device.Designator RENAMES OrangePiZero2W.PI15;   -- Pin 31
  GPIO13 : Device.Designator RENAMES OrangePiZero2W.PI12;   -- Pin 33 PWM1
  GPIO19 : Device.Designator RENAMES OrangePiZero2W.PI2;    -- Pin 35
  GPIO26 : Device.Designator RENAMES OrangePiZero2W.PI16;   -- Pin 37
  GPIO14 : Device.Designator RENAMES OrangePiZero2W.PH0;    -- Pin 8  TXD0
  GPIO15 : Device.Designator RENAMES OrangePiZero2W.PH1;    -- Pin 10 RXD0
  GPIO18 : Device.Designator RENAMES OrangePiZero2W.PI1;    -- Pin 12
  GPIO23 : Device.Designator RENAMES OrangePiZero2W.PI14;   -- Pin 16 PWM3
  GPIO24 : Device.Designator RENAMES OrangePiZero2W.PH4;    -- Pin 18
  GPIO25 : Device.Designator RENAMES OrangePiZero2W.PI6;    -- Pin 22
  GPIO8  : Device.Designator RENAMES OrangePiZero2W.PH5;    -- Pin 24 SPI0 CE0
  GPIO7  : Device.Designator RENAMES OrangePiZero2W.PH9;    -- Pin 26 SPI0 CE1
  GPIO1  : Device.Designator RENAMES OrangePiZero2W.PI9;    -- Pin 28 I2C2 SCL
  GPIO12 : Device.Designator RENAMES OrangePiZero2W.PI11;   -- Pin 32 PWM0
  GPIO16 : Device.Designator RENAMES OrangePiZero2W.PC12;   -- Pin 36
  GPIO20 : Device.Designator RENAMES OrangePiZero2W.PI4;    -- Pin 38
  GPIO21 : Device.Designator RENAMES OrangePiZero2W.PI3;    -- Pin 40

  I2C1   : Device.Designator RENAMES OrangePiZero2W.I2C1;   -- Pins 3 and 5
  I2C2   : Device.Designator RENAMES OrangePiZero2W.I2C2;   -- Pins 27 and 28

  PWM0   : Device.Designator RENAMES OrangePiZero2W.PWM1;   -- Pin 32;
  PWM1   : Device.Designator RENAMES OrangePiZero2W.PWM2;   -- Pin 33;
  PWM2   : Device.Designator RENAMES OrangePiZero2W.PWM3;   -- Pin 7
  PWM3   : Device.Designator RENAMES OrangePiZero2W.PWM4;   -- Pin 16;

  -- The H618 hardware subsystem SPI1 at address 0x05011000 is instantiated
  -- as /sys/class/spi_master/spi0, resulting in slave device nodes named
  -- /dev/spidev0.0 and /dev/spidev0.1.

  SPI0_0 : Device.Designator RENAMES OrangePiZero2W.SPI0_0; -- Pin 24;
  SPI0_1 : Device.Designator RENAMES OrangePiZero2W.SPI0_1; -- Pin 26;

END OrangePiZero2W.RaspberryPi;
