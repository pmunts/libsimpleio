// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// version test

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

namespace test_spiagent_version
{
    class Program
    {
        static void Main(string[] args)
        {
            SPIAGENT_COMMAND_MSG_t cmd;
            SPIAGENT_RESPONSE_MSG_t resp;

            Console.WriteLine("\nSPIAgent Version Test\n");

            IO.Interfaces.Message64.Messenger m =
                new IO.Objects.libsimpleio.HID.Messenger();

            IO.Remote.Device dev = new IO.Remote.Device(m);

            IO.Interfaces.I2C.Bus bus =
                new IO.Remote.I2C(dev, 0);

            Transport_I2C spiagent = new Transport_I2C(bus);

            cmd = new SPIAGENT_COMMAND_MSG_t();
            resp = new SPIAGENT_RESPONSE_MSG_t();

            cmd.command = (int)Commands.SPIAGENT_CMD_NOP;
            cmd.pin = 0;
            cmd.data = 0;

            spiagent.Command(cmd, ref resp);

            Console.WriteLine("The SPI Agent Firmware version number is " + resp.data.ToString());

            cmd.command = (int)Commands.SPIAGENT_CMD_GET_SFR;
            cmd.pin = 0x400483F4;
            cmd.data = 0;

            spiagent.Command(cmd, ref resp);

            Console.WriteLine("The LPC1114 device ID is " + resp.data.ToString("X"));

            Environment.Exit(0);
        }
    }
}
