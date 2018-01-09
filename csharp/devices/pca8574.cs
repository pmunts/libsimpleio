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

namespace PCA8574
{
    /// <summary>
    /// Encapsulates PCA8574 (and similar) I<sup>2</sup>C GPIO Expander pins.
    /// </summary>
    /// <remarks>This class supports the following I<sup>2</sup>C I/O
    /// expander devices:  MAX7328, MAX7329, PCA8574, PCA9670, PCA9672,
    /// PCA9674, PCF8574, and TCA9554.</remarks>
    public class Pin: IO.Interfaces.GPIO.Pin
    {
        private static byte PinStates = 0xFF;
        private IO.Interfaces.I2C.Device dev;
        private byte mask;
        private byte[] cmd;
        private byte[] resp;

        /// <summary>
        /// The number of available GPIO pins per chip.
        /// </summary>
        public const int MAX_PINS = 8;

        /// <summary>
        /// Constructor for a single GPIO pin.
        /// </summary>
        /// <param name="bus">I<sup>2</sup>C bus controller instance.</param>
        /// <param name="addr">I<sup>2</sup>C slave address.</param>
        /// <param name="num">PCA8574 GPIO pin number.</param>
        /// <param name="dir">Data direction.</param>
        /// <param name="state">Initial output state.</param>
        public Pin(IO.Interfaces.I2C.Bus bus, int addr, int num, 
            IO.Interfaces.GPIO.Direction dir, bool state = false)
        {
            // Validate parameters

            if ((addr < 0) || (addr > 127))
            {
                throw new Exception("Invalid I2C slave address parameter");
            }

            if ((num < 0) || (num >= MAX_PINS))
            {
                throw new Exception("Invalid GPIO pin number parameter");
            }

            dev = new IO.Interfaces.I2C.Device(bus, addr);

            mask = (byte)(1 << num);

            cmd = new byte[1];
            resp = new byte[1];

            if (dir == IO.Interfaces.GPIO.Direction.Input)
                PinStates |= mask;
            else if (state)
                PinStates |= mask;
            else
                PinStates &= (byte)(~mask);

            WritePins();
        }

        private byte ReadPins()
        {
            this.dev.Read(this.resp, 1);
            return resp[0];
        }

        private void WritePins()
        {
            this.cmd[0] = PinStates;
            this.dev.Write(this.cmd, 1);
        }

        /// <summary>
        /// Read/Write GPIO state property.
        /// </summary>
        public bool state
        {
            get
            {
                return ((ReadPins() & this.mask) != 0);
            }

            set
            {
                if (value)
                    PinStates |= this.mask;
                else
                    PinStates &= (byte)(~this.mask);

                WritePins();
            }
        }
    }
}
