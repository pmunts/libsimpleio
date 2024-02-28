-- Sparkfun LCD-16397 16x2 Display Module Services

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

-- See also: https://www.sparkfun.com/products/16397

WITH I2C;

PACKAGE LCD16397 IS

  TYPE DeviceClass IS TAGGED PRIVATE;

  TYPE Device IS ACCESS ALL DeviceClass'Class;

  DefaultAddress : CONSTANT I2C.Address := 16#72#;

  TYPE RowNumber    IS NEW Natural RANGE 1 .. 2;
  TYPE ColumnNumber IS NEW Natural RANGE 0 .. 15;

  -- Device object constructor

  FUNCTION Create
   (bus  : I2C.Bus;
    addr : I2C.Address := DefaultAddress) RETURN Device;

  -- Device object instance initializer

  PROCEDURE Initialize
   (Self : OUT DeviceClass;
    bus  : I2C.Bus;
    addr : I2C.Address := DefaultAddress);

  -- Write string to display

  PROCEDURE Put(Self : DeviceClass; s : String);

  -- Write character to display

  PROCEDURE Put(Self : DeviceClass; c : Character);

  -- Request software reset

  PROCEDURE Reset(Self : DeviceClass);

  -- Clear display

  PROCEDURE Clear(Self : DeviceClass);

  -- Move cursor

  PROCEDURE Move
   (Self : DeviceClass;
    row  : RowNumber;
    col  : ColumnNumber);

PRIVATE

  TYPE DeviceClass IS TAGGED RECORD
    bus  : I2C.Bus;
    addr : I2C.Address;
  END RECORD;

END LCD16397;
