// "Standard" errno values -- Copied from newlib /usr/include/sys/errno.h

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

package com.munts.libsimpleio.objects;

import com.munts.libsimpleio.bindings.liblinux;

public class errno
{
  public static final int EOK		= 0;
  public static final int EPERM		= 1;
  public static final int ENOENT	= 2;
  public static final int ESRCH		= 3;
  public static final int EINTR		= 4;
  public static final int EIO		= 5;
  public static final int ENXIO		= 6;
  public static final int E2BIG		= 7;
  public static final int ENOEXEC	= 8;
  public static final int EBADF		= 9;
  public static final int ECHILD	= 10;
  public static final int EAGAIN	= 11;
  public static final int ENOMEM	= 12;
  public static final int EACCES	= 13;
  public static final int EFAULT	= 14;
  public static final int ENOTBLK	= 15;
  public static final int EBUSY		= 16;
  public static final int EEXIST	= 17;
  public static final int EXDEV		= 18;
  public static final int ENODEV	= 19;
  public static final int ENOTDIR	= 20;
  public static final int EISDIR	= 21;
  public static final int EINVAL	= 22;
  public static final int ENFILE	= 23;
  public static final int EMFILE	= 24;
  public static final int ENOTTY	= 25;
  public static final int ETXTBSY	= 26;
  public static final int EFBIG		= 27;
  public static final int ENOSPC	= 28;
  public static final int ESPIPE	= 29;
  public static final int EROFS		= 30;
  public static final int EMLINK	= 31;
  public static final int EPIPE		= 32;
  public static final int EDOM		= 33;
  public static final int ERANGE	= 34;
  public static final int ECONNRESET	= 104;

  // Fetch error message for a particular errno value

  public static final String strerror(int errno)
  {
    byte[] buf = new byte[256];

    liblinux.LINUX_strerror(errno, buf, buf.length);

    String s = new String(buf);

    return s.trim();
  }
}
