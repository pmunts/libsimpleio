// Mikroelektronika 7seg Click MIKROE-1201 (https://www.mikroe.com/7seg-click)
// Services

// Copyright (C)2020-2023, Philip Munts.
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

namespace IO.Devices.ClickBoards.RemoteIO.SevenSegment
{
    /// <summary>
    /// Encapsulates the Mikroelektronika 7Seg Click Board.
    /// <a href="https://www.mikroe.com/7seg-click">MIKROE-1201</a>.
    /// </summary>
    /// <remarks>
    /// The <c>MISO</c> <i>aka</i> <c>SDI</c> pin should be removed from the
    /// 7seg click, because it is not tri-state and will interfere with other
    /// devices on the same SPI bus.
    /// </remarks>
    public class Board
    {
        // The segments of the Mikroelektronika Seven Segment Display
        // Click Board are wired in an odd fashion.  The following
        // permutation table transforms from standard seven segment
        // layout to that of the Click Board.

        private static readonly byte[] PermutationTable =
        {
            0x00, 0x04, 0x02, 0x06, 0x08, 0x0C, 0x0A, 0x0E,
            0x10, 0x14, 0x12, 0x16, 0x18, 0x1C, 0x1A, 0x1E,
            0x20, 0x24, 0x22, 0x26, 0x28, 0x2C, 0x2A, 0x2E,
            0x30, 0x34, 0x32, 0x36, 0x38, 0x3C, 0x3A, 0x3E,
            0x40, 0x44, 0x42, 0x46, 0x48, 0x4C, 0x4A, 0x4E,
            0x50, 0x54, 0x52, 0x56, 0x58, 0x5C, 0x5A, 0x5E,
            0x60, 0x64, 0x62, 0x66, 0x68, 0x6C, 0x6A, 0x6E,
            0x70, 0x74, 0x72, 0x76, 0x78, 0x7C, 0x7A, 0x7E,
            0x80, 0x84, 0x82, 0x86, 0x88, 0x8C, 0x8A, 0x8E,
            0x90, 0x94, 0x92, 0x96, 0x98, 0x9C, 0x9A, 0x9E,
            0xA0, 0xA4, 0xA2, 0xA6, 0xA8, 0xAC, 0xAA, 0xAE,
            0xB0, 0xB4, 0xB2, 0xB6, 0xB8, 0xBC, 0xBA, 0xBE,
            0xC0, 0xC4, 0xC2, 0xC6, 0xC8, 0xCC, 0xCA, 0xCE,
            0xD0, 0xD4, 0xD2, 0xD6, 0xD8, 0xDC, 0xDA, 0xDE,
            0xE0, 0xE4, 0xE2, 0xE6, 0xE8, 0xEC, 0xEA, 0xEE,
            0xF0, 0xF4, 0xF2, 0xF6, 0xF8, 0xFC, 0xFA, 0xFE,
            0x01, 0x05, 0x03, 0x07, 0x09, 0x0D, 0x0B, 0x0F,
            0x11, 0x15, 0x13, 0x17, 0x19, 0x1D, 0x1B, 0x1F,
            0x21, 0x25, 0x23, 0x27, 0x29, 0x2D, 0x2B, 0x2F,
            0x31, 0x35, 0x33, 0x37, 0x39, 0x3D, 0x3B, 0x3F,
            0x41, 0x45, 0x43, 0x47, 0x49, 0x4D, 0x4B, 0x4F,
            0x51, 0x55, 0x53, 0x57, 0x59, 0x5D, 0x5B, 0x5F,
            0x61, 0x65, 0x63, 0x67, 0x69, 0x6D, 0x6B, 0x6F,
            0x71, 0x75, 0x73, 0x77, 0x79, 0x7D, 0x7B, 0x7F,
            0x81, 0x85, 0x83, 0x87, 0x89, 0x8D, 0x8B, 0x8F,
            0x91, 0x95, 0x93, 0x97, 0x99, 0x9D, 0x9B, 0x9F,
            0xA1, 0xA5, 0xA3, 0xA7, 0xA9, 0xAD, 0xAB, 0xAF,
            0xB1, 0xB5, 0xB3, 0xB7, 0xB9, 0xBD, 0xBB, 0xBF,
            0xC1, 0xC5, 0xC3, 0xC7, 0xC9, 0xCD, 0xCB, 0xCF,
            0xD1, 0xD5, 0xD3, 0xD7, 0xD9, 0xDD, 0xDB, 0xDF,
            0xE1, 0xE5, 0xE3, 0xE7, 0xE9, 0xED, 0xEB, 0xEF,
            0xF1, 0xF5, 0xF3, 0xF7, 0xF9, 0xFD, 0xFB, 0xFF,
        };

