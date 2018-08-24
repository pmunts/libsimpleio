// PCA9685 Servo Output Test

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

namespace test_pca9685_servo
{
  class Program
  {
    static void Main(string[] args)
    {
      Console.WriteLine("\nPCA9685 Servo Output Test\n");

      // Create servo output object

      IO.Interfaces.I2C.Bus bus =
        new IO.Objects.libsimpleio.I2C.Bus("/dev/i2c-1");

      IO.Devices.PCA9685.Device dev =
        new IO.Devices.PCA9685.Device(bus, 0x40, 100);

      IO.Interfaces.Servo.Output Servo0 =
        new IO.Devices.PCA9685.Servo.Output(dev, 0);

      // Sweep servo position back and forth

      Console.WriteLine("\nPress CONTROL-C to exit");

      for (;;)
      {
        int n;

        for (n = -100; n < 100; n++)
        {
          Servo0.position = n/100.0;
          System.Threading.Thread.Sleep(50);
        }

        for (n = 100; n >= -100; n--)
        {
          Servo0.position = n/100.0;
          System.Threading.Thread.Sleep(50);
        }
      }
    }
  }
}
