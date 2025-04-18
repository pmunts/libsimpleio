-- Raspberry Pi 5 Device Definitions

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

WITH Device;

PACKAGE RaspberryPi5 IS

  -- The Raspberry Pi 5 has additional I2C bus controllers, which can be
  -- enabled by device tree overlays i2c0-pi5, i2c1-pi5, i2c2-pi5, and
  -- i2c3-pi5.

  I2C0   : CONSTANT Device.Designator := (0,  0);  -- GPIO0/GPIO1 or GPIO8/GPIO9
  I2C1   : CONSTANT Device.Designator := (0,  1);  -- GPIO2/GPIO3 or GPIO10/GPIO11
  I2C2   : CONSTANT Device.Designator := (0,  2);  -- GPIO4/GPIO5 or GPIO12/GPIO13
  I2C3   : CONSTANT Device.Designator := (0,  3);  -- GPIO6/GPIO7 or GPIO14/GPIO15 or GPIO22/23

  -- The Raspberry Pi 5 has two more PWM outputs, different chip enumeration,
  -- and different pin mapping.

  PWM0   : CONSTANT Device.Designator := (2,  0);  -- GPIO12
  PWM1   : CONSTANT Device.Designator := (2,  1);  -- GPIO13
  PWM2   : CONSTANT Device.Designator := (2,  2);  -- GPIO14 or GPIO18
  PWM3   : CONSTANT Device.Designator := (2,  3);  -- GPIO15 or GPIO19

END RaspberryPi5;
