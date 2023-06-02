-- Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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

WITH IO_Interfaces;

PACKAGE Modbus.InputRegisters IS

  TYPE RegisterData IS MOD 2**16;

  PACKAGE Interfaces IS NEW IO_Interfaces(RegisterData);

  TYPE RegisterClass IS NEW Interfaces.InputInterface WITH PRIVATE;

  TYPE Register IS ACCESS ALL RegisterClass'Class;

  Destroyed : CONSTANT RegisterClass;

  -- Input register constructor

  FUNCTION Create
   (cont  : Bus;
    slave : Natural;
    addr  : Natural) RETURN Register;

  -- Input register initializer

  PROCEDURE Initialize
   (Self  : IN OUT RegisterClass;
    cont  : Bus;
    slave : Natural;
    addr  : Natural);

  -- Input register destructor

  PROCEDURE Destroy(Self : IN OUT RegisterClass);

  -- Input register methods

  FUNCTION Get(Self : IN OUT RegisterClass) RETURN RegisterData;

PRIVATE

  -- Check whether input register has been destroyed

  PROCEDURE CheckDestroyed(Self : RegisterClass);

  TYPE RegisterClass IS NEW Interfaces.InputInterface WITH RECORD
    ctx   : libModbus.Context := libModbus.Null_Context;
    slave : Natural           := Natural'Last;
    addr  : Natural           := Natural'Last;
  END RECORD;

  Destroyed : CONSTANT RegisterClass := RegisterClass'(libModbus.Null_Context,
    Natural'Last, Natural'Last);

END ModBus.InputRegisters;
