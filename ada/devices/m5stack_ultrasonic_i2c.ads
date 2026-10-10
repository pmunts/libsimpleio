-- Copyright (C)2026, Philip Munts dba Munts Technologies.
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

-- See https://shop.m5stack.com/products/ultrasonic-distance-unit-i2c-rcwl-9620
-- for more information.

WITH Distance;
WITH I2C;

PACKAGE M5Stack_Ultrasonic_I2C IS

  DefaultAddress : CONSTANT I2C.Address := 16#57#;

  TYPE Sensor IS NEW Distance.InputInterface WITH PRIVATE;

  -- Device object constructor

  FUNCTION Create
   (bus     : NOT NULL I2C.Bus;
    addr    : I2C.Address := DefaultAddress;
    stretch : Boolean     := False) RETURN Distance.Input;

  -- Device object instance initializer

  PROCEDURE Initialize
   (Self    : OUT Sensor;
    bus     : NOT NULL I2C.Bus;
    addr    : I2C.Address := DefaultAddress;
    stretch : Boolean     := False);

  -- Get distance in meters

  FUNCTION Get(Self : IN OUT Sensor) RETURN Distance.meters;

PRIVATE

  TYPE Sensor IS NEW Distance.InputInterface WITH RECORD
    bus     : I2C.Bus;
    address : I2C.Address;
    stretch : Boolean;
  END RECORD;

END M5Stack_Ultrasonic_I2C;
