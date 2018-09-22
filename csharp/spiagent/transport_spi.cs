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

namespace SPIAgent
{
    /// <summary>
    /// SPIAgent transport implementation using SPI to communicate with the
    /// LPC1114 I/O Processor.
    /// </summary>
    public class Transport_SPI : ITransport
    {
        private readonly IO.Interfaces.SPI.Device dev;
        private byte[] cmd_bytes;
        private byte[] resp_bytes;

        /// <summary>
        /// Constructor for an SPIAgent transport object.
        /// </summary>
        /// <param name="dev">SPI device instance.</param>
        public Transport_SPI(IO.Interfaces.SPI.Device dev)
        {
            this.dev = dev;
            this.cmd_bytes = new byte[12];
            this.resp_bytes = new byte[16];
        }

        /// <summary>
        /// Issue a command to and receive a response from the LPC1114 I/O
        /// Processor.
        /// </summary>
        /// <param name="cmd">Command message object.</param>
        /// <param name="resp">Response message object.</param>
        public void Command(SPIAGENT_COMMAND_MSG_t cmd,
          ref SPIAGENT_RESPONSE_MSG_t resp)
        {
            cmd.ToBytes(ref cmd_bytes);

            // Dispatch the command

            if (cmd.command == (int)Commands.SPIAGENT_CMD_PUT_LEGORC)
            {
                dev.Transaction(cmd_bytes, cmd_bytes.Length,
                    resp_bytes, resp_bytes.Length, 20000);
            }
            else
            {
                dev.Transaction(cmd_bytes, cmd_bytes.Length,
                    resp_bytes, resp_bytes.Length, 100);
            }

            resp.FromBytes(ref resp_bytes);
        }
    }
}
