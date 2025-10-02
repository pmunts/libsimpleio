// 64-byte Message Services using Wio-E5 LoRa Transceiver Module using the
// Amateur Radio Address Protocol #1.

// Copyright (C)2025, Philip Munts dba Munts Technologies.
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

namespace IO.Objects.Message64.WioE5Ham1
{
    /// <summary>
    /// Encapsulates Wio-E5 LoRa Transceiver Module Amateur Radio Address
    /// Protocol #1 servers.
    /// </summary>
    public class Messenger : IO.Interfaces.Message64.Messenger
    {
        private IO.Devices.WioE5.Ham1.Device radio;
        private int dstnode;
        private int timeout;

        /// <summary>
        /// Constructor for a 64-byte Messenger instance using Wio-E5 LoRa
        /// Transceiver Module Amateur Radio Address Protocol #1.
        /// </summary>
        /// <param name="dev">Wio-E5 LoRa Transceiver device object instance.
        /// </param>
        /// <param name="nodeid">Remote I/O server unicast node ID (ARCNET style:
        /// 1 to 255).</param>
        /// <param name="timeoutms">Receive timeout in milliseconds.  Zero
        /// indicates wait forever.</param>
        public Messenger(IO.Devices.WioE5.Ham1.Device dev, int nodeid,
            int timeoutms = 1000)
        {
            // Validate parameters

            if ((nodeid < 1) || (nodeid > 255))
                throw new System.Exception("The node ID parameter is out of range");

            if (timeoutms < 0)
                throw new System.Exception("The timeoutms parameter is out of range");

            this.radio   = dev;
            this.dstnode = nodeid;
            this.timeout = timeoutms;
        }

        /// <summary>
        /// Send a 64-byte command message.
        /// </summary>
        /// <param name="cmd">64-byte command message.</param>
        public void Send(IO.Interfaces.Message64.Message cmd)
        {
            int count = cmd.payload.Length;
            
            // Don't transmit trailing zero bytes

            while ((count > 1) && (cmd.payload[count - 1] == 0))
                count--;

            this.radio.Send(cmd.payload, count, this.dstnode);
        }

        /// <summary>
        /// Receive a 64-byte response message.
        /// </summary>
        /// <param name="resp">64-byte response message.</param>
        public void Receive(IO.Interfaces.Message64.Message resp)
        {
            int t = this.timeout;

            for (;;)
            {
                this.radio.Receive(resp.payload, out int len, out int srcnode,
                    out int dstnode, out int RSS, out int SNR);

                if (len > 0)
                {
                    // Pad zero bytes

                    for (int i = len; i < resp.payload.Length; i++)
                        resp.payload[i] = 0;

                    return;
                }

                if ((t > 0) && (--t == 0))
                    throw new System.Exception("LoRA receive timeout expired");

                System.Threading.Thread.Sleep(1);
            }
        }

        /// <summary>
        /// Send a 64-byte command message and receive a 64-byte response
        /// message.
        /// </summary>
        /// <param name="cmd">64-byte command message.</param>
        /// <param name="resp">64-byte response message.</param>
        public void Transaction(IO.Interfaces.Message64.Message cmd,
            IO.Interfaces.Message64.Message resp)
        {
            this.Send(cmd);
            this.Receive(resp);
        }
    }
}
