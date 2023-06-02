-- File Descriptor to Stream_Access Test

-- Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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

-- This is an experiment conducted to see what is required to obtain an
-- Ada.Streams.Stream_IO.Stream_Access (required to use the 'Read() or 'Input
-- attributes) from a Linux file descriptor returned from open().

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Command_Line;
WITH Ada.IO_Exceptions;
WITH Ada.Streams.Stream_IO.C_Streams;
WITH Interfaces.C_Streams;

WITH errno;
WITH libLinux;

USE TYPE Interfaces.C_Streams.FILEs;

PROCEDURE test_fd_to_stream IS

  Mode : CONSTANT String := "r" & ASCII.NUL;

  fd     : Integer;
  status : Integer;
  cs     : Interfaces.C_Streams.FILEs;
  f      : Ada.Streams.Stream_IO.File_Type;
  s      : Ada.Streams.Stream_IO.Stream_Access;

BEGIN
  New_Line;
  Put_Line("File Descriptor to Stream_Access Test");
  New_Line;

  IF Ada.Command_Line.Argument_count /= 1 THEN
    Put_Line("Usage: test_fd_to_stream <filename>");
    New_Line;
    RETURN;
  END IF;

  -- Open a data file, yielding a Posix file descriptor

  libLinux.OpenRead(Ada.Command_Line.Argument(1) & ASCII.NUL, fd, status);

  IF status /= 0 THEN
    RAISE Ada.IO_Exceptions.Name_Error WITH "OpenRead() failed, " &
      errno.strerror(status);
  END IF;

  -- Transform the Posix file descriptor to a C stream aka FILE *

  cs := Interfaces.C_Streams.fdopen(fd, Mode'Address);

  IF cs = Interfaces.C_Streams.Null_Stream THEN
    RAISE Ada.IO_Exceptions.Device_Error WITH "fdopen() failed, " &
      errno.strerror(errno.Get);
  END IF;

  -- Transform the C stream to File_Type

  Ada.Streams.Stream_IO.C_Streams.Open(f, Ada.Streams.Stream_IO.In_File, cs);

  -- Transform the File_Type to Stream_Access

  s := Ada.Streams.Stream_IO.Stream(f);

  -- Read data from the stream.  The only way to deal with end of file appears
  -- to be to read one character at a time, and catch End_Error.

  LOOP
    BEGIN
      Put(Character'Input(s));
    EXCEPTION
      WHEN Ada.IO_Exceptions.End_Error => EXIT;

      PRAGMA Warnings(Off, "useless handler contains only a reraise statement");

      WHEN OTHERS => RAISE;
    END;
  END LOOP;

  -- Close the Ada file.  This appears to close both the C stream and the
  -- underlying Posix file descriptor.

  Ada.Streams.Stream_IO.Close(f);
END test_fd_to_stream;
