-- MCP23x17 GPIO pin services

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

WITH GPIO;

USE TYPE GPIO.Direction;
USE TYPE GPIO.Pin;

PACKAGE BODY MCP23x17.GPIO IS

  PinMasks : CONSTANT ARRAY (PinNumber) OF RegisterData16 :=
   (2**0,
    2**1,
    2**2,
    2**3,
    2**4,
    2**5,
    2**6,
    2**7,
    2**8,
    2**9,
    2**10,
    2**11,
    2**12,
    2**13,
    2**14,
    2**15);

  -- GPIO pin constructor

  FUNCTION Create
   (device    : NOT NULL MCP23x17.Device;
    number    : PinNumber;
    direction : Standard.GPIO.Direction;
    state     : Boolean := False;
    pullup    : Boolean := False) RETURN Standard.GPIO.Pin IS

    data : RegisterData16;

  BEGIN

    -- Configure output latch state

    device.ReadRegister16(GPIOLAT, data);

    IF state THEN
      data := data OR PinMasks(number);
    ELSE
      data := data AND NOT PinMasks(number);
    END IF;

    device.WriteRegister16(GPIOLAT, data);

    -- Configure pullup resistor

    device.ReadRegister16(GPPU, data);

    IF pullup THEN
      data := data OR PinMasks(number);
    ELSE
      data := data AND NOT PinMasks(number);
    END IF;

    device.WriteRegister16(GPPU, data);

    -- Configure data direction

    device.ReadRegister16(IODIR, data);

    IF direction = Standard.GPIO.Input THEN
      data := data OR PinMasks(number);
    ELSE
      data := data AND NOT PinMasks(number);
    END IF;

    device.WriteRegister16(IODIR, data);

    RETURN NEW PinSubclass'(device, number);
  END Create;

  -- GPIO read method

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean IS

    data : RegisterData16;

  BEGIN
    Self.device.ReadRegister16(GPIODAT, data);
    RETURN (data AND PinMasks(Self.number)) /= 0;
  END Get;

  -- GPIO write method

  PROCEDURE Put(Self : IN OUT PinSubclass; state: Boolean) IS

    data : RegisterData16;

  BEGIN
    Self.device.ReadRegister16(GPIOLAT, data);

    IF state THEN
      data := data OR PinMasks(Self.number);
    ELSE
      data := data AND NOT PinMasks(Self.number);
    END IF;

    Self.device.WriteRegister16(GPIOLAT, data);
  END Put;

END MCP23x17.GPIO;
