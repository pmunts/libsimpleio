{ "Standard" errno values -- Copied from newlib /usr/include/sys/errno.h }

{ Copyright (C)2019-2020, Philip Munts, President, Munts AM Corp.             }
{                                                                             }
{ Redistribution and use in source and binary forms, with or without          }
{ modification, are permitted provided that the following conditions are met: }
{                                                                             }
{ * Redistributions of source code must retain the above copyright notice,    }
{   this list of conditions and the following disclaimer.                     }
{                                                                             }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" }
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

namespace errno;

interface

  const
    EOK     = 0;	{ Success }
    EPERM   = 1;	{ Not super-user }
    ENOENT  = 2;	{ No such file or directory }
    ESRCH   = 3;	{ No such process }
    EINTR   = 4;	{ Interrupted system call }
    EIO     = 5;	{ I/O error }
    ENXIO   = 6;	{ No such device or address }
    E2BIG   = 7;	{ Arg list too long }
    ENOEXEC = 8;	{ Exec format error }
    EBADF   = 9;	{ Bad file number }
    ECHILD  = 10;	{ No children }
    EAGAIN  = 11;	{ No more processes }
    ENOMEM  = 12;	{ Not enough core }
    EACCES  = 13;	{ Permission denied }
    EFAULT  = 14;	{ Bad address }
    ENOTBLK = 15;	{ Block device required }
    EBUSY   = 16;	{ Mount device busy }
    EEXIST  = 17;	{ File exists }
    EXDEV   = 18;	{ Cross-device link }
    ENODEV  = 19;	{ No such device }
    ENOTDIR = 20;	{ Not a directory }
    EISDIR  = 21;	{ Is a directory }
    EINVAL  = 22;	{ Invalid argument }
    ENFILE  = 23;	{ Too many open files in system }
    EMFILE  = 24;	{ Too many open files }
    ENOTTY  = 25;	{ Not a typewriter }
    ETXTBSY = 26;	{ Text file busy }
    EFBIG   = 27;	{ File too large }
    ENOSPC  = 28;	{ No space left on device }
    ESPIPE  = 29;	{ Illegal seek }
    EROFS   = 30;	{ Read only file system }
    EMLINK  = 31;	{ Too many links }
    EPIPE   = 32;	{ Broken pipe }
    EDOM    = 33;	{ Math arg out of domain of func }
    ERANGE  = 34;	{ Math result not representable }

    ECONNRESET = 104;	{ Connection reset by peer }

  function strerror(errno : Integer) : String;

implementation

  function strerror(errno : Integer) : String;

  begin
    case errno of
      EOK        : strerror := 'Success';
      EPERM      : strerror := 'Operation not permitted';
      ENOENT     : strerror := 'No such file or directory';
      ESRCH      : strerror := 'No such process';
      EINTR      : strerror := 'Interrupted system call';
      EIO        : strerror := 'Input/output error';
      ENXIO      : strerror := 'Device not configured';
      E2BIG      : strerror := 'Argument list too long';
      ENOEXEC    : strerror := 'Exec format error';
      EBADF      : strerror := 'Bad file descriptor';
      ECHILD     : strerror := 'No child processes';
      EAGAIN     : strerror := 'Resource deadlock avoided';
      ENOMEM     : strerror := 'Cannot allocate memory';
      EACCES     : strerror := 'Permission denied';
      EFAULT     : strerror := 'Bad address';
      ENOTBLK    : strerror := 'Block device required';
      EBUSY      : strerror := 'Resource busy';
      EEXIST     : strerror := 'File exists';
      EXDEV      : strerror := 'Cross-device link';
      ENODEV     : strerror := 'No such device';
      ENOTDIR    : strerror := 'Not a directory';
      EISDIR     : strerror := 'Is a directory';
      EINVAL     : strerror := 'Invalid argument';
      ENFILE     : strerror := 'Too many open files in system';
      EMFILE     : strerror := 'Too many open files';
      ENOTTY     : strerror := 'Inappropriate ioctl for device';
      ETXTBSY    : strerror := 'Text file busy';
      EFBIG      : strerror := 'File too large';
      ENOSPC     : strerror := 'No space left on device';
      ESPIPE     : strerror := 'Illegal seek';
      EROFS      : strerror := 'Read-only file system';
      EMLINK     : strerror := 'Too many links';
      EPIPE      : strerror := 'Broken pipe';
      EDOM       : strerror := 'Numerical argument out of domain';
      ERANGE     : strerror := 'Result too large';
      ECONNRESET : strerror := 'Connection reset by peer';
    else
      strerror := 'Error number ' + errno.ToString();
    end;
  end;

end.
