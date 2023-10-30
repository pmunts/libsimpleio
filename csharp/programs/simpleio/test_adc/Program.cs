// ADC Input Test

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

namespace test_adc
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nADC Input Test\n");

            IO.Objects.SimpleIO.Device.Designator desg;

            Console.Write("ADC chip:       ");
            desg.chip = uint.Parse(Console.ReadLine());

            Console.Write("ADC channel:    ");
            desg.chan = uint.Parse(Console.ReadLine());

            Console.Write("ADC resolution: ");
            int resolution = int.Parse(Console.ReadLine());

            // Create ADC input object

            IO.Interfaces.ADC.Sample ADC0 =
                new IO.Objects.SimpleIO.ADC.Sample(desg, resolution);

            // Sample ADC input

            Console.WriteLine("\nPress CONTROL-C to exit\n");

            for (;;)
            {
                Console.WriteLine("Sample: " + ADC0.sample.ToString());
                System.Threading.Thread.Sleep(1000);
            }
        }
    }
}
