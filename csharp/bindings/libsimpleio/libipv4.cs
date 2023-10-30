// C# binding for TCP/IP services in libsimpleio.so

// Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Bindings
{
    public static partial class libsimpleio
    {
        /// <summary>
        /// IPv4 address for binding to all network interfaces.
        /// </summary>
        public const int INADDR_ANY = 0;
        /// <summary>
        /// IPv4 address for binding to the loopback interface (aka
        /// <c>localhost</c>).
        /// </summary>
        public const int INADDR_LOOPBACK = 0x7F000001;
        /// <summary>
        /// IPv4 broadcast address.
        /// </summary>
        public const int INADDR_BROADCAST = -1;

        /// <summary>
        /// Don't use a gateway to send out the packet, send to hosts only on
        /// directly connected networks.
        /// </summary>
        public const int MSG_DONTROUTE = 0x0004;
        /// <summary>
        /// Enables nonblocking operation; if the operation would block,
        /// <c>EAGAIN</c> or <c>EWOULDBLOCK</c> is returned.
        /// </summary>
        public const int MSG_DONTWAIT = 0x0040;
        /// <summary>
        /// The caller has more data to send.  This flag informs the kernel
        /// to package all of the data sent in calls with this flag set into
        /// a single datagram which is transmitted only when a call is
        /// performed that does not specify this flag.
        /// </summary>
        public const int MSG_MORE = 0x8000;

        /// <summary>
        /// Resolve a domain name to an IPv4 host address.
        /// </summary>
        /// <param name="hostname">Host name to resolve.</param>
        /// <param name="host">IPv4 host address.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void IPV4_resolve(string hostname, out int host,
            out int error);

        /// <summary>
        /// Convert an IPv4 address to a dotted notation string (<i>e.g.</i> 1.2.3.4).
        /// </summary>
        /// <param name="host">IPv4 host address</param>
        /// <param name="buf">Destination buffer.</param>
        /// <param name="bufsize">Destination buffer size.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void IPV4_ntoa(int host,
            System.Text.StringBuilder buf, int bufsize, out int error);

        /// <summary>
        /// Connect to a TCP server.
        /// </summary>
        /// <param name="host">IPv4 host address.</param>
        /// <param name="port">TCP port number.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void TCP4_connect(int host, int port,
            out int fd, out int error);

        /// <summary>
        /// Start TCP server and wait for a single connection.
        /// </summary>
        /// <param name="host">IPv4 address, of the interface to listen on.  Use
        /// 0.0.0.0 to listen on all interfaces.</param>
        /// <param name="port">TCP port number.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void TCP4_accept(int host, int port,
            out int fd, out int error);

        /// <summary>
        /// Start a TCP server and fork for each connection.
        /// </summary>
        /// <param name="host">IPv4 address, of the interface to listen on.  Use
        /// 0.0.0.0 to listen on all interfaces.</param>
        /// <param name="port">TCP port number.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void TCP4_server(int host, int port,
            out int fd, out int error);

        /// <summary>
        /// Close a TCP connection.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
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
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
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
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void TCP4_receive(int fd, byte[] buf, int bufsize,
            out int count, out int error);

        /// <summary>
        /// Open a UDP socket.
        /// </summary>
        /// <param name="host">IPv4 host address.</param>
        /// <param name="port">UDP port number.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void UDP4_open(int host, int port,
            out int fd, out int error);

        /// <summary>
        /// Close a UDP socket.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void UDP4_close(int fd, out int error);

        /// <summary>
        /// Send a UDP datagram.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="host">Destination IPv4 host address.</param>
        /// <param name="port">Destination UDP port number.</param>
        /// <param name="buf">Source buffer.</param>
        /// <param name="bufsize">Source buffer size.</param>
        /// <param name="flags">Flags for the Linux <c>sendto()</c> system call.</param>
        /// <param name="count">Number of bytes actually sent.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void UDP4_send(int fd, int host, int port,
            byte[] buf, int bufsize, int flags, out int count, out int error);

        /// <summary>
        /// Receive a UDP datagram.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="host">Source IPv4 host address.</param>
        /// <param name="port">Source UDP port number.</param>
        /// <param name="buf">Destination buffer.</param>
        /// <param name="bufsize">Destination buffer size.</param>
        /// <param name="flags">Flags for the Linux <c>recvfrom()</c> system call.</param>
        /// <param name="count">Number of bytes actually received.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void UDP4_receive(int fd, out int host,
            out int port, byte[] buf, int bufsize, int flags, out int count,
            out int error);
    }
}
