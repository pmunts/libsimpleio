-- "Standard" errno values -- Copied from newlib /usr/include/sys/errno.h

-- $Id$

-- Copyright (C)2016, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Strings.Unbounded; USE Ada.Strings.Unbounded;

PACKAGE BODY errno IS

  Messages : CONSTANT ARRAY (EOK .. ERANGE) OF Unbounded_String :=
   (To_Unbounded_String("No error"),
    To_Unbounded_String("Operation not permitted"),
    To_Unbounded_String("No such file or directory"),
    To_Unbounded_String("No such process"),
    To_Unbounded_String("Interrupted system call"),
    To_Unbounded_String("Input/output error"),
    To_Unbounded_String("No such device or address"),
    To_Unbounded_String("Argument list too long"),
    To_Unbounded_String("Exec format error"),
    To_Unbounded_String("Bad file descriptor"),
    To_Unbounded_String("No child processes"),
    To_Unbounded_String("Resource temporarily unavailable"),
    To_Unbounded_String("Cannot allocate memory"),
    To_Unbounded_String("Permission denied"),
    To_Unbounded_String("Bad address"),
    To_Unbounded_String("Block device required"),
    To_Unbounded_String("Device or resource busy"),
    To_Unbounded_String("File exists"),
    To_Unbounded_String("Invalid cross-device link"),
    To_Unbounded_String("No such device"),
    To_Unbounded_String("Not a directory"),
    To_Unbounded_String("Is a directory"),
    To_Unbounded_String("Invalid argument"),
    To_Unbounded_String("Too many open files in system"),
    To_Unbounded_String("Too many open files"),
    To_Unbounded_String("Inappropriate ioctl for device"),
    To_Unbounded_String("Text file busy"),
    To_Unbounded_String("File too large"),
    To_Unbounded_String("No space left on device"),
    To_Unbounded_String("Illegal seek"),
    To_Unbounded_String("Read-only file system"),
    To_Unbounded_String("Too many links"),
    To_Unbounded_String("Broken pipe"),
    To_Unbounded_String("Numerical argument out of domain"),
    To_Unbounded_String("Numerical result out of range"));

  FUNCTION strerror(errno : Integer) RETURN String IS

  BEGIN
    IF errno >= EOK AND errno <= ERANGE THEN
      RETURN To_String(Messages(errno));
    ELSE
      RETURN "errno=" & Integer'IMAGE(errno);
    END IF;
  END strerror;

END errno;
