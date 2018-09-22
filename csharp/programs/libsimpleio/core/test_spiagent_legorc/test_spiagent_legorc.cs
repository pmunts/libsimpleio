// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// LEGO(R) Power Functions Infrared Remote Control Test

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
using SPIAgent;

namespace test_spiagent_legorc
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nSPIAgent LEGO(R) Power Functions Infrared Remote Control Test\n");

            if (args.Length != 1)
            {
                Console.WriteLine("Usage: test_spiagent_legorc <device>");
                Environment.Exit(1);
            }

            Bus bus = new IO.Objects.libsimpleio.I2C.Bus(args[0]);

            Transport_I2C spiagent = new Transport_I2C(bus);

            SPIAgent.LEGORC IRED =
              new SPIAgent.LEGORC(spiagent, SPIAgent.Pins.LPC1114_GPIO0);

            for (;;)
            {
                LEGORC.MOTOR mot;
                LEGORC.DIRECTION dir;
                int spd;

                for (mot = LEGORC.MOTOR.MOTORA; mot <= LEGORC.MOTOR.MOTORB; mot++)
                {
                    for (dir = LEGORC.DIRECTION.REVERSE; dir <= LEGORC.DIRECTION.FORWARD; dir++)
                    {
                        for (spd = 0; spd <= 7; spd++)
                        {
                            IRED.Command(1, mot, dir, spd);
                            Console.WriteLine(mot.ToString() + " " + dir.ToString() + " " + spd.ToString());
                            System.Threading.Thread.Sleep(500);
                        }

                        System.Threading.Thread.Sleep(1000);

                        for (spd = 7; spd >= 0; spd--)
                        {
                            IRED.Command(1, mot, dir, spd);
                            Console.WriteLine(mot.ToString() + " " + dir.ToString() + " " + spd.ToString());
                            System.Threading.Thread.Sleep(500);
                        }

                        System.Threading.Thread.Sleep(1000);
                    }
                }
            }
        }
    }
}
