// Watchdog timer services using libsimpleio

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

package com.munts.libsimpleio.objects.Watchdog;

import com.munts.interfaces.Watchdog.Timer;
import com.munts.libsimpleio.bindings.libwatchdog;
import com.munts.libsimpleio.objects.errno;
import com.sun.jna.ptr.IntByReference;

public class TimerSubclass implements Timer
{
  private int fd;

  public static final String DefaultDevice = "/dev/watchdog";
  public static final int DefaultTimeout = 0;

  // Watchdog timer object constructor

  public TimerSubclass(String devname, int timeout)
  {
    IntByReference fd = new IntByReference();
    IntByReference error = new IntByReference();
    IntByReference newtimeout = new IntByReference();

    // Open the watchdog timer device node

    libwatchdog.WATCHDOG_open(devname, fd, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: WATCHDOG_open() failed, " +
        errno.strerror(error.getValue()));

    this.fd = fd.getValue();

    // Check for initial timeout setting

    if (timeout == DefaultTimeout)
      return;

    // Change the timeout setting

    libwatchdog.WATCHDOG_set_timeout(this.fd, timeout, newtimeout, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: WATCHDOG_set_timeout() failed, " +
        errno.strerror(error.getValue()));
  }

  // Watchdog timer object constructor with default parameters

  public TimerSubclass()
  {
    IntByReference fd = new IntByReference();
    IntByReference error = new IntByReference();

    // Open the watchdog timer device node

    libwatchdog.WATCHDOG_open(DefaultDevice, fd, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: WATCHDOG_open() failed, " +
        errno.strerror(error.getValue()));

    this.fd = fd.getValue();
  }

  public int GetTimeout()
  {
    IntByReference timeout = new IntByReference();
    IntByReference error = new IntByReference();

    libwatchdog.WATCHDOG_get_timeout(this.fd, timeout, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: WATCHDOG_get_timeout() failed, " +
        errno.strerror(error.getValue()));

    return timeout.getValue();
  }

  public void SetTimeout(int timeout)
  {
    IntByReference newtimeout = new IntByReference();
    IntByReference error = new IntByReference();

    libwatchdog.WATCHDOG_set_timeout(this.fd, timeout, newtimeout, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: WATCHDOG_set_timeout() failed, " +
        errno.strerror(error.getValue()));
  }

  public void Kick()
  {
    IntByReference error = new IntByReference();

    libwatchdog.WATCHDOG_kick(this.fd, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: WATCHDOG_kick() failed, " +
        errno.strerror(error.getValue()));
  }

  public void finalize()
  {
    IntByReference error = new IntByReference();

    libwatchdog.WATCHDOG_close(this.fd, error);

    this.fd = -1;
  }
}
