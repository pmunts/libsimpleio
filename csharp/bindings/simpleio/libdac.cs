// C# binding for DAC output services in libsimpleio.so

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

using System.Runtime.InteropServices;

namespace IO.Bindings.libsimpleio
{
    /// <summary>
    /// Wrapper for libsimpleio D/A converter services.
    /// </summary>
    public class libDAC
    {
        /// <summary>
        /// Get the subsystem name for the specified Linux IIO D/A converter
        /// device.
        /// </summary>
        /// <param name="chip">Linux IIO device number.</param>
        /// <param name="name">Destination buffer.</param>
        /// <param name="size">Size of destination buffer.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void DAC_get_name(int chip,
          System.Text.StringBuilder name, int size, out int error);

        /// <summary>
        /// Open a Linux IIO D/A converter output device.
        /// </summary>
        /// <param name="chip">Linux IIO device number.</param>
        /// <param name="channel">Output channel number.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void DAC_open(int chip, int channel, out int fd,
          out int error);

        /// <summary>
        /// Close a Linux IIO D/A converter output device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void DAC_close(int fd, out int error);

        /// <summary>
        /// Write to a Linux IIO D/A converter output device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="sample">Analog sample data.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void DAC_write(int fd, int sample, out int error);
    }
}
