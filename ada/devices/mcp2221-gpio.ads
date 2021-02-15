-- MCP2221 GPIO Pin Services

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

WITH GPIO;

PACKAGE MCP2221.GPIO IS

  TYPE PinSubclass IS NEW Standard.GPIO.PinInterface WITH PRIVATE;

  -- GPIO pin constructor

  FUNCTION Create
   (dev       : NOT NULL Device;
    num       : PinNumber;
    direction : Standard.GPIO.Direction;
    state     : Boolean := False) RETURN Standard.GPIO.Pin;

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean);

PRIVATE

  TYPE PinSubclass IS NEW Standard.GPIO.PinInterface WITH RECORD
    dev   : DeviceClass;
    num   : PinNumber;
    dir   : Standard.GPIO.Direction;
    latch : Boolean;
  END RECORD;

END MCP2221.GPIO;
