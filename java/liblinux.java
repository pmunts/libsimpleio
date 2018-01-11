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

public class liblinux
{
  // syslog option constants (extracted from syslog.h)

  public static final int LOG_PID      = 0x0001; // log the pid with each message
  public static final int LOG_CONS     = 0x0002; // log on the console if errors in sending
  public static final int LOG_ODELAY   = 0x0004; // delay open until first syslog() (default)
  public static final int LOG_NDELAY   = 0x0008; // don't delay open
  public static final int LOG_NOWAIT   = 0x0010; // don't wait for console forks: DEPRECATED
  public static final int LOG_PERROR   = 0x0020; // log to stderr as well

  // syslog facility constants (extracted from syslog.h)

  public static final int LOG_KERN     = 0x0000;
  public static final int LOG_USER     = 0x0008;
  public static final int LOG_MAIL     = 0x0010;
  public static final int LOG_DAEMON   = 0x0018;
  public static final int LOG_AUTH     = 0x0020;
  public static final int LOG_SYSLOG   = 0x0028;
  public static final int LOG_LPR      = 0x0030;
  public static final int LOG_NEWS     = 0x0038;
  public static final int LOG_UUCP     = 0x0040;
  public static final int LOG_CRON     = 0x0048;
  public static final int LOG_AUTHPRIV = 0x0050;
  public static final int LOG_FTP      = 0x0058;
  public static final int LOG_LOCAL0   = 0x0080;
  public static final int LOG_LOCAL1   = 0x0088;
  public static final int LOG_LOCAL2   = 0x0090;
  public static final int LOG_LOCAL3   = 0x0098;
  public static final int LOG_LOCAL4   = 0x00A0;
  public static final int LOG_LOCAL5   = 0x00A8;
  public static final int LOG_LOCAL6   = 0x00B0;
  public static final int LOG_LOCAL7   = 0x00B8;

  // syslog priority constants (extracted from syslog.h)

  public static final int LOG_EMERG    = 0; // system is unusable
  public static final int LOG_ALERT    = 1; // action must be taken immediately
  public static final int LOG_CRIT     = 2; // critical conditions
  public static final int LOG_ERR      = 3; // error conditions
  public static final int LOG_WARNING  = 4; // warning conditions
  public static final int LOG_NOTICE   = 5; // normal but significant condition
  public static final int LOG_INFO     = 6; // informational
  public static final int LOG_DEBUG    = 7; // debug-level messages

  // Linux system function definitions

  public static native void LINUX_detach(IntByReference error);

  public static native void LINUX_drop_privileges(String username,
    IntByReference error);

  public static native void LINUX_openlog(String ident, int options,
    int facility, IntByReference error);

  public static native void LINUX_syslog(int priority, String message,
    IntByReference error);

  public static native void LINUX_strerror(int error, byte[] buf, int size);

  // Bind to libsimpleio.so

  static
  {
    Native.register("simpleio");
  }
}
