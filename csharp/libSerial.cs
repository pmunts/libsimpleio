// C# binding for serial port services in libsimpleio.so

// Copyright (C)2017, Philip Munts, President, Munts AM Corp.
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

namespace libsimpleio
{
    /// <summary>
    /// Wrapper for libsimpleio serial port services.
    /// </summary>
    public class libSerial
    {
        /// <summary>
        /// Disable parity checking.
        /// </summary>
        public const int PARITY_NONE = 0;
        /// <summary>
        /// Request even parity checking.
        /// </summary>
        public const int PARITY_EVEN = 1;
        /// <summary>
        /// Request odd parity checking.
        /// </summary>
        public const int PARITY_ODD  = 2;

        /// <summary>
        /// Open a Linux serial port device.
        /// </summary>
        /// <param name="devname">Device node name.</param>
        /// <param name="baudrate">Baud rate.</param>
        /// <param name="parity">Parity setting (0 to 2).</param>
        /// <param name="databits">Word size setting (5 to 8).</param>
        /// <param name="stopbits">Number of stop bits (1 or 2).</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void SERIAL_open(string devname, int baudrate,
            int parity, int databits, int stopbits, out int fd, out int error);

        /// <summary>
        /// Close a Linux serial port device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void SERIAL_close(int fd, out int error);

        /// <summary>
        /// Send data to a Linux serial port device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="buf">Source buffer.</param>
        /// <param name="bufsize">Source buffer size.</param>
        /// <param name="count">Number of bytes actually sent.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void SERIAL_send(int fd, byte[] buf, int bufsize,
            out int count, out int error);

        /// <summary>
        /// Receive data from a Linux serial port device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="buf">Destination buffer.</param>
        /// <param name="bufsize">Destination buffer size.</param>
        /// <param name="count">Number of bytes actually received.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void SERIAL_receive(int fd, byte[] buf,
            int bufsize, out int count, out int error);
    }
}
'
