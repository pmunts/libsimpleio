-- Simple debugging services.  Print something if the "DEBUGLEVEL" environment
-- variable is set to an integer value greater than zero.

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

WITH Ada.Text_IO;
WITH Ada.Environment_Variables;

PACKAGE BODY Debug IS

  -- Fetch the value of the DEBUGLEVEL environment variable

  FUNCTION Level RETURN Natural IS

  BEGIN
    RETURN Natural'Value(Ada.Environment_Variables.Value("DEBUGLEVEL"));
  EXCEPTION
    WHEN OTHERS =>
      RETURN 0;
  END Level;

  -- Indicate if debug is enabled

  FUNCTION Enabled RETURN Boolean IS

  BEGIN
    RETURN Level > 0;
  END Enabled;

  -- Print a string if DEBUGLEVEL > 0

  PROCEDURE Put(s : String) IS

  BEGIN
    IF Level > 0 THEN
      Ada.Text_IO.Put_Line(s);
    END IF;
  END Put;

  -- Print information about an exception if DEBUGLEVEL > 0

  PROCEDURE Put(e : Ada.Exceptions.Exception_Occurrence) IS

  BEGIN
    IF Level > 0 THEN
      Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(e));
      Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Message(e));
    END IF;
  END Put;

END Debug;
