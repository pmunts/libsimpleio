// mikroBUS PWM Output Test

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

namespace test_mikrobus_pwm
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nmikroBUS PWM Output Test\n");

            // Get mikroBUS socket number

            Console.Write("Socket number?       ");
            var num = int.Parse(Console.ReadLine());

            Console.Write("PWM pulse frequency? ");
            var freq = int.Parse(Console.ReadLine());

            // Create objects

            var socket = new IO.Objects.RemoteIO.mikroBUS.Socket(num);
            var remdev = new IO.Objects.RemoteIO.Device();
            IO.Interfaces.PWM.Output outp = remdev.PWM_Create(socket.PWMOut, freq);

            // Sweep PWM output pulse width

            for (;;)
            {
                for (double d = 0; d <= 100; d++)
                {
                  outp.dutycycle = d;
                  System.Threading.Thread.Sleep(20);
                }

                for (double d = 100; d >= 0; d--)
                {
                  outp.dutycycle = d;
                  System.Threading.Thread.Sleep(20);
                }
            }
        }
    }
}
