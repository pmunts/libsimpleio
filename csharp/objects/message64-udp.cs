// 64-byte Message Services using UDP

// Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

using System.Net;
using System.Net.Sockets;

namespace IO.Objects.Message64.UDP
{
    /// <summary>
    /// 64-Byte Message Transport Client Services using UDP
    /// (User Datagram Protocol).
    /// </summary>
    public class Messenger : IO.Interfaces.Message64.Messenger
    {
        private readonly Socket s;
        private readonly IPEndPoint server;

        /// <summary>
        /// Constructor for a 64-byte Messenger instance using UDP.
        /// </summary>
        /// <param name="host">UDP server domain name or IP address.</param>
        /// <param name="port">UDP server port number.</param>
        /// <param name="timeoutms">Receive timeout in milliseconds.  Zero
        /// indicates wait forever.</param>
        public Messenger(string host, int port, int timeoutms = 1000)
        {
            // Validate parameters

            if ((port < 0) || (port > 65535))
                throw new System.Exception("The port parameter is out of range");

            if (timeoutms < 0)
                throw new System.Exception("The timeoutms parameter is out of range");

            IPHostEntry hostinfo = Dns.GetHostEntry(host);
            IPAddress hostaddr = hostinfo.AddressList[0];

            s = new Socket(AddressFamily.InterNetwork, SocketType.Dgram,
                ProtocolType.Udp);

            s.ReceiveTimeout = timeoutms;

            server = new IPEndPoint(hostaddr, port);
        }

        /// <summary>
        /// Send a 64-byte command message
        /// </summary>
        /// <param name="cmd">64-byte command message.</param>
        public void Send(IO.Interfaces.Message64.Message cmd)
        {
            this.s.SendTo(cmd.payload, this.server);
        }

        /// <summary>
        /// Receive a 64-byte response message
        /// </summary>
        /// <param name="resp">64-byte response message.</param>
        public void Receive(IO.Interfaces.Message64.Message resp)
        {
            EndPoint sender = new IPEndPoint(0, 0);

            this.s.ReceiveFrom(resp.payload, ref sender);

            if (!this.server.Equals(sender))
                throw new System.Exception("Message not from server node");
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
