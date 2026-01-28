// PWM (Pulse Width Modulated) output services using libsimpleio

// Copyright (C)2017-2026, Philip Munts dba Munts Technologies.
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

package com.munts.libsimpleio.objects.PWM;

import com.munts.interfaces.PWM.Output;
import com.munts.libsimpleio.bindings.libpwm;
import com.munts.libsimpleio.objects.Designator;
import com.munts.libsimpleio.objects.errno;
import com.sun.jna.ptr.IntByReference;

public class OutputSubclass implements Output
{
  private int fd;
  private int period;

  // PWM output object constructor

  public OutputSubclass(Designator desg, int frequency,
    double dutycycle, int polarity)
  {
    int ontime;
    IntByReference fd = new IntByReference();
    IntByReference error = new IntByReference();

    // Validate parameters

    if (frequency < 1)
      throw new RuntimeException("ERROR: frequency is invalid");

    if ((dutycycle < 0.0) || (dutycycle > 100.0))
      throw new RuntimeException("ERROR: Invalid duty cycle parameter");

    if ((polarity < libpwm.ACTIVELOW) || (polarity > libpwm.ACTIVEHIGH))
      throw new RuntimeException("ERROR: Invalid polarity parameter");

    // Calculate the period

    this.period = (int) Math.round(1.0E9/frequency);

    // Calculate the initial on time in nanoseconds

    ontime = (int) Math.round(dutycycle/100.0*this.period);

    // Configure the PWM output

    libpwm.PWM_configure(desg.chip(), desg.channel(), this.period, ontime,
      polarity, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: PWM_configure() failed, " +
        errno.strerror(error.getValue()));

    // Open the PWM output device node

    libpwm.PWM_open(desg.chip(), desg.channel(), fd, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: PWM_open() failed, " +
        errno.strerror(error.getValue()));

    this.fd = fd.getValue();
  }

  // PWM output object constructor with default polarity

  public OutputSubclass(Designator desg, int frequency, double dutycycle)
  {
    int ontime;
    IntByReference fd = new IntByReference();
    IntByReference error = new IntByReference();

    // Validate parameters

    if (frequency < 1)
      throw new RuntimeException("ERROR: frequency is invalid");

    if ((dutycycle < 0.0) || (dutycycle > 100.0))
      throw new RuntimeException("ERROR: Invalid duty cycle parameter");

    // Calculate the period

    this.period = (int) Math.round(1.0E9/frequency);

    // Calculate the initial on time in nanoseconds

    ontime = (int) Math.round(dutycycle/100.0*this.period);

    // Configure the PWM output

    libpwm.PWM_configure(desg.chip(), desg.channel(), this.period, ontime, libpwm.ACTIVEHIGH,
      error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: PWM_configure() failed, " +
        errno.strerror(error.getValue()));

    // Open the PWM output device node

    libpwm.PWM_open(desg.chip(), desg.channel(), fd, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: PWM_open() failed, " +
        errno.strerror(error.getValue()));

    this.fd = fd.getValue();
  }

  // PWM output object constructor with default polarity and duty cycle

  public OutputSubclass(Designator desg, int frequency)
  {
    IntByReference fd = new IntByReference();
    IntByReference error = new IntByReference();

    // Validate parameters

    if (frequency < 1)
      throw new RuntimeException("ERROR: frequency is invalid");

    this.period = (int) Math.round(1.0E9/frequency);

    // Configure the PWM output

    libpwm.PWM_configure(desg.chip(), desg.channel(), this.period, 0,
      libpwm.ACTIVEHIGH, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: PWM_configure() failed, " +
        errno.strerror(error.getValue()));

    // Open the PWM output device node

    libpwm.PWM_open(desg.chip(), desg.channel(), fd, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: PWM_open() failed, " +
        errno.strerror(error.getValue()));

    this.fd = fd.getValue();
  }

  public void write(double dutycycle)
  {
    int ontime;
    IntByReference error = new IntByReference();

    ontime = (int) Math.round(dutycycle/100.0*this.period);

    libpwm.PWM_write(this.fd, ontime, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: PWM_write() failed, " +
        errno.strerror(error.getValue()));
  }

  public void finalize()
  {
    IntByReference error = new IntByReference();

    libpwm.PWM_close(this.fd, error);

    this.fd = -1;
  }
}
