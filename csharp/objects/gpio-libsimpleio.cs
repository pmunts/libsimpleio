// GPIO pin services using IO.Objects.libsimpleio

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

using IO.Objects.libsimpleio.Exceptions;

namespace IO.Objects.libsimpleio.GPIO
{
    /// <summary>
    /// Encapsulates Linux GPIO pins using <c>libsimpleio</c>.
    /// </summary>
    public class Pin : IO.Interfaces.GPIO.Pin
    {
        private int myfd;

        /// <summary>
        /// GPIO input interrupt edge settings.
        /// </summary>
        public enum Edge
        {
            /// <summary>
            /// Configure GPIO input pin with interrupt disabled.
            /// </summary>
            None,
            /// <summary>
            /// Configure GPIO input pin to interrupt on rising edge.
            /// </summary>
            Rising,
            /// <summary>
            /// Configure GPIO pin to interrupt on falling edge.
            /// </summary>
            Falling,
            /// <summary>
            /// Configure GPIO pin to interrupt on both edges.
            /// </summary>
            Both
        };

        /// <summary>
        /// GPIO polarity settings
        /// </summary>
        public enum Polarity
        {
            /// <summary>
            /// Configure GPIO pin as active low (inverted logic).
            /// </summary>
            ActiveLow,
            /// <summary>
            /// Configure GPIO pin as active high (normal logic).
            /// </summary>
            ActiveHigh
        };

        /// <summary>
        /// Constructor for a single GPIO pin.
        /// </summary>
        /// <param name="pin">Linux GPIO pin number.</param>
        /// <param name="dir">Data direction.</param>
        /// <param name="state">Initial output state.</param>
        /// <param name="edge">Interrupt edge.</param>
        /// <param name="polarity">Pin polarity.</param>
        public Pin(int pin, IO.Interfaces.GPIO.Direction dir,
            bool state = false, Edge edge = Edge.None,
            Polarity polarity = Polarity.ActiveHigh)
        {
            if (pin < 0)
            {
                throw new Exception("Invalid GPIO pin number");
            }

            int error;

            IO.Bindings.libsimpleio.libGPIO.GPIO_configure(pin, (int)dir,
                state ? 1 : 0, (int)edge, (int)polarity, out error);

            if (error != 0)
            {
                throw new Exception("GPIO_configure() failed", error);
            }

            IO.Bindings.libsimpleio.libGPIO.GPIO_open(pin, out this.myfd,
                out error);

            if (error != 0)
            {
                throw new Exception("GPIO_open() failed", error);
            }
        }

        /// <summary>
        /// Read/Write GPIO state property.
        /// </summary>
        public bool state
        {
            get
            {
                int error;
                int value;

                IO.Bindings.libsimpleio.libGPIO.GPIO_read(this.myfd,
                    out value, out error);

                if (error != 0)
                {
                    throw new Exception("GPIO_read() failed", error);
                }

                return (value == 0) ? false : true;
            }

            set
            {
                int error;

                IO.Bindings.libsimpleio.libGPIO.GPIO_write(this.myfd,
                    value ? 1 : 0, out error);

                if (error != 0)
                {
                    throw new Exception("GPIO_write() failed", error);
                }
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for the
        /// GPIO pin.
        /// </summary>
        public int fd
        {
            get
            {
                return this.myfd;
            }
        }
    }
}
