// Watchdog Timer Test

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

namespace test_watchdog
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nWatchdog Timer Test\n");

            // Create watchdog timer object

            IO.Interfaces.Watchdog.Timer wd =
                new IO.Objects.libsimpleio.Watchdog.Timer("/dev/watchdog");

            // Display default watchdog timer period

            Console.WriteLine("Default period: " + wd.timeout.ToString());

            // Change the watchdog timer period to 5 seconds

            wd.timeout = 5;
            Console.WriteLine("New period:   " + wd.timeout.ToString());

            // Kick the dog for 5 seconds

            int i;

            for (i = 0; i < 5; i++)
            {
                Console.WriteLine("Kick the dog...");
                wd.Kick();

                System.Threading.Thread.Sleep(1000);
            }

            // Stop kicking the dog

            for (i = 0; i < 5; i++)
            {
                Console.WriteLine("Don't kick the dog...");

                System.Threading.Thread.Sleep(1000);
            }
        }
    }
}
