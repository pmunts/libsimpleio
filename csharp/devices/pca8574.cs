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

using System;

namespace IO.Devices.PCA8574
{
    /// <summary>
    /// Encapsulates PCA8574 (and similar) I<sup>2</sup>C GPIO Expanders.
    /// </summary>
    /// <remarks>This class supports the following I<sup>2</sup>C GPIO
    /// expander devices:  MAX7328, MAX7329, PCA8574, PCA9670, PCA9672,
    /// PCA9674, PCF8574, and TCA9554.</remarks>
    public class Device
    {
        private IO.Interfaces.I2C.Device dev;
        private byte latch;
        private byte[] buf = { 0 };

        /// <summary>
        /// The number of available GPIO pins per chip.
        /// </summary>
        public const int MAX_PINS = 8;

        /// <summary>
        /// Constructor for a PCA8574 (or similar) GPIO Expander.
        /// </summary>
        /// <param name="bus">I<sup>2</sup>C bus controller.</param>
        /// <param name="addr">I<sup>2</sup>C slave address.</param>
        public Device(IO.Interfaces.I2C.Bus bus, int addr)
        {
            this.dev = new IO.Interfaces.I2C.Device(bus, addr);
            this.Write(0xFF);
        }

        /// <summary>
        /// Return actual state of the GPIO pins.
        /// </summary>
        /// <returns>Pin states (MSB = GPIO7).</returns>
        public byte Read()
        {
            this.dev.Read(buf, 1);
            return buf[0];
        }

        /// <summary>
        /// Write all GPIO pins.
        /// </summary>
        /// <param name="data">Data to write to pins (MSB = GPIO7).</param>
        public void Write(byte data)
        {
            this.buf[0] = data;
            this.dev.Write(buf, 1);
            this.latch = data;
        }

        /// <summary>
        /// This read-only property returns the last value written to the
        /// output latch.
        /// </summary>
        public byte Latch
        {
            get
            {
                return this.latch;
            }
        }
    }
}
