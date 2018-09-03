// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// Analog to Digital Converter test

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
using IO.Interfaces.I2C;
using IO.Interfaces.ADC;
using SPIAgent;

namespace test_spiagent_adc
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nSPIAgent ADC Test\n");

            IO.Remote.Device dev =
              new IO.Remote.Device(new IO.Objects.USB.HID.Messenger());

            IO.Interfaces.I2C.Bus bus =
              new IO.Remote.I2C(dev, 0);

            Transport_I2C spiagent = new Transport_I2C(bus);

            Input V1 = new Input(new SPIAgent.ADC(spiagent, Pins.LPC1114_AD1), 3.3);
            Input V2 = new Input(new SPIAgent.ADC(spiagent, Pins.LPC1114_AD2), 3.3);
            Input V3 = new Input(new SPIAgent.ADC(spiagent, Pins.LPC1114_AD3), 3.3);
            Input V4 = new Input(new SPIAgent.ADC(spiagent, Pins.LPC1114_AD4), 3.3);
            Input V5 = new Input(new SPIAgent.ADC(spiagent, Pins.LPC1114_AD5), 3.3);

            for (;;)
            {
                Console.Write("AD1: " + V1.voltage.ToString("F2") + "  ");
                Console.Write("AD2: " + V2.voltage.ToString("F2") + "  ");
                Console.Write("AD3: " + V3.voltage.ToString("F2") + "  ");
                Console.Write("AD4: " + V4.voltage.ToString("F2") + "  ");
                Console.Write("AD5: " + V5.voltage.ToString("F2"));
                Console.WriteLine();

                System.Threading.Thread.Sleep(1000);
            }
        }
    }
}
