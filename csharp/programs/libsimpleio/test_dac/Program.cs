// DAC output test using libsimpleio

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

namespace test_dac
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nDAC Output Test using libsimpleio\n");

            IO.Objects.libsimpleio.Device.Designator desg;

            Console.Write("DAC chip:       ");
            desg.chip = uint.Parse(Console.ReadLine());

            Console.Write("DAC channel:    ");
            desg.chan = uint.Parse(Console.ReadLine());

            Console.Write("DAC resolution: ");
            int resolution = int.Parse(Console.ReadLine());

            // Create DAC output object

            IO.Interfaces.DAC.Sample DAC0 =
                new IO.Objects.libsimpleio.DAC.Sample(desg, resolution);

            // Generate sawtooth wave

            Console.WriteLine("\nPress CONTROL-C to exit");

            for (;;)
            {
                int n;

                for (n = 0; n < (1 << resolution) - 1; n++)
                    DAC0.sample = n;
            }
        }
    }
}
