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

namespace IO.Devices.ADC121C021
{
    /// <summary>
    /// Encapsulates the ADC121C021 I<sup>2</sup>C A/D converter.
    /// </summary>
    public class Sample : IO.Interfaces.ADC.Sample
    {
        private const int RESOLUTION = 12;
        private const int SAMPLEMASK = (1 << RESOLUTION) - 1;
        private const byte REGRESULT = 0x00;
        private const byte REGCONFIG = 0x02;

        // Private state variables

        private IO.Interfaces.I2C.Bus bus;
        private int addr;

        // Private methods

        private void WriteRegister8(byte addr, byte data)
        {
            byte[] cmd = new byte[2];

            cmd[0] = addr;
            cmd[1] = data;
            this.bus.Write(this.addr, cmd, 2);
        }

        private int ReadRegister16(byte addr)
        {
            byte[] cmd = new byte[1];
            byte[] resp = new byte[2];

            cmd[0] = addr;
            this.bus.Transaction(this.addr, cmd, 1, resp, 2);
            return (resp[0] << 8) + resp[1];
        }

        /// <summary>
        /// Constructor for an ADC121C021 analog input.
        /// </summary>
        /// <param name="bus">I<sup>2</sup>C bus controller.</param>
        /// <param name="addr">I<sup>2</sup>C slave address.</param>
        public Sample(IO.Interfaces.I2C.Bus bus, byte addr)
        {
            this.bus = bus;
            this.addr = addr;
            WriteRegister8(REGCONFIG, 0x00);
        }

        /// <summary>
        /// Returns a single 12-bit analog sample.
        /// </summary>
        public int sample
        {
            get
            {
                return ReadRegister16(REGRESULT) & SAMPLEMASK;
            }
        }

        /// <summary>
        /// Return the number of bits of A/D resolution.
        /// </summary>
        public int resolution
        {
            get
            {
                return RESOLUTION;
            }
        }
    }
}
