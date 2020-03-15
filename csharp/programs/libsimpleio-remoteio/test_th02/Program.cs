// Remote I/O TH02 Temperature/Humidity Sensor Test

// Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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

namespace test_th02
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nRemote I/O TH02 Temperature/Humidity Sensor Test\n");

            IO.Interfaces.Message64.Messenger msg =
                new IO.Objects.libsimpleio.HID.Messenger();

            IO.Remote.Device remdev = new IO.Remote.Device(msg);

            IO.Interfaces.I2C.Bus bus = new IO.Remote.I2C(remdev, 0);

            IO.Devices.TH02.Device dev = new IO.Devices.TH02.Device(bus);

            Console.WriteLine("Device ID: 0x" + dev.DeviceID.ToString("X2"));
            Console.WriteLine();

            for (;;)
            {
                Console.Write("Temperature: " + dev.Celsius.ToString("F1"));
                Console.Write("  ");
                Console.Write("Humidity: " + dev.Humidity.ToString("F1"));
                Console.WriteLine();

                System.Threading.Thread.Sleep(1000);
            }
        }
    }
}
