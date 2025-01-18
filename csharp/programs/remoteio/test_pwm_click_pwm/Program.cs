// Mikroelektronika PWM Click PWM Output Test

// Copyright (C)2020-2025, Philip Munts dba Munts Technologies.
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

namespace test_pwm_click_pwm
{
    class Program
    {
        static void Main()
        {
            Console.WriteLine("\nMikroelektronika PWM Click PWM Output Test\n");

            Console.Write("Socket number?       ");
            var socket = int.Parse(Console.ReadLine());

            Console.Write("Channel number?      ");
            var channel = int.Parse(Console.ReadLine());

            Console.Write("PWM pulse frequency? ");
            var freq = int.Parse(Console.ReadLine());

            var msg    = new IO.Objects.Message64.ZeroMQ.Messenger();
            var remdev = new IO.Objects.RemoteIO.Device(msg);
            var board  = new IO.Devices.ClickBoards.RemoteIO.PWM.Board(remdev, socket, freq);
            var outp   = board.PWM(channel);

            for (;;)
            {
                for (double duty = IO.Interfaces.PWM.DutyCycles.Minimum; duty <= IO.Interfaces.PWM.DutyCycles.Maximum; duty += 0.1)
                    outp.dutycycle = duty;

                for (double duty = IO.Interfaces.PWM.DutyCycles.Maximum; duty >= IO.Interfaces.PWM.DutyCycles.Minimum; duty -= 0.1)
                    outp.dutycycle = duty;
            }
        }
    }
}
