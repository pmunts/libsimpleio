// Remote I/O Grove Temperature Sensor (thermistor) Test

// Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

namespace test_grove_temperature
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nRemote I/O Grove Temperature Sensor (thermistor) Test\n");

            IO.Objects.USB.HID.Messenger m = new IO.Objects.USB.HID.Messenger();

            IO.Remote.Device dev = new IO.Remote.Device(m);

            IO.Interfaces.ADC.Sample S = new IO.Remote.ADC(dev, 0);

            IO.Interfaces.ADC.Input inp = new IO.Interfaces.ADC.Input(S, 3.3);

            for (;;)
            {
                Console.WriteLine("Voltage => " + inp.voltage.ToString("F2"));
                System.Threading.Thread.Sleep(1000);
            }
        }
    }
}
