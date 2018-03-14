// C# binding for raw HID services in libsimpleio.so

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
    /// Wrapper for libsimpleio raw HID services.
    /// </summary>
    public class libHIDRaw
    {
        /// <summary>
        /// Open a Linux raw HID device by device node name.
        /// </summary>
        /// <param name="devname">Device node name.</param>
        /// <param name="fd">Device node name.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void HIDRAW_open(string devname, out int fd,
            out int error);

        /// <summary>
        /// Open a Linux raw HID device by vendor ID and product ID.
        /// </summary>
        /// <param name="VID">Vendor ID.</param>
        /// <param name="PID">Product ID.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void HIDRAW_open_id(int VID, int PID, out int fd,
            out int error);

        /// <summary>
        /// Close a Linux raw HID.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void HIDRAW_close(int fd, out int error);

        /// <summary>
        /// Get Linux raw HID name string.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="name">Destination buffer.</param>
        /// <param name="size">Size of destination buffer.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void HIDRAW_get_name(int fd,
            System.Text.StringBuilder name, int size, out int error);

        /// <summary>
        /// Get Linux raw HID bus type, vendor ID, and product ID.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="bustype">Bus type.</param>
        /// <param name="vendor">Vendor ID.</param>
        /// <param name="product">Product ID.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void HIDRAW_get_info(int fd, out int bustype,
            out int vendor, out int product, out int error);

        /// <summary>
        /// Send a 64-byte report to a Linux HID.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="buf">Source buffer.</param>
        /// <param name="bufsize">Source buffer size.</param>
        /// <param name="count">Number of bytes actually sent.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void HIDRAW_send(int fd, byte[] buf, int bufsize,
            out int count, out int error);

        /// <summary>
        /// Get a 64-byte report from a Linux HID.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="buf">Destination buffer.</param>
        /// <param name="bufsize">Destination buffer size.</param>
        /// <param name="count">Number of bytes actually received.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void HIDRAW_receive(int fd, byte[] buf, int bufsize,
            out int count, out int error);
    }
}
