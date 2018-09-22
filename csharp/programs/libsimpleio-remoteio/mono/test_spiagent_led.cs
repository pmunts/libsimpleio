// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// LED toggle test

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
using SPIAgent;

namespace test_spiagent_led
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nSPIAgent LED Toggle Test\n");

            IO.Interfaces.Message64.Messenger m =
                new IO.Objects.libsimpleio.HID.Messenger();

            IO.Remote.Device dev = new IO.Remote.Device(m);

            IO.Interfaces.I2C.Bus bus =
                new IO.Remote.I2C(dev, 0);

            Transport_I2C spiagent = new Transport_I2C(bus);

            IO.Interfaces.GPIO.Pin LED = new SPIAgent.GPIO(spiagent,
                SPIAgent.Pins.LPC1114_LED,
                SPIAgent.GPIO.DIRECTION.OUTPUT, false);

            for (;;)
            {
              LED.state = !LED.state;
              System.Threading.Thread.Sleep(500);
            }
        }
    }
}
