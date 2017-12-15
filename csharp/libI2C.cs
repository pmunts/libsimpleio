// C# binding for I2C bus controller services in libsimpleio.so

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
    /// Wrapper for libsimpleio I2C bus controller services.
    /// </summary>
    public class libI2C
    {
        /// <summary>
        /// Open a Linux I2C bus controller device.
        /// </summary>
        /// <param name="devname">Device node name.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void I2C_open(string devname, out int fd,
            out int error);

        /// <summary>
        /// Close a Linux I2C bus controller device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void I2C_close(int fd, out int error);

        /// <summary>
        /// Send bytes to and/or receive bytes from an I2C slave device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="slaveaddr">Slave address.</param>
        /// <param name="cmd">Source buffer.</param>
        /// <param name="cmdlen">Source buffer size.</param>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Response buffer size.</param>
        /// <param name="error">Error code.  Zero upon success or an <code>errno</code>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void I2C_transaction(int fd, int slaveaddr,
            byte[] cmd, int cmdlen, byte[] resp, int resplen, out int error);
    }
}
'
'
'
