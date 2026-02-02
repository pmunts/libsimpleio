// Copyright (C)2026, Philip Munts dba Munts Technologies.
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

package com.munts.common;

import com.munts.interfaces.Servo.Output;

public final class Servo
{
  private Servo()
  {
  }

  private static class OutputSubclass implements Output
  {
    com.munts.interfaces.PWM.Output pwmout;
    double period;   // seconds
    double swing;    // seconds
    double midpoint; // seconds

    OutputSubclass(com.munts.interfaces.PWM.Output pwmout,
      int frequency, double position, double minwidth, double maxwidth)
    {
      // Validate parameters

      if (pwmout == null)
        throw new RuntimeException("ERROR: pwmout is null.");

      if (frequency < 50)
        throw new RuntimeException("ERROR: frequency is out of range.");

      if ((position < Output.MIN_POSITION) ||
          (position > Output.MAX_POSITION))
        throw new RuntimeException("ERROR: position is out of range.");

      this.pwmout   = pwmout;
      this.period   = 1.0/frequency;
      this.swing    = (maxwidth - minwidth)/2.0;
      this.midpoint = minwidth + swing;

      this.write(position);
    }

    public void write(double position)
    {
      // Validate parameters

      if ((position < Output.MIN_POSITION) ||
          (position > Output.MAX_POSITION))
        throw new RuntimeException("ERROR: position is out of range.");

      double ontime = this.midpoint + this.swing*position;
      this.pwmout.write(ontime/this.period*100.0);
    }
  }

  // Configure a servo output

  public static Output Create(com.munts.interfaces.PWM.Output pwmout,
    int frequency, double position, double minwidth, double maxwidth)
  {
    return new OutputSubclass(pwmout, frequency, position, minwidth, maxwidth);
  }

  // Configure a servo output with default neutral position, minwidth and
  // maxwidth parameters

  public static Output Create(com.munts.interfaces.PWM.Output pwmout,
    int frequency)
  {
    return new OutputSubclass(pwmout, frequency, Output.NEUTRAL_POSITION,
      1.0E-3, 2.0E-3);
  }
}
