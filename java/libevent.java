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

// This binding relies on the Java Native Access library, available from:
//
// https://github.com/java-native-access/jna

package com.munts.libsimpleio;

import com.sun.jna.*;
import com.sun.jna.ptr.*;

public class libevent
{
  // epoll events, extracted from /usr/include/sys/epoll.h

  public static final int EPOLLIN      = 0x00000001;
  public static final int EPOLLPRI     = 0x00000002;
  public static final int EPOLLOUT     = 0x00000004;
  public static final int EPOLLRDNORM  = 0x00000040;
  public static final int EPOLLRDBAND  = 0x00000080;
  public static final int EPOLLWRNORM  = 0x00000100;
  public static final int EPOLLWRBAND  = 0x00000200;
  public static final int EPOLLMSG     = 0x00000400;
  public static final int EPOLLERR     = 0x00000008;
  public static final int EPOLLHUP     = 0x00000010;
  public static final int EPOLLRDHUP   = 0x00002000;
  public static final int EPOLLWAKEUP  = 0x20000000;
  public static final int EPOLLONESHOT = 0x40000000;
  public static final int EPOLLET      = 0x80000000;

  // epoll function definitions

  public static native void EVENT_open(IntByReference epfd,
    IntByReference error);

  public static native void EVENT_register_fd(int epfd, int fd, int events,
    int handle, IntByReference error);

  public static native void EVENT_modify_fd(int epfd, int fd, int events,
    int handle, IntByReference error);

  public static native void EVENT_unregister_fd(int epfd, int fd,
    IntByReferenceerror);

  public static native void EVENT_wait(int epfd, IntByReference fd,
    IntByReference event, IntByReference handle, int timeoutms,
    IntByReference error);

  public static native void EVENT_close(int fd, IntByReference error);

  // Bind to libsimpleio.so

  static
  {
    Native.register("simpleio");
  }
}

