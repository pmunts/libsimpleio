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

import com.munts.libsimpleio.bindings.libgpio;
import com.munts.interfaces.GPIO.Direction;
import com.munts.libsimpleio.objects.errno;
import com.sun.jna.ptr.IntByReference;

public class Pin implements com.munts.interfaces.GPIO.Pin
{
  private int fd;

  // GPIO pin object constructor

  public Pin(int pin, Direction dir, boolean state)
  {
    IntByReference error = new IntByReference();
    IntByReference fd = new IntByReference();

    // Configure the GPIO pin

    libgpio.GPIO_configure(pin, dir.ordinal(), (state ? 1 : 0), libgpio.NONE,
      libgpio.ACTIVEHIGH, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: GPIO_configure() failed, " +
        errno.strerror(error.getValue()));

    // Open the GPIO pin device node

    libgpio.GPIO_open(pin, fd, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: GPIO_open() failed, " +
        errno.strerror(error.getValue()));

    this.fd = fd.getValue();
  }

  public void write(boolean state)
  {
    IntByReference error = new IntByReference();

    libgpio.GPIO_write(this.fd, (state ? 1 : 0), error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: GPIO_write() failed, " +
        errno.strerror(error.getValue()));
  }

  public boolean read()
  {
    IntByReference state = new IntByReference();
    IntByReference error = new IntByReference();

    libgpio.GPIO_read(this.fd, state, error);

    if (error.getValue() != errno.EOK)
      throw new RuntimeException("ERROR: GPIO_read() failed, " +
        errno.strerror(error.getValue()));

    return (state.getValue() == 1 ? true : false);
  }

  public void finalize()
  {
    IntByReference error = new IntByReference();

    libgpio.GPIO_close(this.fd, error);

    this.fd = -1;
  }
}
