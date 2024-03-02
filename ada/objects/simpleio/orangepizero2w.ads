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

  GPIO264 : CONSTANT Device.Designator := (0, 264); -- Pin 3  aka I2C1 SDA
  GPIO263 : CONSTANT Device.Designator := (0, 263); -- Pin 5  aka I2C1 SCL
  GPIO269 : CONSTANT Device.Designator := (0, 269); -- Pin 7  aka PWM3, UART4 TXD
  GPIO224 : CONSTANT Device.Designator := (0, 224); -- Pin 8  aka UART0 TXD
  GPIO225 : CONSTANT Device.Designator := (0, 225); -- Pin 10 aka UART0 RXD
  GPIO226 : CONSTANT Device.Designator := (0, 226); -- Pin 11 aka UART5 RXD
  GPIO257 : CONSTANT Device.Designator := (0, 257); -- Pin 12
  GPIO227 : CONSTANT Device.Designator := (0, 227); -- Pin 13 aka UART5 RXD
  GPIO261 : CONSTANT Device.Designator := (0, 261); -- Pin 15 aka I2C0 SCL, UART2 TXD
  GPIO270 : CONSTANT Device.Designator := (0, 270); -- Pin 16 aka PWM4, UART4 RXD
  GPIO228 : CONSTANT Device.Designator := (0, 228); -- Pin 18
  GPIO231 : CONSTANT Device.Designator := (0, 231); -- Pin 19 aka SPI1 MOSI
  GPIO232 : CONSTANT Device.Designator := (0, 232); -- Pin 21 aka SPI1 MISO
  GPIO262 : CONSTANT Device.Designator := (0, 262); -- Pin 22 aka I2C0 SDA, UART2 RXD
  GPIO230 : CONSTANT Device.Designator := (0, 230); -- Pin 23 aka SPI1 CLK
  GPIO229 : CONSTANT Device.Designator := (0, 229); -- Pin 24 aka SPI1 SS0
  GPIO233 : CONSTANT Device.Designator := (0, 233); -- Pin 26 aka SPI1 SS1
  GPIO266 : CONSTANT Device.Designator := (0, 266); -- Pin 27 aka I2C2 SDA, UART3 RXD
  GPIO265 : CONSTANT Device.Designator := (0, 265); -- Pin 28 aka I2C2 SCL, UART3 TXD
  GPIO256 : CONSTANT Device.Designator := (0, 256); -- Pin 29
  GPIO271 : CONSTANT Device.Designator := (0, 271); -- Pin 31
  GPIO267 : CONSTANT Device.Designator := (0, 267); -- Pin 32 aka PWM1
  GPIO268 : CONSTANT Device.Designator := (0, 268); -- Pin 33 aka PMW2
  GPIO258 : CONSTANT Device.Designator := (0, 258); -- Pin 35
  GPIO76  : CONSTANT Device.Designator := (0, 76);  -- Pin 36
  GPIO272 : CONSTANT Device.Designator := (0, 272); -- Pin 37
  GPIO260 : CONSTANT Device.Designator := (0, 260); -- Pin 38
  GPIO259 : CONSTANT Device.Designator := (0, 259); -- Pin 40

  -- The following subsystems require device tree overlays

  I2C0    : CONSTANT Device.Designator := (0, 0);   -- Pins 15 and 22
  I2C1    : CONSTANT Device.Designator := (0, 1);   -- Pins 3  and 5
  I2C2    : CONSTANT Device.Designator := (0, 2);   -- Pins 27 and 28

  PWM1    : CONSTANT Device.Designator := (0, 1);   -- Pin 32
  PWM2    : CONSTANT Device.Designator := (0, 2);   -- Pin 33
  PWM3    : CONSTANT Device.Designator := (0, 3);   -- Pin 7
  PWM4    : CONSTANT Device.Designator := (0, 4);   -- Pin 16

  SPI1_0  : CONSTANT Device.Designator := (1, 0);   -- Pin 24
  SPI1_1  : CONSTANT Device.Designator := (1, 1);   -- Pin 26

END OrangePiZero2W;
