-- MCP23017 I2C GPIO expander device services

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE MCP23017 IS

  MCP23017_Error : EXCEPTION;

  TYPE DeviceClass IS TAGGED PRIVATE;

  TYPE Device IS ACCESS DeviceClass;

  -- MCP23017 device object constructor

  FUNCTION Create
   (bus   : I2C.Bus;
    addr  : I2C.Address) RETURN Device;

PRIVATE

  TYPE RegisterAddress8 IS MOD 2**8;
  TYPE RegisterAddress16 IS MOD 2**8;

  TYPE RegisterData8 IS MOD 2**8;
  TYPE RegisterData16 IS MOD 2**16;

  -- Define MCP23017 register address constants

  IODIRA   : CONSTANT RegisterAddress8 := 16#00#;
  IODIRB   : CONSTANT RegisterAddress8 := 16#01#;
  IPOLA    : CONSTANT RegisterAddress8 := 16#02#;
  IPOLB    : CONSTANT RegisterAddress8 := 16#03#;
  GPINTENA : CONSTANT RegisterAddress8 := 16#04#;
  GPINTENB : CONSTANT RegisterAddress8 := 16#05#;
  DEFVALA  : CONSTANT RegisterAddress8 := 16#06#;
  DEFVALB  : CONSTANT RegisterAddress8 := 16#07#;
  INTCONA  : CONSTANT RegisterAddress8 := 16#08#;
  INTCONB  : CONSTANT RegisterAddress8 := 16#09#;
  IOCONA   : CONSTANT RegisterAddress8 := 16#0A#;
  IOCONB   : CONSTANT RegisterAddress8 := 16#0B#;
  GPPUA    : CONSTANT RegisterAddress8 := 16#0C#;
  GPPUB    : CONSTANT RegisterAddress8 := 16#0D#;
  INTFA    : CONSTANT RegisterAddress8 := 16#0E#;
  INTFB    : CONSTANT RegisterAddress8 := 16#0F#;
  INTCAPA  : CONSTANT RegisterAddress8 := 16#10#;
  INTCAPB  : CONSTANT RegisterAddress8 := 16#11#;
  GPIOA    : CONSTANT RegisterAddress8 := 16#12#;
  GPIOB    : CONSTANT RegisterAddress8 := 16#13#;
  OLATA    : CONSTANT RegisterAddress8 := 16#14#;
  OLATB    : CONSTANT RegisterAddress8 := 16#15#;
  IOCON    : CONSTANT RegisterAddress8 := IOCONA;

  IODIR    : CONSTANT RegisterAddress16 := RegisterAddress16(IODIRA);
  IPOL     : CONSTANT RegisterAddress16 := RegisterAddress16(IPOLA);
  GPINTEN  : CONSTANT RegisterAddress16 := RegisterAddress16(GPINTENA);
  DEFVAL   : CONSTANT RegisterAddress16 := RegisterAddress16(DEFVALA);
  INTCON   : CONSTANT RegisterAddress16 := RegisterAddress16(INTCONA);
  GPPU     : CONSTANT RegisterAddress16 := RegisterAddress16(GPPUA);
  INTF     : CONSTANT RegisterAddress16 := RegisterAddress16(INTFA);
  INTCAP   : CONSTANT RegisterAddress16 := RegisterAddress16(INTCAPA);
  GPIODAT  : CONSTANT RegisterAddress16 := RegisterAddress16(GPIOA);
  GPIOLAT  : CONSTANT RegisterAddress16 := RegisterAddress16(OLATA);

  -- Read an 8-bit register

  PROCEDURE ReadRegister8
   (self  : DeviceClass;
    reg   : RegisterAddress8;
    data  : OUT RegisterData8);

  -- Write an 8-bit register

  PROCEDURE WriteRegister8
   (self  : DeviceClass;
    reg   : RegisterAddress8;
    data  : RegisterData8);

  -- Read a 16-bit register

  PROCEDURE ReadRegister16
   (self  : DeviceClass;
    reg   : RegisterAddress16;
    data  : OUT RegisterData16);

  -- Write a 16-bit register pair

  PROCEDURE WriteRegister16
   (self  : DeviceClass;
    reg   : RegisterAddress16;
    data  : RegisterData16);

  -- Complete the definition for MCP23017.DeviceClass

  TYPE DeviceClass IS TAGGED RECORD
    bus       : I2C.Bus;
    address   : I2C.Address;
  END RECORD;

END MCP23017;
