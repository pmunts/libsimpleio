// Remote I/O PCA8574 GPIO Pin Toggle Test

// Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

using System;

namespace test_remoteio_pca8574_toggle_pin
{
  class Program
  {
    static void Main(string[] args)
    {
      Console.WriteLine("\nUSB HID Remote I/O PCA8574 GPIO Pin Toggle Test\n");

      IO.Interfaces.Message64.Messenger msg =
        new IO.Objects.libsimpleio.HID.Messenger();

      IO.Remote.Device remdev = new IO.Remote.Device(msg);

      IO.Interfaces.I2C.Bus bus = new IO.Remote.I2C(remdev, 0);

      IO.Devices.PCA8574.Device dev = new IO.Devices.PCA8574.Device(bus, 0x38);

      IO.Interfaces.GPIO.Pin GPIO0 = new IO.Devices.PCA8574.Pin(dev, 0,
        IO.Interfaces.GPIO.Direction.Output, false);

      for (;;)
        GPIO0.state = !GPIO0.state;
    }
  }
}
