// Remote I/O GPIO Button and LED Test

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

namespace test_gpio_button_led
{
    class Program
    {
        static void Main()
        {
            Console.WriteLine("\nRemote I/O GPIO Button and LED Test\n");

            var remdev = new IO.Objects.RemoteIO.Device();

            // Configure LED output

            IO.Interfaces.GPIO.Pin LD1 =
                new IO.Objects.RemoteIO.GPIO(remdev, 0, IO.Interfaces.GPIO.Direction.Output);

            // Configure button input

            IO.Interfaces.GPIO.Pin SW1 =
                new IO.Objects.RemoteIO.GPIO(remdev, 1, IO.Interfaces.GPIO.Direction.Input);

            bool OldState = !SW1.state;
            bool NewState = OldState;

            // Read the button and write the LED

            for (;;)
            {
                NewState = SW1.state;

                if (NewState != OldState)
                {
                    if (NewState)
                    {
                        Console.WriteLine("PRESSED");
                        LD1.state = true;
                    }
                    else
                    {
                        Console.WriteLine("RELEASED");
                        LD1.state = false;
                    }

                    OldState = NewState;
                }

                System.Threading.Thread.Sleep(100);
            }
        }
    }
}
