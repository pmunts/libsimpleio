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
    /// Encapsulates PCA8574 (and similar) I<sup>2</sup>C GPIO Expanders.
    /// </summary>
    /// <remarks>This class supports the following I<sup>2</sup>C GPIO
    /// expander devices:  MAX7328, MAX7329, PCA8574, PCA9670, PCA9672,
    /// PCA9674, PCF8574, and TCA9554.</remarks>
    public class Device
    {
        private IO.Interfaces.I2C.Device dev;
        private byte pins = 0xFF;
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
        /// Return last known state of the GPIO pins.
        /// </summary>
        /// <returns>Pin states (MSB = GPIO7).</returns>
        public byte State()
        {
            return this.pins;
        }

        /// <summary>
        /// Write all GPIO pins.
        /// </summary>
        /// <param name="data">Data to write to pins (MSB = GPIO7).</param>
        public void Write(byte data)
        {
            this.pins = data;
            this.buf[0] = pins;
            this.dev.Write(buf, 1);
        }

        /// <summary>
        /// Set selected GPIO pins.
        /// </summary>
        /// <param name="data">Pins to set high (MSB = GPIO7).</param>
        public void Set(byte data)
        {
            this.pins |= data;
            this.buf[0] = pins;
            this.dev.Write(buf, 1);
        }

        /// <summary>
        /// Clear selected GPIO pins.
        /// </summary>
        /// <param name="data">Pins to set low (MSB = GPIO7).</param>
        public void Clear(byte data)
        {
            this.pins &= (byte)(~data);
            this.buf[0] = pins;
            this.dev.Write(buf, 1);
        }
    }

    /// <summary>
    /// Encapsulates PCA8574 (and similar) I<sup>2</sup>C GPIO Expander pins.
    /// </summary>
    /// <remarks>This class supports the following I<sup>2</sup>C GPIO
    /// expander devices:  MAX7328, MAX7329, PCA8574, PCA9670, PCA9672,
    /// PCA9674, PCF8574, and TCA9554.</remarks>
    public class Pin : IO.Interfaces.GPIO.Pin
    {
        private PCA8574.Device dev;
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
                throw new Exception("Invalid GPIO pin number parameter");
            }

            this.dev = dev;
            this.mask = (byte)(1 << num);
            this.dir = dir;

            if (dir == IO.Interfaces.GPIO.Direction.Input)
                this.dev.Set(this.mask);
            else if (state)
                this.dev.Set(this.mask);
            else
                this.dev.Clear(this.mask);
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
                    return ((this.dev.State() & this.mask) != 0);
            }

            set
            {
                if (this.dir == IO.Interfaces.GPIO.Direction.Input)
                    throw new Exception("Cannot write to input pin");

                if (value)
                    this.dev.Set(mask);
                else
                    this.dev.Clear(mask);
            }
        }
    }
}