        // The following glyph pattern values came from:
        // https://en.wikipedia.org/wiki/Seven-segment_display

        private static readonly byte[] GlyphTable =
        {
            0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07,
            0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71,
        };

        private readonly IO.Interfaces.GPIO.Pin myRSTgpio;
        private readonly IO.Interfaces.GPIO.Pin myPWMgpio;
        private readonly IO.Interfaces.PWM.Output myPWMout;
        private readonly IO.Devices.SN74HC595.Device mychain;
        private Base myradix;
        private ZeroBlanking myblanking;
        private bool myleftdp = false;
        private bool myrightdp = false;
        private byte[] outbuf = { 0, 0 };

        // Write the output buffer to the display
        private void Post()
        {
            if (myrightdp)
                outbuf[0] |= 0x01;
            else
                outbuf[0] &= 0xFE;

            if (myleftdp)
                outbuf[1] |= 0x01;
            else
                outbuf[1] &= 0xFE;

            mychain.state = outbuf;
        }

        /// <summary>
        /// Numeral systems.
        /// </summary>
        public enum Base
        {
            /// <summary>
            /// Base 10.
            /// </summary>
            Decimal,
            /// <summary>
            /// Base 16.
            /// </summary>
            Hexadecimal,
        }

        /// <summary>
        /// Zero blanking modes.
        /// </summary>
        public enum ZeroBlanking
        {
            /// <summary>
            /// No zero blanking.
            /// </summary>
            None,
            /// <summary>
            /// Leading zero blanking.
            /// </summary>
            Leading,
            /// <summary>
            /// Full zero blanking.
            /// </summary>
            Full
        }

        /// <summary>
        /// Constructor for a single 7seg click.
        /// </summary>
        /// <param name="socket">mikroBUS socket number.</param>
        /// <param name="radix">Numerical base or radix.  Allowed values are
        /// <c>Decimal</c> and <c>Hexadecimal</c>.</param>
        /// <param name="blanking">Zero blanking.  Allowed values are
        /// <c>None</c>, <c>Leading</c>, and <c>Full</c>.</param>
        /// <param name="pwmfreq">PWM frequency.  Set to zero to use GPIO
        /// instead of PWM.</param>
        /// <param name="remdev">Remote I/O server device object.</param>
        public Board(int socket, Base radix = Base.Decimal,
            ZeroBlanking blanking = ZeroBlanking.None, int pwmfreq = 100,
            IO.Objects.RemoteIO.Device remdev = null)
        {
            // Create Remote I/O server device object, if one wasn't supplied

            if (remdev == null)
                remdev = new IO.Objects.RemoteIO.Device();

            // Create a mikroBUS socket object

            IO.Objects.RemoteIO.mikroBUS.Socket S =
                new IO.Objects.RemoteIO.mikroBUS.Socket(socket);

            // Configure hardware reset GPIO pin

            myRSTgpio = remdev.GPIO_Create(S.RST,
                IO.Interfaces.GPIO.Direction.Output, true);

            // Issue hardware reset

            Reset();

            // Configure PWM pin -- Prefer PWM over GPIO, if possible, and
            // assume full brightness until otherwise changed.

            myPWMgpio = null;
            myPWMout = null;

            if ((pwmfreq > 0) && (S.PWMOut != IO.Objects.RemoteIO.Device.Unavailable))
            {
                myPWMout = remdev.PWM_Create(S.PWMOut, pwmfreq, 100.0);
            }
            else if (S.PWM != IO.Objects.RemoteIO.Device.Unavailable)
            {
                myPWMgpio = remdev.GPIO_Create(S.PWM,
                    IO.Interfaces.GPIO.Direction.Output, true);
            }

            // Configure 74HC595 shift register chain

            mychain = new SN74HC595.Device(remdev.SPI_Create(S.SPIDev,
                IO.Devices.SN74HC595.Device.SPI_Mode, 8,
                IO.Devices.SN74HC595.Device.SPI_MaxFreq), 2);

            myradix = radix;
            myblanking = blanking;
            Clear();
        }

