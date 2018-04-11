// C# binding for GPIO pin services in libsimpleio.so

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
    /// Wrapper for libsimpleio GPIO services.
    /// </summary>
    public class libGPIO
    {
        /// <summary>
        /// Input data direction.
        /// </summary>
        public const int DIRECTION_INPUT = 0;
        /// <summary>
        /// Out data direction.
        /// </summary>
        public const int DIRECTION_OUTPUT = 1;

        /// <summary>
        /// Interrupts are disabled.
        /// </summary>
        public const int EDGE_NONE = 0;
        /// <summary>
        /// Interrupt on rising edge.
        /// </summary>
        public const int EDGE_RISING = 1;
        /// <summary>
        /// Interrupt on falling edge.
        /// </summary>
        public const int EDGE_FALLING = 2;
        /// <summary>
        /// Interrupt on both edges.
        /// </summary>
        public const int EDGE_BOTH = 3;

        /// <summary>
        /// Active low (inverted) polarity.
        /// </summary>
        public const int POLARITY_ACTIVELOW = 0;
        /// <summary>
        /// Active high (normal) polarity.
        /// </summary>
        public const int POLARITY_ACTIVEHIGH = 1;

        /// <summary>
        /// Configure a Linux GPIO pin.
        /// </summary>
        /// <param name="pin">Pin number.</param>
        /// <param name="direction">Data direction.</param>
        /// <param name="state">Initial state for output pin.</param>
        /// <param name="edge">Interrupt edge for input pin.</param>
        /// <param name="polarity">Polarity</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void GPIO_configure(int pin, int direction,
          int state, int edge, int polarity, out int error);

        /// <summary>
        /// Open a Linux GPIO pin device.
        /// </summary>
        /// <param name="pin">Pin number.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void GPIO_open(int pin, out int fd, out int error);

        /// <summary>
        /// Read a Linux GPIO pin.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="state">Pin state.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void GPIO_read(int fd, out int state,
            out int error);

        /// <summary>
        /// Write a Linux GPIO pin.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="state">Pin state.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void GPIO_write(int fd, int state, out int error);

        /// <summary>
        /// Close a Linux GPIO pin device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void GPIO_close(int fd, out int error);
    }
}
