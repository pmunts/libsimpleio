-- Abstract GPIB (aka HPIB aka IEEE-488) bus controller interface definitions

-- Copyright (C)2023, Philip Munts.
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

PACKAGE GPIB IS

  Error : EXCEPTION;

  TYPE Address             IS NEW Natural RANGE 0 .. 30;

  TYPE Byte                IS MOD 256;
  TYPE ByteArray           IS ARRAY (Natural RANGE <>) OF Byte;

  TYPE ControllerInterface IS INTERFACE;
  TYPE Controller          IS ACCESS ALL ControllerInterface'Class;

  -- Select a particular slave device for the next operation(s)

  PROCEDURE SelectSlave(Self : IN OUT ControllerInterface; slave : Address) IS ABSTRACT;

  -- Issue a text command to the most recently selected IEEE-488 slave device

  PROCEDURE Put(Self : IN OUT ControllerInterface; cmd : String) IS ABSTRACT;

  -- Fetch a text response from the most recently selected IEEE-488 slave device

  FUNCTION Get(Self : IN OUT ControllerInterface) RETURN String IS ABSTRACT;

  -- Issue Device Clear (DCL) command to the most recently selected IEEE-488 slave device

  PROCEDURE Clear(Self : IN OUT ControllerInterface) IS ABSTRACT;

  -- TODO: Added binary Get and Put methods

END GPIB;
