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

PACKAGE BODY errno IS

  FUNCTION strerror(error : Integer) RETURN String IS

  BEGIN
    CASE error IS
      WHEN EOK        => RETURN "Success";
      WHEN EPERM      => RETURN "Operation not permitted";
      WHEN ENOENT     => RETURN "No such file or directory";
      WHEN ESRCH      => RETURN "No such process";
      WHEN EINTR      => RETURN "Interrupted system call";
      WHEN EIO        => RETURN "Input/output error";
      WHEN ENXIO      => RETURN "Device not configured";
      WHEN E2BIG      => RETURN "Argument list too long";
      WHEN ENOEXEC    => RETURN "Exec format error";
      WHEN EBADF      => RETURN "Bad file descriptor";
      WHEN ECHILD     => RETURN "No child processes";
      WHEN EAGAIN     => RETURN "Resource deadlock avoided";
      WHEN ENOMEM     => RETURN "Cannot allocate memory";
      WHEN EACCES     => RETURN "Permission denied";
      WHEN EFAULT     => RETURN "Bad address";
      WHEN ENOTBLK    => RETURN "Block device required";
      WHEN EBUSY      => RETURN "Resource busy";
      WHEN EEXIST     => RETURN "File exists";
      WHEN EXDEV      => RETURN "Cross-device link";
      WHEN ENODEV     => RETURN "No such device";
      WHEN ENOTDIR    => RETURN "Not a directory";
      WHEN EISDIR     => RETURN "Is a directory";
      WHEN EINVAL     => RETURN "Invalid argument";
      WHEN ENFILE     => RETURN "Too many open files in system";
      WHEN EMFILE     => RETURN "Too many open files";
      WHEN ENOTTY     => RETURN "Inappropriate ioctl for device";
      WHEN ETXTBSY    => RETURN "Text file busy";
      WHEN EFBIG      => RETURN "File too large";
      WHEN ENOSPC     => RETURN "No space left on device";
      WHEN ESPIPE     => RETURN "Illegal seek";
      WHEN EROFS      => RETURN "Read-only file system";
      WHEN EMLINK     => RETURN "Too many links";
      WHEN EPIPE      => RETURN "Broken pipe";
      WHEN EDOM       => RETURN "Numerical argument out of domain";
      WHEN ERANGE     => RETURN "Result too large";
      WHEN ECONNRESET => RETURN "Connection reset by peer";
      WHEN OTHERS     => RETURN "Error number" & Integer'Image(error);
    END CASE;
  END strerror;

END errno;
