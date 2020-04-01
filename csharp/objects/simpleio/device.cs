// Linux kernel I/O device common declartions

// Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

namespace IO.Objects.libsimpleio.Device
{
    /// <summary>
    /// Linux kernel I/O device designator..
    /// </summary>
    /// <remarks>
    /// Many Linux kernel I/O devices, including ADC inputs, DAC outputs,
    /// GPIO pins, I2C buses, PWM outputs, and SPI devices, are selected by a
    /// tuple of integers: chip and channel.
    /// </remarks>
    public struct Designator
    {
        /// <summary>
        /// Linux kernel I/O device chip number.
        /// </summary>
        public uint chip;

        /// <summary>
        /// Linux kernel I/O device channel number.
        /// </summary>
        public uint chan;

        /// <summary>
        /// device pin designator constructor.
        /// </summary>
        /// <param name="chip">Linux kernel I/O device chip number.</param>
        /// <param name="chan">Linux kernel I/O device channel number.</param>
        public Designator(uint chip, uint chan)
        {
            this.chip = chip;
            this.chan = chan;
        }

        /// <summary>
        /// Linux kernel I/O device designator for an unavailable device.
        /// </summary>
        public static readonly Designator Unavailable =
            new Designator(uint.MaxValue, uint.MaxValue);

        /// <summary>
        /// Returns <c>true</c> if this device designator is not equal to
        /// <c>Unavailable</c>.
        /// </summary>
        public bool available
        {
            get { return !this.Equals(Unavailable); }
        }
    }
}
