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

PACKAGE PCA8574.GPIO IS

  TYPE PinNumber IS NEW Natural RANGE 0 .. 7;

  TYPE PinSubclass IS NEW Standard.GPIO.PinInterface WITH PRIVATE;

  -- GPIO pin constructor

  FUNCTION Create
   (device    : PCA8574.Device;
    number    : PinNumber;
    direction : Standard.GPIO.Direction;
    state     : Boolean := False) RETURN Standard.GPIO.Pin;

  -- GPIO pin read method

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean;

  -- GPIO pin write method

  PROCEDURE Put(Self : IN OUT PinSubclass; state: Boolean);

PRIVATE

  TYPE PinSubclass IS NEW Standard.GPIO.PinInterface WITH RECORD
    device : PCA8574.Device;
    dir    : Standard.GPIO.Direction;
    mask   : PCA8574.Byte;
  END RECORD;

END PCA8574.GPIO;
