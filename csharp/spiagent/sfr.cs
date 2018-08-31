// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// Special Function Register services

// Copyright (C)2014-2018, Philip Munts, President, Munts AM Corp.
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

namespace SPIAgent
{
    /// <summary>
    /// The SFR class implements LPC1114 Special Function Register services.
    /// Use only with great caution!
    /// </summary>
    public class SFR
    {
        // Define some well known Special Function Registers

        /// <summary>
        /// LPC1114 device ID register
        /// </summary>
        public const int LPC1114_DEVICE_ID = 0x400483F4;

        /// <summary>
        /// LPC1114 GPIO1 port data register
        /// </summary>
        public const int LPC1114_GPIO1DATA = 0x50010CFC;

        /// <summary>
        /// LPC1114 UART 0 scratchpad register
        /// </summary>
        public const int LPC1114_U0SCR = 0x4000801C;

        private ITransport mytransport;
        private int myaddress;
        private SPIAGENT_COMMAND_MSG_t cmd;
        private SPIAGENT_RESPONSE_MSG_t resp;

        /// <summary>
        /// LPC1114 SFR object constructor.
        /// </summary>
        /// <param name="spiagent">SPI Agent Firmware transport object.</param>
        /// <param name="address">32-bit SFR address.
        /// See the LPC111x/LPC11Cxx User manual UM10398 for register addresses and contents.
        /// Use only with great caution!</param>
        public SFR(ITransport spiagent, int address)
        {
            // Validate parameters

            if (spiagent == null)
            {
                throw new NullReferenceException("SPI Agent Firmware transport handle is null");
            }

            if ((address < 0x40000000) || ((address >= 0x4007FFFF) && (address < 0x50000000)) || (address > 0x501FFFFF))
            {
                throw new ArgumentException("Illegal SFR address");
            }

            mytransport = spiagent;
            myaddress = address;
            cmd = new SPIAGENT_COMMAND_MSG_t();
            resp = new SPIAGENT_RESPONSE_MSG_t();
        }

        /// <summary>
        /// This property gets or sets the value of this Special Function Register.
        /// Use only with great caution!
        /// </summary>
        public int data
        {
            get
            {
                // Build the command message

                cmd.command = (int)Commands.SPIAGENT_CMD_GET_SFR;
                cmd.pin = (int)myaddress;
                cmd.data = 0;

                // Dispatch the command

                mytransport.Command(cmd, ref resp);

                // Handle errors

                if (resp.error != 0)
                {
                    throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
                }

                return (int)resp.data;
            }

            set
            {
                // Build the command message

                cmd.command = (int)Commands.SPIAGENT_CMD_PUT_SFR;
                cmd.pin = (int)myaddress;
                cmd.data = (int)value;

                // Dispatch the command

                mytransport.Command(cmd, ref resp);

                // Handle errors

                if (resp.error != 0)
                {
                    throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
                }
            }
        }
    }
}
