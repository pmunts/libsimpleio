-- Orange Pi Zero 2 W Device Designators

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

WITH Device;

PACKAGE OrangePiZero2W IS

  ModelName : CONSTANT String := "OrangePi Zero2 W"; -- From /proc/device-tree/model

  PI8  : CONSTANT Device.Designator := (0, 264);  -- Pin 3  I2C1 SDA
  PI7  : CONSTANT Device.Designator := (0, 263);  -- Pin 5  I2C1 SCL
  PI13 : CONSTANT Device.Designator := (0, 269);  -- Pin 7  PWM3
  PH2  : CONSTANT Device.Designator := (0, 226);  -- Pin 11
  PH3  : CONSTANT Device.Designator := (0, 227);  -- Pin 13
  PI5  : CONSTANT Device.Designator := (0, 261);  -- Pin 15
  PH7  : CONSTANT Device.Designator := (0, 231);  -- Pin 19 SPI1 MOSI
  PH8  : CONSTANT Device.Designator := (0, 232);  -- Pin 21 SPI1 MISO
  PH6  : CONSTANT Device.Designator := (0, 230);  -- Pin 23 SPI1 CLK
  PI10 : CONSTANT Device.Designator := (0, 266);  -- Pin 27 I2C2 SDA
  PI0  : CONSTANT Device.Designator := (0, 256);  -- Pin 29
  PI15 : CONSTANT Device.Designator := (0, 271);  -- Pin 31
  PI12 : CONSTANT Device.Designator := (0, 268);  -- Pin 33 PWM2
  PI2  : CONSTANT Device.Designator := (0, 258);  -- Pin 35
  PI16 : CONSTANT Device.Designator := (0, 272);  -- Pin 37
  PH0  : CONSTANT Device.Designator := (0, 224);  -- Pin 8  TXD0
  PH1  : CONSTANT Device.Designator := (0, 225);  -- Pin 10 RXD0
  PI1  : CONSTANT Device.Designator := (0, 257);  -- Pin 12
  PI14 : CONSTANT Device.Designator := (0, 270);  -- Pin 16 PWM4
  PH4  : CONSTANT Device.Designator := (0, 228);  -- Pin 18
  PI6  : CONSTANT Device.Designator := (0, 262);  -- Pin 22
  PH5  : CONSTANT Device.Designator := (0, 229);  -- Pin 24 SPI1 SS0
  PH9  : CONSTANT Device.Designator := (0, 233);  -- Pin 26 SPI1 SS1
  PI9  : CONSTANT Device.Designator := (0, 265);  -- Pin 28 I2C2 SCL
  PI11 : CONSTANT Device.Designator := (0, 267);  -- Pin 32 PWM1
  PC12 : CONSTANT Device.Designator := (0, 76);   -- Pin 36
  PI4  : CONSTANT Device.Designator := (0, 260);  -- Pin 38
  PI3  : CONSTANT Device.Designator := (0, 259);  -- Pin 40

  -- GPIO pin number aliases

  GPIO76  : Device.Designator RENAMES PC12;       -- Pin 36
  GPIO224 : Device.Designator RENAMES PH0;        -- Pin 8  TXD0
  GPIO225 : Device.Designator RENAMES PH1;        -- Pin 10 RXD0
  GPIO226 : Device.Designator RENAMES PH2;        -- Pin 11
  GPIO227 : Device.Designator RENAMES PH3;        -- Pin 13
  GPIO228 : Device.Designator RENAMES PH4;        -- Pin 18
  GPIO229 : Device.Designator RENAMES PH5;        -- Pin 24 SPI1 SS0
  GPIO230 : Device.Designator RENAMES PH6;        -- Pin 23 SPI1 CLK
  GPIO231 : Device.Designator RENAMES PH7;        -- Pin 19 SPI1 MOSI
  GPIO232 : Device.Designator RENAMES PH8;        -- Pin 21 SPI1 MISO
  GPIO233 : Device.Designator RENAMES PH9;        -- Pin 26 SPI1 SS1
  GPIO256 : Device.Designator RENAMES PI0;        -- Pin 29
  GPIO257 : Device.Designator RENAMES PI1;        -- Pin 12
  GPIO258 : Device.Designator RENAMES PI2;        -- Pin 35
  GPIO259 : Device.Designator RENAMES PI3;        -- Pin 40
  GPIO260 : Device.Designator RENAMES PI4;        -- Pin 38
  GPIO261 : Device.Designator RENAMES PI5;        -- Pin 15
  GPIO262 : Device.Designator RENAMES PI6;        -- Pin 22
  GPIO263 : Device.Designator RENAMES PI7;        -- Pin 5  I2C1 SCL
  GPIO264 : Device.Designator RENAMES PI8;        -- Pin 3  I2C1 SDA
  GPIO265 : Device.Designator RENAMES PI9;        -- Pin 28 I2C2 SCL
  GPIO266 : Device.Designator RENAMES PI10;       -- Pin 27 I2C2 SDA
  GPIO267 : Device.Designator RENAMES PI11;       -- Pin 32 PWM1
  GPIO268 : Device.Designator RENAMES PI12;       -- Pin 33 PWM2
  GPIO269 : Device.Designator RENAMES PI13;       -- Pin 7  PWM3
  GPIO270 : Device.Designator RENAMES PI14;       -- Pin 16 PWM4
  GPIO271 : Device.Designator RENAMES PI15;       -- Pin 31
  GPIO272 : Device.Designator RENAMES PI16;       -- Pin 37

  -- Raspberry Pi compatibility GPIO pin number aliases

  GPIO0   : Device.Designator RENAMES PI10;       -- Pin 27 I2C2 SDA
  GPIO1   : Device.Designator RENAMES PI9;        -- Pin 28 I2C2 SCL
  GPIO2   : Device.Designator RENAMES PI8;        -- Pin 3  I2C1 SDA
  GPIO3   : Device.Designator RENAMES PI7;        -- Pin 5  I2C1 SCL
  GPIO4   : Device.Designator RENAMES PI13;       -- Pin 7  PWM3
  GPIO5   : Device.Designator RENAMES PI0;        -- Pin 29
  GPIO6   : Device.Designator RENAMES PI15;       -- Pin 31
  GPIO7   : Device.Designator RENAMES PH9;        -- Pin 26 SPI1 SS1
  GPIO8   : Device.Designator RENAMES PH5;        -- Pin 24 SPI1 SS0
  GPIO9   : Device.Designator RENAMES PH8;        -- Pin 21 SPI1 MISO
  GPIO10  : Device.Designator RENAMES PH7;        -- Pin 19 SPI1 MOSI
  GPIO11  : Device.Designator RENAMES PH6;        -- Pin 23 SPI1 CLK
  GPIO12  : Device.Designator RENAMES PI11;       -- Pin 32 PWM1
  GPIO13  : Device.Designator RENAMES PI12;       -- Pin 33 PWM2
  GPIO14  : Device.Designator RENAMES PH0;        -- Pin 8  TXD0
  GPIO15  : Device.Designator RENAMES PH1;        -- Pin 10 RXD0
  GPIO16  : Device.Designator RENAMES PC12;       -- Pin 36
  GPIO17  : Device.Designator RENAMES PH2;        -- Pin 11
  GPIO18  : Device.Designator RENAMES PI1;        -- Pin 12
  GPIO19  : Device.Designator RENAMES PI2;        -- Pin 35
  GPIO20  : Device.Designator RENAMES PI4;        -- Pin 38
  GPIO21  : Device.Designator RENAMES PI3;        -- Pin 40
  GPIO22  : Device.Designator RENAMES PI5;        -- Pin 15
  GPIO23  : Device.Designator RENAMES PI14;       -- Pin 16 PWM4
  GPIO24  : Device.Designator RENAMES PH4;        -- Pin 18
  GPIO25  : Device.Designator RENAMES PI6;        -- Pin 22
  GPIO26  : Device.Designator RENAMES PI16;       -- Pin 37
  GPIO27  : Device.Designator RENAMES PH3;        -- Pin 13

  I2C1    : CONSTANT Device.Designator := (0, 1); -- Pins 3  and 5
  I2C2    : CONSTANT Device.Designator := (0, 2); -- Pins 27 and 28

  PWM1    : CONSTANT Device.Designator := (0, 1); -- Pin 32
  PWM2    : CONSTANT Device.Designator := (0, 2); -- Pin 33
  PWM3    : CONSTANT Device.Designator := (0, 3); -- Pin 7
  PWM4    : CONSTANT Device.Designator := (0, 4); -- Pin 16

  -- The H618 hardware subsystem SPI1 at address 0x05011000 is instantiated
  -- as /sys/class/spi_master/spi0, resulting in slave device nodes named
  -- /dev/spidev0.0 and /dev/spidev0.1.

  SPI0_0  : CONSTANT Device.Designator := (0, 0); -- Pin 24
  SPI0_1  : CONSTANT Device.Designator := (0, 1); -- Pin 26

END OrangePiZero2W;
