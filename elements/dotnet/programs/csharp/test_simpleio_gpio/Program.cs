// GPIO pin toggle test using libsimpleio

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

namespace test_gpio
{
    class Program
    {
        static void Main(string[] args)
        {
            IO.Objects.libsimpleio.Device.Designator desg;

            Console.WriteLine("\nGPIO Pin Toggle Test using libsimpleio\n");

            // Create GPIO pin object

            Console.Write("GPIO chip number?    ");
            desg.chip = uint.Parse(Console.ReadLine());

            Console.Write("GPIO channel number? ");
            desg.chan = uint.Parse(Console.ReadLine());

            IO.Interfaces.GPIO.Pin Output =
                new IO.Objects.libsimpleio.GPIO.Pin(desg,
                    IO.Interfaces.GPIO.Direction.Output, false);

            // Toggle the GPIO output

            Console.WriteLine("\nPress CONTROL-C to exit");

            for (;;)
                Output.state = !Output.state;
        }
    }
}
