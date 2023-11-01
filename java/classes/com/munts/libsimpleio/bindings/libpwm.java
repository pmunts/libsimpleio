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

public class libpwm
{
  // PWM output polarity constants

  public static final int ACTIVELOW	= 0;
  public static final int ACTIVEHIGH	= 1;

  // PWM device function definitions

  public static native void PWM_configure(int chip, int channel, int period,
    int ontime, int polarity, IntByReference error);

  public static native void PWM_open(int chip, int channel, IntByReference fd,
    IntByReference error);

  public static native void PWM_close(int fd, IntByReference error);

  public static native void PWM_write(int fd, int ontime,
    IntByReference error);

  // Bind to libsimpleio.so

  static
  {
    Native.register("simpleio");
  }
}
