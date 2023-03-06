// "Standard" errno values -- Copied from newlib /usr/include/sys/errno.h

// Copyright (C)2020, Philip Munts, President, Munts AM Corp.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

/// <summary>
/// Define Unix <c>errno</c> values and services.
/// </summary>
public static class errno
{
  /// <summary>
  /// No error.
  /// </summary>
  public const int EOK = 0;

  /// <summary>
  /// Operation not permitted.
  /// </summary>
  public const int EPERM = 1;

  /// <summary>
  /// No such file or directory.
  /// </summary>
  public const int ENOENT = 2;

  /// <summary>
  /// No such process.
  /// </summary>
  public const int ESRCH = 3;

  /// <summary>
  /// Interrupted system call.
  /// </summary>
  public const int EINTR = 4;

  /// <summary>
  /// Input/output error.
  /// </summary>
  public const int EIO = 5;

  /// <summary>
  /// No such device or address.
  /// </summary>
  public const int ENXIO = 6;

  /// <summary>
  /// Argument list too long.
  /// </summary>
  public const int E2BIG = 7;

  /// <summary>
  /// Exec format error.
  /// </summary>
  public const int ENOEXEC = 8;

  /// <summary>
  /// Bad file descriptor.
  /// </summary>
  public const int EBADF = 9;

  /// <summary>
  /// No child processes.
  /// </summary>
  public const int ECHILD = 10;

  /// <summary>
  /// Resource temporarily unavailable.
  /// </summary>
  public const int EAGAIN = 11;

  /// <summary>
  /// Cannot allocate memory.
  /// </summary>
  public const int ENOMEM = 12;

  /// <summary>
  /// Permission denied.
  /// </summary>
  public const int EACCES = 13;

  /// <summary>
  /// Bad address.
  /// </summary>
  public const int EFAULT = 14;

  /// <summary>
  /// Block device required.
  /// </summary>
  public const int ENOTBLK = 15;

  /// <summary>
  /// Device or resource busy.
  /// </summary>
  public const int EBUSY = 16;

  /// <summary>
  /// File exists.
  /// </summary>
  public const int EEXIST = 17;

  /// <summary>
  /// Invalid cross-device link.
  /// </summary>
  public const int EXDEV = 18;

  /// <summary>
  /// No such device.
  /// </summary>
  public const int ENODEV = 19;

  /// <summary>
  /// Not a directory.
  /// </summary>
  public const int ENOTDIR = 20;

  /// <summary>
  /// Is a directory.
  /// </summary>
  public const int EISDIR = 21;

  /// <summary>
  /// Invalid argument.
  /// </summary>
  public const int EINVAL = 22;

  /// <summary>
  /// Too many open files in system.
  /// </summary>
  public const int ENFILE = 23;

  /// <summary>
  /// Too many open files.
  /// </summary>
  public const int EMFILE = 24;

  /// <summary>
  /// Inappropriate ioctl for device.
  /// </summary>
  public const int ENOTTY = 25;

  /// <summary>
  /// Text file busy.
  /// </summary>
  public const int ETXTBSY = 26;

  /// <summary>
  /// File too large.
  /// </summary>
  public const int EFBIG = 27;

  /// <summary>
  /// No space left on device.
  /// </summary>
  public const int ENOSPC = 28;

  /// <summary>
  /// Illegal seek.
  /// </summary>
  public const int ESPIPE = 29;

  /// <summary>
  /// Read-only file system.
  /// </summary>
  public const int EROFS = 30;

  /// <summary>
  /// Too many links.
  /// </summary>
  public const int EMLINK = 31;

  /// <summary>
  /// Broken pipe.
  /// </summary>
  public const int EPIPE = 32;

  /// <summary>
  /// Numerical argument out of domain.
  /// </summary>
  public const int EDOM = 33;

  /// <summary>
  /// Numerical result out of range.
  /// </summary>
  public const int ERANGE = 34;

  /// <summary>
  /// Connection reset by peer.
  /// </summary>
  public const int ECONNRESET = 104;

  /// <summary>
  /// Return the error message text for a given <c>errno</c> value.
  /// </summary>
  /// <param name="errno">Unix <c>errno</c> value.</param>
  /// <returns>Error message string.</returns>
  public static string strerror(int errno)
  {
    switch (errno)
    {
      case EOK        : return "No error";
      case EPERM      : return "Operation not permitted";
      case ENOENT     : return "No such file or directory";
      case ESRCH      : return "No such process";
      case EINTR      : return "Interrupted system call";
      case EIO        : return "Input/output error";
      case ENXIO      : return "No such device or address";
      case E2BIG      : return "Argument list too long";
      case ENOEXEC    : return "Exec format error";
      case EBADF      : return "Bad file descriptor";
      case ECHILD     : return "No child processes";
      case EAGAIN     : return "Resource temporarily unavailable";
      case ENOMEM     : return "Cannot allocate memory";
      case EACCES     : return "Permission denied";
      case EFAULT     : return "Bad address";
      case ENOTBLK    : return "Block device required";
      case EBUSY      : return "Device or resource busy";
      case EEXIST     : return "File exists";
      case EXDEV      : return "Invalid cross-device link";
      case ENODEV     : return "No such device";
      case ENOTDIR    : return "Not a directory";
      case EISDIR     : return "Is a directory";
      case EINVAL     : return "Invalid argument";
      case ENFILE     : return "Too many open files in system";
      case EMFILE     : return "Too many open files";
      case ENOTTY     : return "Inappropriate ioctl for device";
      case ETXTBSY    : return "Text file busy";
      case EFBIG      : return "File too large";
      case ENOSPC     : return "No space left on device";
      case ESPIPE     : return "Illegal seek";
      case EROFS      : return "Read-only file system";
      case EMLINK     : return "Too many links";
      case EPIPE      : return "Broken pipe";
      case EDOM       : return "Numerical argument out of domain";
      case ERANGE     : return "Numerical result out of range";
      case ECONNRESET : return "Connection reset by peer";
      default         : return "Error number " + errno.ToString();
    }
  }
}
