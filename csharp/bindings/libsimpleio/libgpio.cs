// C# binding for GPIO pin services in libsimpleio.so

// Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.
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
        /// Input data direction.
        /// </summary>
        public const int GPIO_DIRECTION_INPUT = 0;
        /// <summary>
        /// Out data direction.
        /// </summary>
        public const int GPIO_DIRECTION_OUTPUT = 1;

        /// <summary>
        /// Push-pull (source and sink) output driver.
        /// </summary>
        public const int GPIO_DRIVER_PUSHPULL = 0;

        /// <summary>
        /// Open drain (sink only) output driver.
        /// </summary>
        public const int GPIO_DRIVER_OPENDRAIN = 1;

        /// <summary>
        /// Open source (source only) output driver
        /// </summary>
        public const int GPIO_DRIVER_OPENSOURCE = 2;

        /// <summary>
        /// Interrupts are disabled.
        /// </summary>
        public const int GPIO_EDGE_NONE = 0;
        /// <summary>
        /// Interrupt on rising edge.
        /// </summary>
        public const int GPIO_EDGE_RISING = 1;
        /// <summary>
        /// Interrupt on falling edge.
        /// </summary>
        public const int GPIO_EDGE_FALLING = 2;
        /// <summary>
        /// Interrupt on both edges.
        /// </summary>
        public const int GPIO_EDGE_BOTH = 3;

        /// <summary>
        /// Active low (inverted) polarity.
        /// </summary>
        public const int GPIO_POLARITY_ACTIVELOW = 0;
        /// <summary>
        /// Active high (normal) polarity.
        /// </summary>
        public const int GPIO_POLARITY_ACTIVEHIGH = 1;

        // Old GPIO sysfs API:

        /// <summary>
        /// Configure a Linux GPIO pin.
        /// </summary>
        /// <param name="pin">Pin number.</param>
        /// <param name="direction">Data direction.</param>
        /// <param name="state">Initial GPIO output state.</param>
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

        // New GPIO descriptor API:

        /// <summary>
        /// GPIO line is being used by the kernel.
        /// </summary>
        public const int GPIO_LINE_INFO_KERNEL         = 0x0001;
        /// <summary>
        /// GPIO line is configured as an output.
        /// </summary>
        public const int GPIO_LINE_INFO_OUTPUT         = 0x0002;
        /// <summary>
        /// GPIO line is configured as active low (inverted).
        /// </summary>
        public const int GPIO_LINE_INFO_ACTIVE_LOW     = 0x0004;
        /// <summary>
        /// GPIO line is configured as open drain (current sink only).
        /// </summary>
        public const int GPIO_LINE_INFO_OPEN_DRAIN     = 0x0008;
        /// <summary>
        /// GPIO line is configured as open source (current source only).
        /// </summary>
        public const int GPIO_LINE_INFO_OPEN_SOURCE    = 0x0010;

        /// <summary>
        /// Select GPIO line direction input.
        /// </summary>
        public const int GPIO_LINE_REQUEST_INPUT       = 0x0001;
        /// <summary>
        /// Select GPIO line direction output.
        /// </summary>
        public const int GPIO_LINE_REQUEST_OUTPUT      = 0x0002;

        /// <summary>
        /// Select GPIO line polarity active high (normal).
        /// </summary>
        public const int GPIO_LINE_REQUEST_ACTIVE_HIGH = 0x0000;
        /// <summary>
        /// Select GPIO line polarity active low (inverted).
        /// </summary>
        public const int GPIO_LINE_REQUEST_ACTIVE_LOW  = 0x0004;

        /// <summary>
        /// Select GPIO line driver push-pull (current source and sink).
        /// </summary>
        public const int GPIO_LINE_REQUEST_PUSH_PULL   = 0x0000;
        /// <summary>
        /// Select GPIO line driver open drain (current sink only).
        /// </summary>
        public const int GPIO_LINE_REQUEST_OPEN_DRAIN  = 0x0008;
        /// <summary>
        /// Select GPIO line driver open source (current source only).
        /// </summary>
        public const int GPIO_LINE_REQUEST_OPEN_SOURCE = 0x0010;

        /// <summary>
        /// Disable GPIO input interrupt.
        /// </summary>
        public const int GPIO_EVENT_REQUEST_NONE        = 0x0000;
        /// <summary>
        /// Enable GPIO input interrupt on rising edge.
        /// </summary>
        public const int GPIO_EVENT_REQUEST_RISING      = 0x0001;
        /// <summary>
        /// Enable GPIO input interrupt on falling edge.
        /// </summary>
        public const int GPIO_EVENT_REQUEST_FALLING     = 0x0002;
        /// <summary>
        /// Enable GPIO input interrupt on both edges.
        /// </summary>
        public const int GPIO_EVENT_REQUEST_BOTH        = 0x0003;

        /// <summary>
        /// Get GPIO chip information.
        /// </summary>
        /// <param name="chip">GPIO chip number.</param>
        /// <param name="name">GPIO chip name.</param>
        /// <param name="namesize">Maximum size of name.</param>
        /// <param name="label">GPIO chip label.</param>
        /// <param name="labelsize">Maximum size of label.</param>
        /// <param name="lines">Number of GPIO lines.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void GPIO_chip_info(int chip,
            System.Text.StringBuilder name, int namesize,
            System.Text.StringBuilder label, int labelsize,
            out int lines, out int error);

        /// <summary>
        /// Get GPIO line information.
        /// </summary>
        /// <param name="chip">GPIO chip number.</param>
        /// <param name="line">GPIO line number.</param>
        /// <param name="name">GPIO line name.</param>
        /// <param name="namesize">Maximum size of name.</param>
        /// <param name="label">GPIO line label.</param>
        /// <param name="labelsize">Maximum size of label.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void GPIO_line_info(int chip, int line,
            System.Text.StringBuilder name, int namesize,
            System.Text.StringBuilder label, int labelsize, out int error);

        /// <summary>
        /// Open a single GPIO line.
        /// </summary>
        /// <param name="chip">GPIO chip number.</param>
        /// <param name="line">GPIO line number.</param>
        /// <param name="flags">GPIO line configuration flags.</param>
        /// <param name="events">GPIO line event flags.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <param name="fd">Linux file descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void GPIO_line_open(int chip, int line, int flags,
            int events, int state, out int fd, out int error);

        /// <summary>
        /// Read the state of a single GPIO line.
        /// </summary>
        /// <param name="fd">Linux file descriptor.</param>
        /// <param name="state">State of the GPIO line.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void GPIO_line_read(int fd, out int state,
            out int error);

        /// <summary>
        /// Write the state of a single GPIO line.
        /// </summary>
        /// <param name="fd">Linux file descriptor.</param>
        /// <param name="state">State of the GPIO line.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void GPIO_line_write(int fd, int state,
            out int error);

        /// <summary>
        /// Read an edge trigger event from single GPIO line.
        /// </summary>
        /// <param name="fd">Linux file descriptor.</param>
        /// <param name="state">State of the GPIO line after the edge trigger
        /// event.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void GPIO_line_event(int fd, out int state,
            out int error);

        /// <summary>
        /// Close a single GPIO line.
        /// </summary>
        /// <param name="fd">Linux file descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void GPIO_line_close(int fd, out int error);
    }
}
