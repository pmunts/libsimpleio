// C# binding for watchdog timer services in libsimpleio.so

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

namespace libsimpleio
{
    /// <summary>
    /// Wrapper for libsimpleio watchdog timer services.
    /// </summary>
    public class libWatchdog
    {
        /// <summary>
        /// Open a Linux watchdog timer device.
        /// </summary>
        /// <param name="devname">Device node name.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void WATCHDOG_open(string devname, out int fd,
            out int error);

        /// <summary>
        /// Close a Linux watchdog timer device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void WATCHDOG_close(int fd, out int error);

        /// <summary>
        /// Query a Linux watchdog timer device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="timeout">Timeout period in seconds.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void WATCHDOG_get_timeout(int fd, out int timeout,
            out int error);

        /// <summary>
        /// Change the watchdog timer period.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="newtimeout">Requested timeout period in seconds.</param>
        /// <param name="timeout">Actual timeout period in seconds.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        /// <remarks>Not all platforms allow changing the timeout period.
        /// Some platforms may not allow <i>increasing</i> the period.</remarks>
        [DllImport("simpleio")]
        public static extern void WATCHDOG_set_timeout(int fd, int newtimeout,
            out int timeout, out int error);

        /// <summary>
        /// Reset the watchdog timer.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void WATCHDOG_kick(int fd, out int error);
    }
}
