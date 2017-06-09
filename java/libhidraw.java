// Copyright (C)2017, Philip Munts, President, Munts AM Corp.
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

public class libhidraw
{
  // Raw HID device function definitions

  public static native void HIDRAW_open(String name, IntByReference fd,
    IntByReference error);

  public static native void HIDRAW_open_id(int VID, int PID, IntByReference fd,
    IntByReference error);

  public static native void HIDRAW_close(int fd, IntByReference error);

  public static native void HIDRAW_get_name(int fd, byte[] buf, int size,
    IntByReference error);

  public static native void HIDRAW_get_info(int fd, IntByReference bustype,
    IntByReference vendor, IntByReference product, IntByReference error);

  public static native void HIDRAW_send(int fd, byte[] buf, int size,
    IntByReference count, IntByReference error);

  public static native void HIDRAW_receive(int fd, byte[] buf, int size,
    IntByReference count, IntByReference error);

  // Bind to libsimpleio.so

  static
  {
    Native.register("simpleio");
  }
}
