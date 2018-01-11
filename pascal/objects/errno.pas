{ 'Standard' errno values -- Copied from newlib /usr/include/sys/errno.h }

{ Copyright (C)2014-2018, Philip Munts, President, Munts AM Corp.             }
{                                                                             }
{ Redistribution and use in source and binary forms, with or without          }
{ modification, are permitted provided that the following conditions are met: }
{                                                                             }
{ * Redistributions of source code must retain the above copyright notice,    }
{   this list of conditions and the following disclaimer.                     }
{                                                                             }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' }
{ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   }
{ IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  }
{ ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   }
{ LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         }
{ CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        }
{ SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    }
{ INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     }
{ CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     }
{ ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  }
{ POSSIBILITY OF SUCH DAMAGE.                                                 }

UNIT errno;

INTERFACE

  CONST
    EOK     = 0;		{ Success }
    EPERM   = 1;		{ Not super-user }
    ENOENT  = 2;		{ No such file or directory }
    ESRCH   = 3;		{ No such process }
    EINTR   = 4;		{ Interrupted system call }
    EIO     = 5;		{ I/O error }
    ENXIO   = 6;		{ No such device or address }
    E2BIG   = 7;		{ Arg list too long }
    ENOEXEC = 8;		{ Exec format error }
    EBADF   = 9;		{ Bad file number }
    ECHILD  = 10;		{ No children }
    EAGAIN  = 11;		{ No more processes }
    ENOMEM  = 12;		{ Not enough core }
    EACCES  = 13;		{ Permission denied }
    EFAULT  = 14;		{ Bad address }
    ENOTBLK = 15;		{ Block device required }
    EBUSY   = 16;		{ Mount device busy }
    EEXIST  = 17;		{ File exists }
    EXDEV   = 18;		{ Cross-device link }
    ENODEV  = 19;		{ No such device }
    ENOTDIR = 20;		{ Not a directory }
    EISDIR  = 21;		{ Is a directory }
    EINVAL  = 22;		{ Invalid argument }
    ENFILE  = 23;		{ Too many open files in system }
    EMFILE  = 24;		{ Too many open files }
    ENOTTY  = 25;		{ Not a typewriter }
    ETXTBSY = 26;		{ Text file busy }
    EFBIG   = 27;		{ File too large }
    ENOSPC  = 28;		{ No space left on device }
    ESPIPE  = 29;		{ Illegal seek }
    EROFS   = 30;		{ Read only file system }
    EMLINK  = 31;		{ Too many links }
    EPIPE   = 32;		{ Broken pipe }
    EDOM    = 33;		{ Math arg out of domain of func }
    ERANGE  = 34;		{ Math result not representable }

    ECONNRESET = 104;	{ Connection reset by peer }

    FUNCTION strerror(errno : Integer) : String;

IMPLEMENTATION

  USES
    libLinux;

  FUNCTION strerror(errno : Integer) : String;

  VAR
    errbuf : ARRAY [0 .. 255] OF Char;

  BEGIN
    libLinux.StrError(errno, errbuf, 256);
    strerror := errbuf;
  END;

END.
