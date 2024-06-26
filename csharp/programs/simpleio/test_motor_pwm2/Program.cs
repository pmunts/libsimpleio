// Motor Output Test Using Two PWM outputs (CW and CCW)

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

namespace test_motor_pwm2
{
    class Program
    {
        static void Main()
        {
            Console.WriteLine("\nMotor Output Test Using Two PWM outputs (CW and CCW)\n");

            var desg_CW  = new IO.Objects.SimpleIO.Device.Designator("Enter CW  PWM output channel: ");
            var desg_CCW = new IO.Objects.SimpleIO.Device.Designator("Enter CCW PWM output channel: ");

            // Create PWM output objects

            IO.Interfaces.PWM.Output PWMCW =
                new IO.Objects.SimpleIO.PWM.Output(desg_CW, 100);

            IO.Interfaces.PWM.Output PWMCCW =
                new IO.Objects.SimpleIO.PWM.Output(desg_CCW, 100);

            // Create motor object

            IO.Interfaces.Motor.Output Motor0 =
                new IO.Objects.Motor.PWM.Output(PWMCW, PWMCCW);

            // Sweep motor velocity up and down

            Console.WriteLine("\nPress CONTROL-C to exit");

            for (;;)
            {
                int n;

                for (n = -100; n < 100; n++)
                {
                    Motor0.velocity = n / 100.0;
                    System.Threading.Thread.Sleep(50);
                }

                for (n = 100; n >= -100; n--)
                {
                    Motor0.velocity = n / 100.0;
                    System.Threading.Thread.Sleep(50);
                }
            }
        }
    }
}
