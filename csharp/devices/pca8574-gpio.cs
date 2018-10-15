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

namespace IO.Devices.PCA8574.GPIO
{
    /// <summary>
    /// Encapsulates PCA8574 (and similar) I<sup>2</sup>C GPIO Expander pins.
    /// </summary>
    /// <remarks>This class supports the following I<sup>2</sup>C GPIO
    /// expander devices:  MAX7328, MAX7329, PCA8574, PCA9670, PCA9672,
    /// PCA9674, and PCF8574.</remarks>
    public class Pin : IO.Interfaces.GPIO.Pin
    {
        private Device dev;
        private byte mask;
        private IO.Interfaces.GPIO.Direction dir;

        /// <summary>
        /// Constructor for a single GPIO pin.
        /// </summary>
        /// <param name="dev">PCA8574 (or similar) device.</param>
        /// <param name="num">GPIO pin number.</param>
        /// <param name="dir">Data direction.</param>
        /// <param name="state">Initial output state.</param>
        public Pin(PCA8574.Device dev, int num,
            IO.Interfaces.GPIO.Direction dir, bool state = false)
        {
            // Validate parameters

            if ((num < 0) || (num >= PCA8574.Device.MAX_PINS))
            {
                throw new System.Exception("Invalid GPIO pin number parameter");
            }

            this.dev = dev;
            this.mask = (byte)(1 << num);
            this.dir = dir;

            if (dir == IO.Interfaces.GPIO.Direction.Input)
                this.state = true;
            else
                this.state = state;
        }

        /// <summary>
        /// Read/Write GPIO state property.
        /// </summary>
        public bool state
        {
            get
            {
                if (this.dir == IO.Interfaces.GPIO.Direction.Input)
                    return ((this.dev.Read() & this.mask) != 0);
                else
                    return ((this.dev.Latch & this.mask) != 0);
            }

            set
            {
                if (this.dir == IO.Interfaces.GPIO.Direction.Input)
                    throw new System.Exception("Cannot write to input pin");
                else if (value)
                    this.dev.Write((byte)(this.dev.Latch | this.mask));
                else
                    this.dev.Write((byte)(this.dev.Latch & ~this.mask));
            }
        }
    }
}
