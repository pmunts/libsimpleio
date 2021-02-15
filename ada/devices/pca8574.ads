-- PCA8574 I2C GPIO expander device services

-- Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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

WITH I2C;

PACKAGE PCA8574 IS

  PCA8574_Error : EXCEPTION;

  TYPE Byte IS MOD 256;

  TYPE DeviceClass IS TAGGED PRIVATE;

  TYPE Device IS ACCESS DeviceClass;

  MaxSpeed : CONSTANT := I2C.SpeedStandard; -- Limit for older PCF8574

  -- PCA8574 device object constructor

  FUNCTION Create
   (bus    : NOT NULL I2C.Bus;
    addr   : I2C.Address;
    states : Byte := 16#FF#) RETURN Device;

  -- PCA8574 methods

  FUNCTION Get(Self : IN OUT DeviceClass) RETURN Byte;

  PROCEDURE Put(Self : IN OUT DeviceClass; data : Byte);

PRIVATE

  -- Complete the definition for PCA8574.DeviceClass

  TYPE DeviceClass IS TAGGED RECORD
    bus   : I2C.Bus;
    addr  : I2C.Address;
    latch : Byte;
  END RECORD;

END PCA8574;
