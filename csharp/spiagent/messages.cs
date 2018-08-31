// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// command and response message definitions

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

namespace SPIAgent
{
    /// <summary>
    /// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware command message object
    /// </summary>
    public class SPIAGENT_COMMAND_MSG_t
    {
        /// <summary>
        /// Command code to SPI Agent Firmware
        /// </summary>
        public int command;

        /// <summary>
        /// Pin number to SPI Agent Firmware
        /// </summary>
        public int pin;

        /// <summary>
        /// Data item to SPI Agent Firmware
        /// </summary>
        public int data;
    }

    /// <summary>
    /// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware response message object
    /// </summary>
    public class SPIAGENT_RESPONSE_MSG_t
    {
        /// <summary>
        /// Command code from SPI Agent Firmware (echoed from command message)
        /// </summary>
        public int command;

        /// <summary>
        /// Pin number from SPI Agent Firmware (echoed from command message)
        /// </summary>
        public int pin;

        /// <summary>
        /// Data item from SPI Agent Firmware
        /// </summary>
        public int data;

        /// <summary>
        /// Error code (errno value) from SPI Agent Firmware
        /// </summary>
        public int error;
    }
}
