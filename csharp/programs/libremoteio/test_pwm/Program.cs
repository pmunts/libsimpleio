// Remote I/O PWM Output Test

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

namespace test_pwm
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nRemote I/O PWM Output Test\n");

            IO.Remote.Device remdev =
                new IO.Remote.Device(new IO.Objects.USB.HID.Messenger());

            Console.Write("Channels:");

            foreach (int output in remdev.PWM_Available())
                Console.Write(" " + output.ToString());

            Console.WriteLine();

            ArrayList S = new ArrayList();

            foreach (int c in remdev.PWM_Available())
                S.Add(new IO.Remote.PWM(remdev, c, 1000));

            for (;;)
            {
                int n;

                for (n = 0; n < 500; n++)
                    foreach (IO.Interfaces.PWM.Output output in S)
                        output.dutycycle = n / 5.0;

                for (n = 500; n >= 0; n--)
                    foreach (IO.Interfaces.PWM.Output output in S)
                        output.dutycycle = n / 5.0;
            }
        }
    }
}
