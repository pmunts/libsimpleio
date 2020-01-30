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

-- Modbus input registers are READ ONLY

GENERIC

  TYPE Quantity IS DIGITS <>;

PACKAGE Modbus.InputShortFloat IS

  TYPE InputClass IS TAGGED PRIVATE;
  TYPE Input      IS ACCESS ALL InputClass'Class;

  Destroyed : CONSTANT InputClass;

  -- Analog input constructor

  FUNCTION Create
   (cont  : Bus;
    slave : Natural;
    addr  : Natural;
    order : ShortFloatByteOrder := ABCD) RETURN Input;

  -- Analog input initializer

  PROCEDURE Initialize
   (Self  : IN OUT InputClass;
    cont  : Bus;
    slave : Natural;
    addr  : Natural;
    order : ShortFloatByteOrder := ABCD);

  -- Analog input destructor

  PROCEDURE Destroy(Self : IN OUT InputClass);

  -- Analog input methods

  FUNCTION Get(Self : IN OUT InputClass) RETURN Quantity;

PRIVATE

  -- Check whether analog input has been destroyed

  PROCEDURE CheckDestroyed(Self : InputClass);

  TYPE InputClass IS TAGGED RECORD
    ctx   : libModbus.Context   := libModbus.Null_Context;
    slave : Natural             := Natural'Last;
    addr  : Natural             := Natural'Last;
    order : ShortFloatByteOrder := ShortFloatByteOrder'Last;
  END RECORD;

  Destroyed : CONSTANT InputClass := InputClass'(libModbus.Null_Context,
    Natural'Last, Natural'Last, ShortFloatByteOrder'Last);

END ModBus.InputShortFloat;
