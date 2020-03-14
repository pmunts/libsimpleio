// SN74HC595 8-bit shift register GPIO pin Services

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

namespace IO.Devices.SN74HC595.GPIO
{
    /// <summary>
    /// Encapsulates SN74HC595 GPIO outputs.
    /// </summary>
    public class Pin : IO.Interfaces.GPIO.Pin
    {
        private readonly IO.Devices.SN74HC595.Device mydev;
        private readonly int myindex;
        private readonly byte mymask;

        /// <summary>
        /// Constructor for a single GPIO output pin.
        /// </summary>
        /// <param name="dev">SN74HC595 device object.</param>
        /// <param name="pos">Bit position, numbered left to right.
        /// Zero indicates the most significant bit of the first shift
        /// register stage.</param>
        /// <param name="initialstate">Initial GPIO output state.</param>
        public Pin(IO.Devices.SN74HC595.Device dev, int pos, bool initialstate = false)
        {
            // Validate parameters

            if (pos < 0)
                throw new System.Exception("Invalid bit index");

            if (pos / 8 + 1 > dev.Length)
                throw new System.Exception("Invalid bit index");

            // Calculate byte index and bit mask

            mydev = dev;
            myindex = pos / 8;
            mymask = (byte) (1 << (7 - pos % 8));

            // Write initial state

            if (initialstate)
                mydev.SetBit(myindex, mymask);
            else
                mydev.ClrBit(myindex, mymask);
        }

        /// <summary>
        /// Read/Write GPIO pin state property.
        /// </summary>
        public bool state
        {
            get
            {
                return mydev.ReadBit(myindex, mymask);
            }

            set
            {
                if (value)
                    mydev.SetBit(myindex, mymask);
                else
                    mydev.ClrBit(myindex, mymask);
            }
        }
    }
}
