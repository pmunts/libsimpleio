// PCA8574 GPIO Pin Toggle Test

// Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

namespace test_pca8574_gpio
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nPCA8574 GPIO Pin Toggle Test\n");

            if (args.Length != 2)
            {
                Console.WriteLine("Usage: test_pca8574_gpio <bus> <addr>\n");
                Environment.Exit(1);
            }

            IO.Interfaces.I2C.Bus bus =
                new IO.Objects.SimpleIO.I2C.Bus(args[0]);

            IO.Devices.PCA8574.Device dev =
                new IO.Devices.PCA8574.Device(bus, int.Parse(args[1]));

            IO.Interfaces.GPIO.Pin GPIO0 = new IO.Devices.PCA8574.GPIO.Pin(dev, 0,
                IO.Interfaces.GPIO.Direction.Output, false);

            for (;;)
                GPIO0.state = !GPIO0.state;
        }
    }
}
