// Remote I/O Grove Temperature Sensor (thermistor) Test

// Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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

using static System.Console;
using static System.Threading.Thread;

namespace test_grove_temperature
{
    class Program
    {
        static void Main()
        {
            WriteLine("\nRemote I/O Grove Temperature Sensor (thermistor) Test\n");

            // Get ADC hardware parameters

            var desg = new IO.Objects.SimpleIO.Device.Designator("Enter ADC channel:    ");

            Write("Enter ADC resolution: ");
            int resolution = int.Parse(ReadLine());

            Write("Enter ADC reference:  ");
            double reference = double.Parse(ReadLine());

            WriteLine();

            // Create objects

            IO.Interfaces.ADC.Sample S =
                new IO.Objects.SimpleIO.ADC.Sample(desg, resolution);

            IO.Interfaces.ADC.Input V = new IO.Interfaces.ADC.Input(S, reference);

            IO.Devices.Grove.Temperature.Device T =
                new IO.Devices.Grove.Temperature.Device(V);

            for (;;)
            {
                WriteLine("Temperature => " + T.Celsius.ToString("F2"));
                Sleep(1000);
            }
        }
    }
}
