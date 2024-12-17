-- Raspberry Pi 4 Device Definitions

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

PACKAGE RaspberryPi4 IS

  -- The Raspberry Pi 4 has additional I2C bus controllers, which can be
  -- enabled by device tree overlays i2c3, i2c4, i2c5, or i2c6.

  I2C3   : CONSTANT Device.Designator := (0,  3);  -- GPIO2/GPIO3   or GPIO4/GPIO5
  I2C4   : CONSTANT Device.Designator := (0,  4);  -- GPIO6/GPIO7   or GPIO8/GPIO9
  I2C5   : CONSTANT Device.Designator := (0,  5);  -- GPIO10/GPIO11 or GPIO12/GPIO13
  I2C6   : CONSTANT Device.Designator := (0,  6);  -- GPIO0/GPIO1   or GPIO22/GPIO23

END RaspberryPi4;
