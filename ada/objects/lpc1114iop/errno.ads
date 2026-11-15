-- "Standard" errno values -- Copied from newlib /usr/include/sys/errno.h

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

WITH Interfaces.C.Strings;

PACKAGE errno IS
  EOK     : CONSTANT := 0;	-- Success
  EPERM   : CONSTANT := 1;	-- Not super-user
  ENOENT  : CONSTANT := 2;	-- No such file or directory
  ESRCH   : CONSTANT := 3;	-- No such process
  EINTR   : CONSTANT := 4;	-- Interrupted system call
  EIO     : CONSTANT := 5;	-- I/O error
  ENXIO   : CONSTANT := 6;	-- No such device or address
  E2BIG   : CONSTANT := 7;	-- Arg list too long
  ENOEXEC : CONSTANT := 8;	-- Exec format error
  EBADF   : CONSTANT := 9;	-- Bad file number
  ECHILD  : CONSTANT := 10;	-- No children
  EAGAIN  : CONSTANT := 11;	-- No more processes
  ENOMEM  : CONSTANT := 12;	-- Not enough core
  EACCES  : CONSTANT := 13;	-- Permission denied
  EFAULT  : CONSTANT := 14;	-- Bad address
  ENOTBLK : CONSTANT := 15;	-- Block device required
  EBUSY   : CONSTANT := 16;	-- Mount device busy
  EEXIST  : CONSTANT := 17;	-- File exists
  EXDEV   : CONSTANT := 18;	-- Cross-device link
  ENODEV  : CONSTANT := 19;	-- No such device
  ENOTDIR : CONSTANT := 20;	-- Not a directory
  EISDIR  : CONSTANT := 21;	-- Is a directory
  EINVAL  : CONSTANT := 22;	-- Invalid argument
  ENFILE  : CONSTANT := 23;	-- Too many open files in system
  EMFILE  : CONSTANT := 24;	-- Too many open files
  ENOTTY  : CONSTANT := 25;	-- Not a typewriter
  ETXTBSY : CONSTANT := 26;	-- Text file busy
  EFBIG   : CONSTANT := 27;	-- File too large
  ENOSPC  : CONSTANT := 28;	-- No space left on device
  ESPIPE  : CONSTANT := 29;	-- Illegal seek
  EROFS   : CONSTANT := 30;	-- Read only file system
  EMLINK  : CONSTANT := 31;	-- Too many links
  EPIPE   : CONSTANT := 32;	-- Broken pipe
  EDOM    : CONSTANT := 33;	-- Math arg out of domain of func
  ERANGE  : CONSTANT := 34;	-- Math result not representable

  ECONNRESET : CONSTANT := 104; -- Connection reset by peer

  -- Binding to C standard library strerror()

  FUNCTION libc_strerror(error : Integer) RETURN Interfaces.C.Strings.chars_ptr;
    PRAGMA Import (C, libc_strerror, "strerror");

  -- Fetch the error message associated with an errno value

  FUNCTION strerror(error : Integer) RETURN String IS
   (Interfaces.C.Strings.Value(libc_strerror(error)));

  -- Get the current errno value

  FUNCTION Get RETURN Integer;
    PRAGMA Import(C, Get, "__get_errno");

END errno;
