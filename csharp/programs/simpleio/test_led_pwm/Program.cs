// LED Toggle Test Using PWM Output

// Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

namespace test_led_pwm
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nLED Toggle Test Using PWM Output\n");

            IO.Objects.libsimpleio.Device.Designator desg;

            Console.Write("PWM chip:              ");
            desg.chip = uint.Parse(Console.ReadLine());

            Console.Write("PWM channel:           ");
            desg.chan = uint.Parse(Console.ReadLine());

            Console.Write("PWM pulse frequency:   ");
            int freq = int.Parse(Console.ReadLine());

            Console.Write("PWM output duty cycle: ");
            double duty = double.Parse(Console.ReadLine());

            // Create PWM output object

            IO.Interfaces.PWM.Output PWM0 =
                new IO.Objects.libsimpleio.PWM.Output(desg, freq);

            // Create GPIO pin object

            IO.Interfaces.GPIO.Pin LED =
                new IO.Objects.GPIO.PWM.Pin(PWM0, false, duty);

            // Toggle the LED

            Console.WriteLine("\nPress CONTROL-C to exit");

            for (;;)
            {
                LED.state = !LED.state;
                System.Threading.Thread.Sleep(500);
            }
        }
    }
}
