// Remote I/O Servo Output Test

// Copyright (C)2018-2025, Philip Munts dba Munts Technologies.
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

namespace test_servo
{
    class Program
    {
        static void Main()
        {
            Console.WriteLine("\nRemote I/O Servo Output Test\n");

            var remdev = new IO.Objects.RemoteIO.Device();

            Console.Write("Channels:");

            foreach (int output in remdev.PWM_Available())
                Console.Write(" " + output.ToString());

            Console.WriteLine();

            ArrayList S = new ArrayList();

            foreach (int c in remdev.PWM_Available())
                S.Add(new IO.Objects.Servo.PWM.Output(new IO.Objects.RemoteIO.PWM(remdev, c, 50), 50));

            for (;;)
            {
                int n;

                for (n = -300; n <= 300; n++)
                    foreach (IO.Interfaces.Servo.Output output in S)
                        output.position = n / 300.0;

                for (n = 300; n >= -300; n--)
                    foreach (IO.Interfaces.Servo.Output output in S)
                        output.position = n / 300.0;
            }
        }
    }
}
