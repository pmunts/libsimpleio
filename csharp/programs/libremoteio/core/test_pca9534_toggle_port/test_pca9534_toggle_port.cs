// PCA9534 GPIO Port Toggle Test

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

namespace test_pca9534_toggle_port
{
  class Program
  {
    static void Main(string[] args)
    {
      Console.WriteLine("\nUSB HID Remote I/O PCA9534 GPIO Port Toggle Test\n");

      IO.Remote.Device remdev =
        new IO.Remote.Device(new IO.Objects.USB.HID.Messenger());

      IO.Interfaces.I2C.Bus bus = new IO.Remote.I2C(remdev, 0);

      IO.Devices.PCA9534.Device dev = new IO.Devices.PCA9534.Device(bus, 0x27,
        IO.Devices.PCA9534.Device.AllOutputs);

      for (;;)
      {
        dev.Write(0x55);
        dev.Write(0xAA);
      }
    }
  }
}
