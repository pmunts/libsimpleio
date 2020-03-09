// SN74HC595 8-bit shift register device services

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

namespace IO.Devices.SN74HC595
{
    /// <summary>
    /// Encapsulates a chain of one or more SN74HC595 8-bit shift registers.
    /// </summary>
    public class Device
    {
        private readonly IO.Interfaces.SPI.Device spidev;
        private byte[] statebuf;

        /// <summary>
        /// SPI clock mode for the SNHC74HC595 shift register.
        /// </summary>
        public const int SPI_Mode = 0;

        /// <summary>
        /// SPI maximum clock frequency for the SNHC74HC595 shift register.
        /// (Most pessimistic datasheet limit at 2V.)
        /// </summary>
        public const int SPI_MaxFreq = 4000000;

        /// <summary>
        /// Constructor for a chain of one or more SN74HC595 shift registers.
        /// </summary>
        /// <param name="dev">SPI device object.</param>
        /// <param name="stages">Number of stages in the chain.</param>
        /// <param name="initialstate">Initial shift register chain state.</param>
        public Device(IO.Interfaces.SPI.Device dev, int stages = 1, byte[] initialstate = null)
        {
            // Validate parameters

            if (stages < 1)
                throw new System.Exception("stages paramter is invalid");

            if (initialstate != null)
                if (initialstate.Length != stages)
                    throw new System.Exception("initialstate parameter length is invalid");

            // Save the SPI device object

            spidev = dev;

            // Allocate shift register state buffer

            statebuf = new byte[stages];

            // Initialize shift register state buffer

            if (initialstate == null)
            {
                for (int i = 0; i < state.Length; i++)
                    statebuf[i] = 0;
            }
            else
            {
                statebuf = initialstate;
            }

            // Shift out initial register state

            spidev.Write(statebuf, statebuf.Length);
        }

        /// <summary>
        /// Read-only property returning the number of stages in the chain.
        /// </summary>
        public int Length
        {
            get
            {
                return statebuf.Length;
            }
        }

        /// <summary>
        /// Read/Write shift register chain state property.
        /// </summary>
        public byte[] state
        {
            get
            {
                return statebuf;
            }

            set
            {
                spidev.Write(value, value.Length);
                statebuf = value;
            }
        }

        /// <summary>
        /// Read a single bit in the shift register chain.
        /// </summary>
        /// <param name="index">Shift register stage number.  Zero indicates
        /// the first register stage.</param>
        /// <param name="mask">Shift register bit mask.</param>
        /// <returns>Boolean bit value.</returns>
        public bool ReadBit(int index, byte mask)
        {
            return ((statebuf[index] & mask) != 0);
        }

        /// <summary>
        /// Set a single bit in the shift register chain.
        /// </summary>
        /// <param name="index">Shift register stage number.  Zero indicates
        /// the first register stage.</param>
        /// <param name="mask">Shift register bit mask.</param>
        public void SetBit(int index, byte mask)
        {
            statebuf[index] |= mask;
            spidev.Write(statebuf, statebuf.Length);
        }

        /// <summary>
        /// Clear a single bit in the shift register chain.
        /// </summary>
        /// <param name="index">Shift register stage number.  Zero indicates
        /// the first register stage.</param>
        /// <param name="mask">Shift register bit mask.</param>
        public void ClrBit(int index, byte mask)
        {
            statebuf[index] &= (byte)~mask;
            spidev.Write(statebuf, statebuf.Length);
        }
    }
}
