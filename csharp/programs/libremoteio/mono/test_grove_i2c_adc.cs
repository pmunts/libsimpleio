// Grove I2C A/D Converter Test

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
using System.Threading;

namespace test_grove_i2c_adc
{
  class Program
  {
    static void Main(string[] args)
    {
      Console.WriteLine("\nGrove I2C A/D Converter Test\n");

      IO.Remote.Device dev =
        new IO.Remote.Device(new IO.Objects.USB.HID.Messenger());

      IO.Interfaces.I2C.Bus bus =
        new IO.Remote.I2C(dev, 0);

      IO.Interfaces.ADC.Sample adc =
        new IO.Devices.ADC121C021.Sample(bus, 0x50);

      IO.Interfaces.ADC.Input inp =
        new IO.Interfaces.ADC.Input(adc, 3.0, 0.5);

      Console.WriteLine("Resolution: " + adc.resolution.ToString() + " bits\n");

      for (;;)
      {
        Console.WriteLine("Voltage => " + inp.voltage.ToString("F2"));
        Thread.Sleep(1000);
      }
    }
  }
}
