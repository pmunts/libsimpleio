// C# binding for SPI device services in libsimpleio.so

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
    /// Wrapper for libsimpleio SPI device services.
    /// </summary>
    public class libSPI
    {
        /// <summary>
        /// Open a Linux SPI device.
        /// </summary>
        /// <param name="devname">Device node name.</param>
        /// <param name="mode">SPI transfer mode (0 .. 3)</param>
        /// <param name="wordsize">SPI transfer word size (8, 16, or 32).</param>
        /// <param name="speed">SPI transfer speed in Hz.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        ///<remarks>The Linux kernel create a device nodes for each SPI slave
        ///device, of the form
        ///<c>/dev/spidevX.Y</c> where <c>X</c> is the SPI bus
        ///controller number and <c>Y</c> is the SPI slave select number.</remarks>
        [DllImport("simpleio")]
        public static extern void SPI_open(string devname, int mode,
            int wordsize, int speed, out int fd, out int error);

        /// <summary>
        /// Send bytes to and/or receive bytes from a Linux SPI device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="csfd">Chip select file descriptor.</param>
        /// <param name="cmd">Source buffer.</param>
        /// <param name="cmdlen">Source buffer size.</param>
        /// <param name="delayus">Delay in microseconds between the write and read operations.</param>
        /// <param name="resp">Destination buffer.</param>
        /// <param name="resplen">Destination buffer size.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void SPI_transaction(int fd, int csfd, byte[] cmd,
            int cmdlen, int delayus, byte[] resp, int resplen, out int error);

        /// <summary>
        /// Close a Linux SPI device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void SPI_close(int fd, out int error);
    }
}
