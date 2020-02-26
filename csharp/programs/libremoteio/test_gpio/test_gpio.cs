// GPIO pin toggle test using libremoteio

// Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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
            Console.WriteLine("\nGPIO Pin Toggle Test\n");

            IO.Objects.USB.HID.Messenger m = new IO.Objects.USB.HID.Messenger();
            IO.Remote.Device d = new IO.Remote.Device(m);

            // Create GPIO pin object

            Console.Write("GPIO channel number? ");

            IO.Interfaces.GPIO.Pin Output =
              new IO.Remote.GPIO(d, int.Parse(Console.ReadLine()),
                IO.Interfaces.GPIO.Direction.Output);

            // Toggle the GPIO output

            Console.WriteLine("\nPress CONTROL-C to exit");

            for (;;)
                Output.state = !Output.state;
        }
    }
}