-- Run shell command(s) from an Ada program

-- Copyright (C)2024, Philip Munts dba Munts Technologies.
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

PRIVATE WITH System;

PACKAGE External_Command.Pipeline IS

  TYPE Pipe IS TAGGED PRIVATE;

  -- Open pipe to read from another program

  PROCEDURE OpenInput(Self : IN OUT Pipe; cmd : String);

  -- Open pipe to write to another program

  PROCEDURE OpenOutput(Self : IN OUT Pipe; cmd : String);

  -- Close pipe

  PROCEDURE Close(Self : IN OUT Pipe);

  -- Read string from pipe

  FUNCTION Get(Self : Pipe) RETURN String;

  -- Write string to pipe

  PROCEDURE Put(Self : Pipe; s : String);

  -- Write line to pipe

  PROCEDURE Put_Line(Self : Pipe; s : String);

PRIVATE

  TYPE Kind IS (Uninitialized, Input, Output);

  TYPE Pipe IS TAGGED RECORD
    myfile : System.Address := System.Null_Address;
    mykind : Kind           := Uninitialized;
  END RECORD;

  Destroyed : CONSTANT Pipe := Pipe'(System.Null_Address, Uninitialized);

END External_Command.Pipeline;
