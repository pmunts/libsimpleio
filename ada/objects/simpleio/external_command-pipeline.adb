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

WITH errno;
WITH libLinux;

PACKAGE BODY External_Command.Pipeline IS

  -- Bind to some libc functions

  FUNCTION fileno(file : System.Address) RETURN Integer;
    PRAGMA Import(C, fileno, "fileno");

  -- Open pipe to read from another program

  PROCEDURE OpenInput(Self : IN OUT Pipe; cmd : String) IS

    errnum : Integer;

  BEGIN
    IF Self /= Destroyed THEN
      RAISE Error WITH "ERROR: Pipe is already open";
    END IF;

    libLinux.POpenRead(cmd & ASCII.NUL, Self.myfile, errnum);

    IF errnum /= 0 THEN
      Self := Destroyed;

      RAISE Error WITH "ERROR: POpenRead failed, " &
        errno.strerror(errnum);
    END IF;

    Self.mykind := Input;
  END OpenInput;

  -- Open pipe to write to another program

  PROCEDURE OpenOutput(Self : IN OUT Pipe; cmd : String) IS

    errnum : Integer;

  BEGIN
    IF Self /= Destroyed THEN
      RAISE Error WITH "ERROR: Pipe is already open";
    END IF;

    libLinux.POpenWrite(cmd & ASCII.NUL, Self.myfile, errnum);

    IF errnum /= 0 THEN
      Self := Destroyed;

      RAISE Error WITH "ERROR: POpenWrite failed, " &
        errno.strerror(errnum);
    END IF;

    Self.mykind := Output;
  END OpenOutput;

  -- Close pipe

  PROCEDURE Close(Self : IN OUT Pipe) IS

    errnum : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RAISE Error WITH "ERROR: Pipe is not open";
    END IF;

    libLinux.PClose(Self.myfile, errnum);

    Self := Destroyed;

    IF errnum /= 0 THEN
      RAISE Error WITH "ERROR: Pipe close operation failed, " &
        errno.strerror(errnum);
    END IF;
  END Close;

  -- Read string from pipe

  FUNCTION Get(Self : Pipe) RETURN String IS

  BEGIN

    -- Validate parameters

    IF Self = Destroyed THEN
      RAISE Error WITH "ERROR: Pipe is not open";
    END IF;

    IF Self.mykind /= Input THEN
      RAISE Error WITH "ERROR: Cannot read from input pipe";
    END IF;

    RETURN "";
  END Get;

  -- Write string to pipe

  PROCEDURE Put(Self : Pipe; s : String) IS

    count : Integer;
    errnum : Integer;

  BEGIN

    -- Validate parameters

    IF Self = Destroyed THEN
      RAISE Error WITH "ERROR: Pipe is not open";
    END IF;

    IF Self.mykind /= Output THEN
      RAISE Error WITH "ERROR: Cannot write to input pipe";
    END IF;

    -- Write to the pipe

    libLinux.Write(fileno(Self.myfile), s'Address, s'Length, count, errnum);

    -- Handle errnums

    IF count /= s'Length THEN
      RAISE Error WITH "ERROR: short write";
    END IF;

    IF errnum /= 0 THEN
      RAISE Error WITH "ERROR: Write operation failed, " &
        errno.strerror(errnum);
    END IF;
  END Put;

  -- Write line to pipe

  PROCEDURE Put_Line(Self : Pipe; s : String) IS

  BEGIN
    Self.Put(s & ASCII.LF);
  END Put_Line;

END External_Command.Pipeline;
