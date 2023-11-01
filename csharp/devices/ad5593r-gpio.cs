// AD5593R Analog/Digital I/O Device GPIO Pin Services

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

namespace IO.Devices.AD5593R.GPIO
{
    /// <summary>
    /// Encapsulates AD5593R GPIO pins.
    /// </summary>
    public class Pin : IO.Interfaces.GPIO.Pin
    {
        private readonly IO.Devices.AD5593R.Device dev;
        private readonly byte mask;
        private readonly byte notmask;
        private readonly bool isinput;

        /// <summary>
        /// Create an AD5593R GPIO pin.
        /// </summary>
        /// <param name="dev">AD5593R device object.</param>
        /// <param name="channel">AD5593R I/O channel number (0 to 7).</param>
        /// <param name="dir">GPIO pin data direction.</param>
        /// <param name="state">Initial GPIO output state.</param>
        public Pin(IO.Devices.AD5593R.Device dev, int channel,
            IO.Interfaces.GPIO.Direction dir, bool state = false)
        {
            this.dev = dev;
            mask = (byte)(1 << channel);
            notmask = (byte)~mask;

            // Configure the AD5593 I/O channel

            if (dir == IO.Interfaces.GPIO.Direction.Input)
            {
                dev.ConfigureChannel(channel, PinMode.GPIO_Input);
                isinput = true;
            }
            else
            {
                dev.ConfigureChannel(channel, PinMode.GPIO_Output);
                isinput = false;
                this.state = state;
            }
        }

        /// <summary>
        /// Read/Write GPIO state property.
        /// </summary>
        public bool state
        {
            get
            {
                if (isinput)
                    return ((dev.GPIO_Inputs & mask) != 0);
                else
                    return ((dev.GPIO_Outputs & mask) != 0);
            }

            set
            {
                if (isinput)
                    throw new System.Exception("Cannot write to GPIO input.");

                if (value)
                    dev.GPIO_Outputs |= mask;
                else
                    dev.GPIO_Outputs &= notmask;
            }
        }
    }
}