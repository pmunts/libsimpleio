-- MAX7219 LED driver services

-- Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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

WITH SPI;

PACKAGE MAX7219 IS

  -- SPI transfer characteristics

  SPI_Mode      : CONSTANT Natural := 0;
  SPI_WordSize  : CONSTANT Natural := 8;
  SPI_Frequency : CONSTANT Natural := 10_000_000;

  -- Device object type

  TYPE DeviceClass IS TAGGED PRIVATE;

  -- MAX7219 register types

  TYPE Register IS NEW SPI.Byte;
  Type Data     IS NEW SPI.Byte;

  -- MAX7219 device object constructors

  FUNCTION Create(dev : NOT NULL SPI.Device) RETURN DeviceClass;

  -- Reset the MAX7219 device

  PROCEDURE Initialize(Self : DeviceClass);

  -- Write a MAX7219 register

  PROCEDURE Put
   (Self : DeviceClass;
    reg  : Register;
    dat  : Data);

  -- MAX7219 Register addresses

  NOOP        : CONSTANT Register := 16#00#;
  DIGIT0      : CONSTANT Register := 16#01#;
  DIGIT1      : CONSTANT Register := 16#02#;
  DIGIT2      : CONSTANT Register := 16#03#;
  DIGIT3      : CONSTANT Register := 16#04#;
  DIGIT4      : CONSTANT Register := 16#05#;
  DIGIT5      : CONSTANT Register := 16#06#;
  DIGIT6      : CONSTANT Register := 16#07#;
  DIGIT7      : CONSTANT Register := 16#08#;
  DECODEMODE  : CONSTANT Register := 16#09#;
  INTENSITY   : CONSTANT Register := 16#0A#;
  SCANLIMIT   : CONSTANT Register := 16#0B#;
  SHUTDOWN    : CONSTANT Register := 16#0C#;
  DISPLAYTEST : CONSTANT Register := 16#0F#;

PRIVATE

  TYPE DeviceClass IS TAGGED RECORD
    dev : SPI.Device;
  END Record;

END MAX7219;
