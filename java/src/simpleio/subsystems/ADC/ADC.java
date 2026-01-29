// Analog input services using libsimpleio

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

package com.munts.libsimpleio;

import com.munts.interfaces.ADC.*;
import com.munts.libsimpleio.bindings.libadc;
import com.munts.libsimpleio.Designator;
import com.munts.libsimpleio.errno;
import com.sun.jna.ptr.DoubleByReference;
import com.sun.jna.ptr.IntByReference;

public final class ADC
{
  private ADC()
  {
  }

  private static class SampleSubclass implements Sample
  {
    int fd;
    int numbits;

    SampleSubclass(Designator desg, int resolution)
    {
      IntByReference fd = new IntByReference();
      IntByReference error = new IntByReference();

      // Validate parameters

      if (resolution < 1)
        throw new RuntimeException("ERROR: resolution is invalid");

      // Open the ADC input device node

      libadc.ADC_open(desg.chip(), desg.channel(), fd, error);

      if (error.getValue() != errno.EOK)
        throw new RuntimeException("ERROR: ADC_open() failed, " +
          errno.strerror(error.getValue()));

      this.fd = fd.getValue();
      this.numbits = resolution;
    }

    // Analog input method returning raw sample value

    public int read()
    {
      IntByReference sample = new IntByReference();
      IntByReference error = new IntByReference();

      libadc.ADC_read(this.fd, sample, error);

      if (error.getValue() != errno.EOK)
        throw new RuntimeException("ERROR: ADC_read() failed, " +
          errno.strerror(error.getValue()));

      return sample.getValue();
    }

    // Analog input method returning the resolution

    public int resolution()
    {
      return this.numbits;
    }

    // Close the file descriptor

    public void finalize()
    {
      IntByReference error = new IntByReference();

      libadc.ADC_close(this.fd, error);

      this.fd = -1;
      this.numbits = -1;
    }
  }

  // Attempt to fetch the reference voltage for a particular analog input

  public static double Reference(Designator desg)
  {
    DoubleByReference Vref   = new DoubleByReference();
    IntByReference error     = new IntByReference();

    libadc.ADC_get_reference(desg.chip(), Vref, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: ADC_get_reference() failed, " +
        errno.strerror(error.getValue()));

    return Vref.getValue();
  }

  // Attempt to fetch the scale voltage for a particular analog input

  public static double ScaleFactor(Designator desg)
  {
    DoubleByReference Vscale = new DoubleByReference();
    IntByReference error     = new IntByReference();

    libadc.ADC_get_scale(desg.chip(), desg.channel(), Vscale, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: ADC_get_scale() failed, " +
        errno.strerror(error.getValue()));

    return Vscale.getValue();
  }

  // Create an analog sampled data input

  public static Sample Create(Designator desg, int resolution)
  {
    return new SampleSubclass(desg, resolution);
  }

  // Create an analog voltage input

  public static Voltage Create(Designator desg, int resolution,
    double reference, double gain)
  {
    return new Input(new SampleSubclass(desg, resolution), reference, gain);
  }

  // Create an analog voltage input

  public static Voltage Create(Designator desg, int resolution,
    double gain)
  {
    return new Input(new SampleSubclass(desg, resolution),
      Reference(desg), gain);
  }

  // Create a scaled analog voltage input

  public static Voltage Create(Designator desg, double gain)
  {
    return new Input(new SampleSubclass(desg, 31),
      ScaleFactor(desg)*Math.pow(2.0, 31.0), gain);
  }

  // Create a unity gain scaled analog voltage input

  public static Voltage Create(Designator desg)
  {
    return new Input(new SampleSubclass(desg, 31),
      ScaleFactor(desg)*Math.pow(2.0, 31.0), 1.0);
  }
}
