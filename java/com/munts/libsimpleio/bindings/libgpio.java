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

public class libgpio
{
  // Old GPIO sysfs API:

  // GPIO data direction constants

  public static final int INPUT		= 0;
  public static final int OUTPUT	= 1;

  // GPIO input interrupt edge constants

  public static final int NONE		= 0;
  public static final int RISING	= 1;
  public static final int FALLING	= 2;
  public static final int BOTH		= 3;

  // GPIO polarity constants

  public static final int ACTIVELOW	= 0;
  public static final int ACTIVEHIGH	= 1;

  // GPIO function definitions

  public static native void GPIO_configure(int pin, int dir, int state,
    int edge, int polarity, IntByReference error);

  public static native void GPIO_open(int pin, IntByReference fd,
    IntByReference error);

  public static native void GPIO_read(int fd, IntByReference state,
    IntByReference error);

  public static native void GPIO_write(int fd, int state,
    IntByReference error);

  public static native void GPIO_close(int fd, IntByReference error);

  // New GPIO descriptor API:

  public static final int LINE_INFO_KERNEL         = 0x0001;
  public static final int LINE_INFO_OUTPUT         = 0x0002;
  public static final int LINE_INFO_ACTIVE_LOW     = 0x0004;
  public static final int LINE_INFO_OPEN_DRAIN     = 0x0008;
  public static final int LINE_INFO_OPEN_SOURCE    = 0x0010;

  public static final int LINE_REQUEST_INPUT       = 0x0001;
  public static final int LINE_REQUEST_OUTPUT      = 0x0002;
  public static final int LINE_REQUEST_ACTIVE_HIGH = 0x0000;
  public static final int LINE_REQUEST_ACTIVE_LOW  = 0x0004;
  public static final int LINE_REQUEST_PUSH_PULL   = 0x0000;
  public static final int LINE_REQUEST_OPEN_DRAIN  = 0x0008;
  public static final int LINE_REQUEST_OPEN_SOURCE = 0x0010;

  public static final int EVENT_REQUEST_NONE        = 0x0000;
  public static final int EVENT_REQUEST_RISING      = 0x0001;
  public static final int EVENT_REQUEST_FALLING     = 0x0002;
  public static final int EVENT_REQUEST_BOTH        = 0x0003;

  public static native void GPIO_chip_info(int chip, byte[] name, int namelen,
    byte[] label, int labellen, IntByReference lines, IntByReference error);

  public static native void GPIO_line_info(int chip, int line,
    IntByReference flags, byte[] name, int namelen, byte[] label,
    int labellen, IntByReference error);

  public static native void GPIO_line_open(int chip, int line, int flags,
    int events, int state, IntByReference fd, IntByReference error);

  public static native void GPIO_line_close(int fd, IntByReference error);

  public static native void GPIO_line_read(int fd, IntByReference state,
    IntByReference error);

  public static native void GPIO_line_write(int fd, int state,
    IntByReference error);

  public static native void GPIO_line_event(int fd, IntByReference state,
    IntByReference error);
  
  // Bind to libsimpleio.so

  static
  {
    Native.register("simpleio");
  }
}
