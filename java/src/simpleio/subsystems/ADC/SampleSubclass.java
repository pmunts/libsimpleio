// Analog input services using libsimpleio

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

package com.munts.libsimpleio.objects.ADC;

import com.munts.interfaces.ADC.Sample;
import com.munts.libsimpleio.bindings.libadc;
import com.munts.libsimpleio.objects.errno;
import com.munts.libsimpleio.objects.Designator;
import com.sun.jna.ptr.IntByReference;

public class SampleSubclass implements Sample
{
  private int fd;
  private int numbits;

  // ADC input object constructor

  public SampleSubclass(Designator desg, int resolution)
  {
    IntByReference fd = new IntByReference();
    IntByReference error = new IntByReference();

    // Validate parameters

    if (desg.chip < 0)
      throw new RuntimeException("ERROR: chip number is invalid");

    if (desg.channel < 0)
      throw new RuntimeException("ERROR: channel number is invalid");

    if (resolution < 1)
      throw new RuntimeException("ERROR: resolution is invalid");

    // Open the ADC input device node

    libadc.ADC_open(desg.chip, desg.channel, fd, error);

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

  public void finalize()
  {
    IntByReference error = new IntByReference();

    libadc.ADC_close(this.fd, error);

    this.fd = -1;
    this.numbits = -1;
  }
}
