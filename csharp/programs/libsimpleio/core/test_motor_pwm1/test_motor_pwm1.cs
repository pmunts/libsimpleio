// Motor output test using PWM (speed) and GPIO (direction) outputs

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
using System.Threading;

namespace test_motor_pwm1
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nMotor Output Test using libsimpleio\n");

            Console.Write("GPIO chip number:    ");
            uint gpiochip = uint.Parse(Console.ReadLine());

            Console.Write("GPIO line number:    ");
            uint gpioline = uint.Parse(Console.ReadLine());

            Console.Write("PWM chip:            ");
            int pwmchip = int.Parse(Console.ReadLine());

            Console.Write("PWM channel:         ");
            int pwmchan = int.Parse(Console.ReadLine());

            // Create GPIO pin object

            IO.Interfaces.GPIO.Pin GPIO0 =
              new IO.Objects.libsimpleio.GPIO.Pin(gpiochip, gpioline,
                IO.Interfaces.GPIO.Direction.Output);

            // Create PWM output object

            IO.Interfaces.PWM.Output PWM0 =
              new IO.Objects.libsimpleio.PWM.Output(pwmchip, pwmchan, 100);

            // Create motor object

            IO.Interfaces.Motor.Output Motor0 =
              new IO.Objects.Motor.PWM.Output(GPIO0, PWM0);

            // Sweep motor velocity up and down

            Console.WriteLine("\nPress CONTROL-C to exit");

            for (;;)
            {
                int n;

                for (n = -100; n < 100; n++)
                {
                    Motor0.velocity = n / 100.0;
                    Thread.Sleep(50);
                }

                for (n = 100; n >= -100; n--)
                {
                    Motor0.velocity = n / 100.0;
                    Thread.Sleep(50);
                }
            }
        }
    }
}
