// ADC device services using libsimpleio

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

package com.munts.libsimpleio.objects.ADC;

import com.munts.libsimpleio.bindings.libadc;
import com.munts.libsimpleio.objects.errno;
import com.munts.libsimpleio.objects.Designator;
import com.sun.jna.ptr.DoubleByReference;
import com.sun.jna.ptr.IntByReference;

public final class Device
{
  private Device()
  {
  }

  public static double ReferenceVoltage(Designator desg)
  {
    DoubleByReference Vref   = new DoubleByReference();
    IntByReference error     = new IntByReference();

    libadc.ADC_get_reference(desg.chip(), Vref, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: ADC_get_reference() failed, " +
        errno.strerror(error.getValue()));

    return Vref.getValue();
  }

  public static double ScaleVoltage(Designator desg)
  {
    DoubleByReference Vscale = new DoubleByReference();
    IntByReference error     = new IntByReference();

    libadc.ADC_get_scale(desg.chip(), desg.channel(), Vscale, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: ADC_get_scale() failed, " +
        errno.strerror(error.getValue()));

    return Vscale.getValue();
  }
}
