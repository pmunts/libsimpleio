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

-- Modbus (output) holding registers are READ/WRITE or possibly WRITE ONLY

GENERIC

  TYPE Quantity IS DIGITS <>;

PACKAGE Modbus.OutputShortFloat IS

  TYPE OutputClass IS TAGGED PRIVATE;
  TYPE Output      IS ACCESS ALL OutputClass'Class;

  Destroyed : CONSTANT OutputClass;

  -- Analog output constructor

  FUNCTION Create
   (cont  : Bus;
    slave : Natural;
    addr  : Natural;
    state : Quantity;
    order : ShortFloatByteOrder := ABCD) RETURN Output;

  -- Analog output initializer

  PROCEDURE Initialize
   (Self  : IN OUT OutputClass;
    cont  : Bus;
    slave : Natural;
    addr  : Natural;
    state : Quantity;
    order : ShortFloatByteOrder := ABCD);

  -- Analog output destructor

  PROCEDURE Destroy(Self : IN OUT OutputClass);

  -- Analog output methods

  FUNCTION Get(Self : IN OUT OutputClass) RETURN Quantity;

  PROCEDURE Put
   (Self  : IN OUT OutputClass;
    state : Quantity);

PRIVATE

  -- Check whether analog output has been destroyed

  PROCEDURE CheckDestroyed(Self : OutputClass);

  TYPE OutputClass IS TAGGED RECORD
    ctx   : libModbus.Context   := libModbus.Null_Context;
    slave : Natural             := Natural'Last;
    addr  : Natural             := Natural'Last;
    order : ShortFloatByteOrder := ShortFloatByteOrder'Last;
  END RECORD;

  Destroyed : CONSTANT OutputClass := OutputClass'(libModbus.Null_Context,
    Natural'Last, Natural'Last, ShortFloatByteOrder'Last);

END ModBus.OutputShortFloat;
