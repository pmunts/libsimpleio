// USB HID Remote I/O Device Information Query Test

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

namespace test_query
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nUSB HID Remote I/O Device Information Query Test\n");

            IO.Objects.USB.HID.Messenger m = new IO.Objects.USB.HID.Messenger();
            IO.Remote.Device dev = new IO.Remote.Device(m);

            // Display some device information

            Console.WriteLine(m.Info);
            Console.WriteLine(dev.Version);
            Console.WriteLine(dev.Capabilities);
            Console.WriteLine();

            // Display the available ADC inputs

            Console.Write("ADC inputs:  ");

            foreach (int input in dev.ADC_Available())
                Console.Write(input.ToString() + " ");

            Console.WriteLine();

            // Display the available DAC outputs

            Console.Write("DAC outputs: ");

            foreach (int input in dev.DAC_Available())
                Console.Write(input.ToString() + " ");

            Console.WriteLine();

            // Display the available GPIO pins

            Console.Write("GPIO Pins:   ");

            foreach (int pin in dev.GPIO_Available())
              Console.Write(pin.ToString() + " ");

            Console.WriteLine();

            // Display the available I2C buses

            Console.Write("I2C buses:   ");

            foreach (int bus in dev.I2C_Available())
                Console.Write(bus.ToString() + " ");

            Console.WriteLine();

            // Display the available PWM outputs

            Console.Write("PWM outputs: ");

            foreach (int bus in dev.PWM_Available())
                Console.Write(bus.ToString() + " ");

            Console.WriteLine();

            // Display the available SPI devices

            Console.Write("SPI devices: ");

            foreach (int bus in dev.SPI_Available())
                Console.Write(bus.ToString() + " ");

            Console.WriteLine();
        }
    }
}
