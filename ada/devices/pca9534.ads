-- PCA9534 I2C GPIO expander device services

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

PACKAGE PCA9534 IS

  PCA9534_Error : EXCEPTION;

  TYPE RegisterAddress IS RANGE 0 .. 3;
  TYPE Byte IS MOD 2**8;

  TYPE DeviceClass IS TAGGED PRIVATE;

  TYPE Device IS ACCESS DeviceClass;

  MaxSpeed : CONSTANT := I2C.SpeedFast;

  -- PCA9534 register addresses

  InputPortReg     : CONSTANT RegisterAddress := 0;
  OutputPortReg    : CONSTANT RegisterAddress := 1;
  InputPolarityReg : CONSTANT RegisterAddress := 2;
  ConfigurationReg : CONSTANT RegisterAddress := 3;

  -- PCA9534 register data constants

  AllInputs  : CONSTANT Byte := 16#FF#;
  AllOutputs : CONSTANT Byte := 16#00#;
  AllNormal  : CONSTANT Byte := 16#00#;
  AllOff     : CONSTANT Byte := 16#00#;

  -- PCA9534 device object constructor

  FUNCTION Create
   (bus      : NOT NULL I2C.Bus;
    addr     : I2C.Address;
    config   : Byte := AllInputs;
    states   : Byte := AllOff) RETURN Device;

  -- Read from a PCA9534 register

  FUNCTION Get
   (Self : IN OUT DeviceClass;
    addr : RegisterAddress) RETURN Byte;

  -- Write to a PCA9534 register

  PROCEDURE Put
   (Self : IN OUT DeviceClass;
    addr : RegisterAddress;
    data : Byte);

  -- Read from the PCA9534 input port register

  FUNCTION Get
   (Self : IN OUT DeviceClass) RETURN Byte;

  -- Write to the PCA9534 output port register

  PROCEDURE Put
   (Self : IN OUT DeviceClass;
    data : Byte);

PRIVATE

  -- Complete the definition for PCA9534.DeviceClass

  TYPE DeviceClass IS TAGGED RECORD
    bus    : I2C.Bus;
    addr   : I2C.Address;
    config : Byte;
    latch  : Byte;
  END RECORD;

END PCA9534;
