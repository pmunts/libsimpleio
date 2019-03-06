// DAC output test using libsimpleio

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
using System.Collections;

namespace test_dac
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nDAC Output Test using libsimpleio\n");

            IO.Interfaces.Message64.Messenger m =
              new IO.Objects.libsimpleio.HID.Messenger();

            IO.Remote.Device dev = new IO.Remote.Device(m);

            Console.Write("Channels:    ");

            foreach (int output in dev.DAC_Available())
                Console.Write(" " + output.ToString());

            Console.WriteLine();

            ArrayList S = new ArrayList();

            foreach (int c in dev.DAC_Available())
                S.Add(new IO.Remote.DAC(dev, c));

            Console.Write("Resolutions: ");

            foreach (IO.Interfaces.DAC.Sample output in S)
                Console.Write(" " + output.resolution.ToString());

            Console.WriteLine();

            for (;;)
            {
                int n;

                for (n = 0; n < 4096; n++)
                    foreach (IO.Interfaces.DAC.Sample output in S)
                        output.sample = n;
            }
        }
    }
}
