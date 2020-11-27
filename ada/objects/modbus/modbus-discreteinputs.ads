-- Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

-- Modbus discrete inputs are READ ONLY

WITH GPIO;

PACKAGE Modbus.DiscreteInputs IS

  TYPE PinSubclass IS NEW GPIO.PinInterface WITH PRIVATE;

  Destroyed : CONSTANT PinSubclass;

  -- GPIO pin constructor

  FUNCTION Create
   (cont  : Bus;
    slave : Natural;
    addr  : Natural) RETURN GPIO.Pin;

  -- GPIO pin initializer

  PROCEDURE Initialize
   (Self  : IN OUT PinSubclass;
    cont  : Bus;
    slave : Natural;
    addr  : Natural);

  -- GPIO pin object destructor

  PROCEDURE Destroy(Self : IN OUT PinSubclass);

  -- GPIO pin methods

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean;

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean);

PRIVATE

  -- Check whether GPIO pin object has been destroyed

  PROCEDURE CheckDestroyed(Self : PinSubclass);

  TYPE PinSubclass IS NEW GPIO.PinInterface WITH RECORD
    ctx   : libModbus.Context := libModbus.Null_Context;
    slave : Natural           := Natural'Last;
    addr  : Natural           := Natural'Last;
  END RECORD;

  Destroyed : CONSTANT PinSubclass := PinSubclass'(libModbus.Null_Context,
    Natural'Last, Natural'Last);

END ModBus.DiscreteInputs;
