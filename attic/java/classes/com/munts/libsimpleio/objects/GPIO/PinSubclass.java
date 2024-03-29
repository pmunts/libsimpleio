// GPIO services using libsimpleio

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

package com.munts.libsimpleio.objects.GPIO;

import com.munts.interfaces.GPIO.*;
import com.munts.libsimpleio.bindings.libgpio;
import com.munts.libsimpleio.objects.errno;
import com.sun.jna.ptr.IntByReference;

public class PinSubclass implements Pin
{
  private int fd;
  private enum Kinds { input, output, interrupt };
  private Kinds kind;

  // GPIO pin object constructors

  public PinSubclass(Builder b)
  {
    IntByReference error = new IntByReference();
    IntByReference fd = new IntByReference();

    // Open the GPIO pin device

    libgpio.GPIO_line_open(b.chip, b.line, b.flags, b.events, b.state,
      fd, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: GPIO_line_open() failed, " +
        errno.strerror(error.getValue()));

    this.fd = fd.getValue();

    if ((b.flags & libgpio.LINE_REQUEST_OUTPUT) != 0)
      this.kind = Kinds.output;
    else if (b.events == libgpio.EVENT_REQUEST_NONE)
      this.kind = Kinds.input;
    else
      this.kind = Kinds.interrupt;
  }

  public boolean read()
  {
    IntByReference state = new IntByReference();
    IntByReference error = new IntByReference();

    if (this.kind == Kinds.interrupt)
    {
      libgpio.GPIO_line_event(this.fd, state, error);

      if (error.getValue() != errno.EOK)
        throw new RuntimeException("ERROR: GPIO_line_event() failed, " +
          errno.strerror(error.getValue()));
    }
    else
    {
      libgpio.GPIO_line_read(this.fd, state, error);

      if (error.getValue() != errno.EOK)
        throw new RuntimeException("ERROR: GPIO_line_read() failed, " +
          errno.strerror(error.getValue()));
    }

    return (state.getValue() == 1 ? true : false);
  }

  public void write(boolean state)
  {
    if (this.kind != Kinds.output)
      throw new RuntimeException("ERROR: Cannot write to input pin");

    IntByReference error = new IntByReference();

    libgpio.GPIO_line_write(this.fd, (state ? 1 : 0), error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: GPIO_line_write() failed, " +
        errno.strerror(error.getValue()));
  }

  public void finalize()
  {
    IntByReference error = new IntByReference();

    libgpio.GPIO_line_close(this.fd, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: GPIO_line_close() failed, " +
        errno.strerror(error.getValue()));

    this.fd = -1;
  }
}
