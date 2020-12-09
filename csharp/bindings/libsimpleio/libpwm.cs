// C# binding for PWM output services in libsimpleio.so

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
        /// Configure the PWM output as active low (inverted).
        /// </summary>
        /// <remarks>Not all platforms support active low (inverted) PWM
        /// outputs.</remarks>
        public const int PWM_POLARITY_ACTIVELOW = 0;
        /// <summary>
        /// Configure the PWM output as active high (normal).
        /// </summary>
        public const int PWM_POLARITY_ACTIVEHIGH = 1;

        /// <summary>
        /// Configure a Linux PWM output device.
        /// </summary>
        /// <param name="chip">Chip number.</param>
        /// <param name="channel">Channel number.</param>
        /// <param name="period">Pulse period in microseconds.</param>
        /// <param name="ontime">Initial on time in microseconds.</param>
        /// <remarks>On many platforms two more more PWM outputs may share the same
        /// clock generator, so configuring different PWM pulse periods may not be
        /// possible.</remarks>
        /// <param name="polarity">PWM output polarity (0 for active low/inverted or 1
        /// for active high/normal).</param>
        /// <remarks>Not all platforms support active low (inverted) PWM outputs.</remarks>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void PWM_configure(int chip, int channel,
          int period, int ontime, int polarity, out int error);

        /// <summary>
        /// Open a Linux PWM output device.
        /// </summary>
        /// <param name="chip">Chip number.</param>
        /// <param name="channel">Channel number.</param>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void PWM_open(int chip, int channel, out int fd,
          out int error);

        /// <summary>
        /// Close a Linux PWM output device.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void PWM_close(int fd, out int error);

        /// <summary>
        /// Set a Linux PWM output device duty cycle.
        /// </summary>
        /// <param name="fd">File descriptor.</param>
        /// <param name="ontime">On time in microseconds.</param>
        /// <param name="error">Error code.  Zero upon success or an <c>errno</c>
        /// value upon failure.</param>
        [DllImport("simpleio")]
        public static extern void PWM_write(int fd, int ontime, out int error);
    }
}
