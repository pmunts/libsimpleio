-- Run an external command

-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH GNAT.OS_Lib;

PACKAGE BODY External_Command IS

  -- Run an external command.
  -- Raise Error if the command fails.

  PROCEDURE Run(cmd : String) IS

    exitcode : Integer;

  BEGIN
    exitcode := Run(cmd);

    IF exitcode /= 0 THEN
      RAISE Error WITH "Command failed with exit code" & Integer'Image(exitcode);
    END IF;
  END Run;

  -- Run an external command.
  -- Return exit code.

  FUNCTION Run(cmd : String) RETURN Integer IS

    args     : GNAT.OS_Lib.Argument_List_Access;
    exitcode : Integer;

  BEGIN
    args     := GNAT.OS_Lib.Argument_String_To_List(cmd);
    exitcode := GNAT.OS_Lib.Spawn(args(1).ALL, args(2 .. args'Length));

    GNAT.OS_Lib.Free(args);
    RETURN exitcode;
  END Run;

END External_Command;