        /// <summary>
        /// Numerical base or radix.  Allowed values are <c>Decimal</c> and
        /// <c>Hexadecimal</c>.
        /// </summary>
        public Base radix
        {
            get
            {
                return myradix;
            }

            set
            {
                myradix = value;
            }
        }

        /// <summary>
        /// Zero blanking mode.  Allowed values are <c>None</c>,
        /// <c>Leading</c>, and <c>Full</c>.
        /// </summary>
        public ZeroBlanking blanking
        {
            get
            {
                return myblanking;
            }
            set
            {
                myblanking = value;
            }
        }

        /// <summary>
        /// Write-only property for setting the brightness of the display.
        /// Allowed values are 0.0 to 100.0 percent.
        /// </summary>
        public double brightness
        {
            set
            {
                if (value < IO.Interfaces.PWM.DutyCycles.Minimum)
                    throw new System.Exception("LED brightness value out of range.");

                if (value > IO.Interfaces.PWM.DutyCycles.Maximum)
                    throw new System.Exception("LED brightness value out of range.");

                if (myPWMgpio != null)
                    myPWMgpio.state = (value != 0.0);

                if (myPWMout != null)
                    myPWMout.dutycycle = value;
            }
        }

        /// <summary>
        /// Write-only property for setting the state of the display.
        /// Allowed values are 0 to 99 for decimal mode and 0 to 255
        /// for hexadecimal mode.
        /// </summary>
        public int state
        {
            set
            {
                switch (myradix)
                {
                    case Base.Decimal:

                        // Validate input range

                        if ((value < 0) || (value > 99))
                            throw new System.Exception("Value out of range.");

                        // Convert digits to seven segment patterns

                        outbuf[0] = PermutationTable[GlyphTable[value % 10]];
                        outbuf[1] = PermutationTable[GlyphTable[value / 10]];

                        // Handle zero blanking

                        if (value % 10 == 0)
                            if (myblanking == ZeroBlanking.Full)
                                outbuf[0] = 0;

                        if (value / 10 == 0)
                            if ((myblanking == ZeroBlanking.Full) ||
                                (myblanking == ZeroBlanking.Leading))
                                outbuf[1] = 0;
                        break;

                    case Base.Hexadecimal:

                        // Validate input range

                        if ((value < 0) || (value > 255))
                            throw new System.Exception("Value out of range.");

                        // Convert digits to seven segment patterns

                        outbuf[0] = PermutationTable[GlyphTable[value % 16]];
                        outbuf[1] = PermutationTable[GlyphTable[value / 16]];

                        // Handle zero blanking

                        if (value % 16 == 0)
                            if (myblanking == ZeroBlanking.Full)
                                outbuf[0] = 0;

                        if (value / 16 == 0)
                            if ((myblanking == ZeroBlanking.Full) ||
                                (myblanking == ZeroBlanking.Leading))
                                outbuf[1] = 0;
                        break;
                }

                Post();
            }
        }

        /// <summary>
        /// Write-only property for setting the left digit decimal point.
        /// </summary>
        public bool leftdp
        {
            set
            {
                myleftdp = value;
                Post();
            }
        }

        /// <summary>
        /// Write-only property for setting the right digit decimal point.
        /// </summary>
        public bool rightdp
        {
            set
            {
                myrightdp = value;
                Post();
            }
        }

        /// <summary>
        /// Issue hardware reset to the 74HC595 shift register chain.
        /// </summary>
        public void Reset()
        {
            myRSTgpio.state = false;
            System.Threading.Thread.Sleep(1);
            myRSTgpio.state = true;
        }

        /// <summary>
        /// Clear the display.
        /// </summary>
        public void Clear()
        {
            outbuf[0] = 0;
            outbuf[1] = 0;
            myleftdp = false;
            myrightdp = false;
            Post();
        }
    }
}
