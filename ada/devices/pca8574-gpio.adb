-- PCA8574 GPIO pin services

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

WITH GPIO;

USE TYPE GPIO.Direction;

PACKAGE BODY PCA8574.GPIO IS

  PinMasks : CONSTANT ARRAY (PinNumber) OF PCA8574.Byte :=
    (16#01#, 16#02#, 16#04#, 16#08#, 16#10#, 16#20#, 16#40#, 16#80#);

  -- GPIO pin constructor

  FUNCTION Create
   (device    : PCA8574.Device;
    number    : PinNumber;
    direction : Standard.GPIO.Direction;
    state     : Boolean := False) RETURN Standard.GPIO.Pin IS

    p : Standard.GPIO.Pin;

  BEGIN
    p := NEW PinSubclass'(device, direction, PinMasks(number));

    IF direction = Standard.GPIO.Input THEN
      p.Put(True);
    ELSE
      p.Put(state);
    END IF;

    RETURN p;
  END Create;

  -- GPIO pin read method

  FUNCTION Get(self : IN OUT PinSubclass) RETURN Boolean IS

  BEGIN
    IF self.dir = Standard.GPIO.Input THEN
      RETURN (self.device.Get AND self.mask) /= 0;
    ELSE
      RETURN (self.device.latch AND self.mask) /= 0;
    END IF;
  END Get;

  -- GPIO pin write method

  PROCEDURE Put(self : IN OUT PinSubclass; state: Boolean) IS

  BEGIN
    IF self.dir = Standard.GPIO.Input THEN
      RAISE Standard.GPIO.GPIO_Error WITH "Cannot write to input pin";
    ELSIF state THEN
      self.device.Put(self.device.latch OR self.mask);
    ELSE
      self.device.Put(self.device.latch AND NOT self.mask);
    END IF;
  END Put;

END PCA8574.GPIO;
