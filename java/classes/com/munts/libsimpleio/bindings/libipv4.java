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

package com.munts.libsimpleio.bindings;

import com.sun.jna.*;
import com.sun.jna.ptr.*;

public class libipv4
{
  public static final int INADDR_ANY       = 0;
  public static final int INADDR_LOOPBACK  = 0x7F000001;
  public static final int INADDR_BROADCAST = -1;

  public static final int MSG_DONTROUTE    = 0x0004;
  public static final int MSG_DONTWAIT     = 0x0040;
  public static final int MSG_MORE         = 0x8000;

  // These services are of questionable usefulness for Java, but are provided
  // here for completeness.

  public static native void IPV4_resolve(String name, IntByReference addr,
    IntByReference error);

  public static native void IPV4_ntoa(int addr, byte[] dst, int dstsize,
    IntByReference error);

  public static native void TCP4_connect(int addr, int port,
    IntByReference fd, IntByReference error);

  public static native void TCP4_accept(int addr, int port,
    IntByReference fd, IntByReference error);

  public static native void TCP4_server(int addr, int port,
    IntByReference fd, IntByReference error);

  public static native void TCP4_send(int fd, byte[] buf, int bufsize,
    IntByReference count, IntByReference error);

  public static native void TCP4_receive(int fd, byte[] buf, int bufsize,
    IntByReference count, IntByReference error);

  public static native void UDP4_open(int host, int port, IntByReference fd,
    IntByReference error);

  public static native void UDP4_close(int fd, IntByReference error);

  public static native void UDP4_send(int fd, int host, int port, byte[] buf,
    int bufsize, int flags, IntByReference count, IntByReference error);

  public static native void UDP4_receive(int fd, IntByReference host,
    IntByReference port, byte[] buf, int bufsize, int flags,
    IntByReference count, IntByReference error);

  // Bind to libsimpleio.so

  static
  {
    Native.register("simpleio");
  }
}
