// Servo Output Test

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

namespace test_servo_pwm
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nServo Output Test\n");

            IO.Objects.SimpleIO.Device.Designator desg;

            Console.Write("PWM chip:            ");
            desg.chip = uint.Parse(Console.ReadLine());

            Console.Write("PWM channel:         ");
            desg.chan = uint.Parse(Console.ReadLine());

            // Create PWM output object

            IO.Interfaces.PWM.Output PWM0 =
                new IO.Objects.SimpleIO.PWM.Output(desg, 50);

            // Create servo output object

            IO.Interfaces.Servo.Output Servo0 =
                new IO.Objects.Servo.PWM.Output(PWM0, 50);

            // Sweep servo position back and forth

            Console.WriteLine("\nPress CONTROL-C to exit");

            for (;;)
            {
                int n;

                for (n = -100; n < 100; n++)
                {
                    Servo0.position = n / 100.0;
                    System.Threading.Thread.Sleep(50);
                }

                for (n = 100; n >= -100; n--)
                {
                    Servo0.position = n / 100.0;
                    System.Threading.Thread.Sleep(50);
                }
            }
        }
    }
}
