// Remote I/O Analog Input Test

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
using System.Collections;

namespace test_adc
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nRemote I/O Analog Input Test\n");

            IO.Objects.RemoteIO.Device remdev = new IO.Objects.RemoteIO.Device();

            Console.Write("Channels:    ");

            foreach (int input in remdev.ADC_Available())
                Console.Write(" " + input.ToString());

            Console.WriteLine();

            ArrayList S = new ArrayList();

            foreach (int c in remdev.ADC_Available())
                S.Add(new IO.Objects.RemoteIO.ADC(remdev, c));

            Console.Write("Resolutions: ");

            foreach (IO.Interfaces.ADC.Sample inp in S)
                Console.Write(" " + inp.resolution.ToString());

            Console.WriteLine();

            for (;;)
            {
                Console.Write("Samples:     ");

                foreach (IO.Interfaces.ADC.Sample inp in S)
                    Console.Write(String.Format(" {0:00000}", inp.sample));

                Console.WriteLine();
                System.Threading.Thread.Sleep(2000);
            }
        }
    }
}
