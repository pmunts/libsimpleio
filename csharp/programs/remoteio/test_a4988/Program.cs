// Test a stepper motor driven with an Allegro A4988 Stepper Motor Driver.

// Copyright (C)2021-2025, Philip Munts dba Munts Technologies.
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

namespace test_a4988
{
    class Program
    {
        static void Main()
        {
            Console.WriteLine("\nA4988 Stepper Motor Driver Test\n");

            var remdev = new IO.Objects.RemoteIO.Device();

            // Get the number of descrete steps the motor under test has

            Console.Write("Number of steps?             ");
            int numsteps = int.Parse(Console.ReadLine());

            // Create STEP signal GPIO pin object

            Console.Write("STEP signal GPIO pin number? ");

            IO.Interfaces.GPIO.Pin Step_Pin =
                new IO.Objects.RemoteIO.GPIO(remdev, int.Parse(Console.ReadLine()),
                IO.Interfaces.GPIO.Direction.Output);

            // Create DIR signal GPIO pin object

            Console.Write("DIR signal GPIO pin number?  ");

            IO.Interfaces.GPIO.Pin Dir_Pin =
                new IO.Objects.RemoteIO.GPIO(remdev, int.Parse(Console.ReadLine()),
                IO.Interfaces.GPIO.Direction.Output);

            Console.WriteLine();

            // Create A4988 device object

            IO.Interfaces.Stepper.Output outp =
                new IO.Devices.A4988.Device(numsteps, Step_Pin, Dir_Pin);

            for (;;)
            {
                Console.Write("Steps? ");
                int steps = int.Parse(Console.ReadLine());

                Console.Write("Rate?  ");
                float rate = float.Parse(Console.ReadLine());

                outp.Move(steps, rate);
            }
        }
    }
}
