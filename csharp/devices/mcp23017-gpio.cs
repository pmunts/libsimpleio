// MCP23017 I2C GPIO Expander Services.

// Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Devices.MCP23017.GPIO
{
    /// <summary>
    /// Encapsulates MCP23017 GPIO pins.
    /// </summary>
    public class Pin : IO.Interfaces.GPIO.Pin
    {
        private readonly IO.Devices.MCP23017.Device dev;
        private readonly uint mask;

        /// <summary>
        /// Create a single MCP23017 GPIO pin.
        /// </summary>
        /// <param name="dev">MCP23017 device object.</param>
        /// <param name="channel">MCP23017 I/O channel number.</param>
        /// <param name="dir">GPIO pin data direction.</param>
        /// <param name="state">Initial GPIO output state.</param>
        public Pin(IO.Devices.MCP23017.Device dev, int channel,
            IO.Interfaces.GPIO.Direction dir, bool state = false)
        {
            // Validate parameters

            if ((channel < IO.Devices.MCP23017.Device.MinChannel) ||
                (channel > IO.Devices.MCP23017.Device.MaxChannel))
                throw new System.Exception("Invalid channel number.");

            mask = (uint)(1 << channel);

            if (dir == IO.Interfaces.GPIO.Direction.Output)
                dev.Direction |= mask;
            else
                dev.Direction &= ~mask;

            this.dev = dev;
            this.state = state;
        }

        /// <summary>
        /// Read/Write GPIO state property.
        /// </summary>
        public bool state
        {
            get
            {
                return (dev.Port & mask) != 0;
            }

            set
            {
                if (value)
                    dev.Port |= mask;
                else
                    dev.Port &= ~mask;
            }
        }
    }
}