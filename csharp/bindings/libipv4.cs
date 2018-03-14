// C# binding for TCP/IP services in libsimpleio.so

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

using System.Runtime.InteropServices;

namespace IO.Bindings.libsimpleio
{
    /// <summary>
    /// Wrapper for libsimpleio IPv4 network services.
    /// </summary>
    public class libIPV4
    {
        /// <summary>
        /// Resolve a domain name to an IPv4 address.
        /// </summary>
        /// <param name="hostname">Host name to resolve.</param>
        /// <param name="addr">IPv4 address.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void IPV4_resolve(string hostname, out int addr,
            out int error);

        /// <summary>
        /// Convert an IPv4 address to a dotted notation string (<i>e.g.</i> 1.2.3.4).
        /// </summary>
        /// <param name="addr">IPv4 address</param>
        /// <param name="buf">Destination buffer.</param>
        /// <param name="bufsize">Destination buffer size.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void IPV4_ntoa(int addr,
            System.Text.StringBuilder buf, int bufsize, out int error);

        /// <summary>
        /// Connect to a TCP server.
        /// </summary>
        /// <param name="addr">IPv4 address.</param>
        /// <param name="port">TCP port number.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void TCP4_connect(int addr, int port,
            out int fd, out int error);

        /// <summary>
        /// Start TCP server and wait for a single connection.
        /// </summary>
        /// <param name="addr">IPv4 address, of the interface to listen on.  Use
        /// 0.0.0.0 to listen on all interfaces.</param>
        /// <param name="port">TCP port number.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void TCP4_accept(int addr, int port,
            out int fd, out int error);

        /// <summary>
        /// Start a TCP server and fork for each connection.
        /// </summary>
        /// <param name="addr">IPv4 address, of the interface to listen on.  Use
        /// 0.0.0.0 to listen on all interfaces.</param>
        /// <param name="port">TCP port number.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void TCP4_server(int addr, int port,
            out int fd, out int error);

        /// <summary>
        /// Close a TCP connection.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void TCP4_close(int fd, out int error);

        /// <summary>
        /// Send bytes to TCP peer.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="buf">Source buffer.</param>
        /// <param name="bufsize">Source buffer size.</param>
        /// <param name="count">Number of bytes actually sent.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void TCP4_send(int fd, byte[] buf, int bufsize,
            out int count, out int error);

        /// <summary>
        /// Receive bytes from TCP peer.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="buf">Destination buffer.</param>
        /// <param name="bufsize">Destination buffer size.</param>
        /// <param name="count">Number of bytes actually received.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void TCP4_receive(int fd, byte[] buf, int bufsize,
            out int count, out int error);
    }
}
