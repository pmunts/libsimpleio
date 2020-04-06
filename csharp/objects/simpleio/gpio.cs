// GPIO pin services using IO.Objects.libsimpleio

// Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.
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
        private readonly int myfd;
        private readonly Kinds kind;

        /// <summary>
        /// GPIO output driver settings.
        /// </summary>
        public enum Driver
        {
            /// <summary>
            /// Push Pull (current source/sink) output driver.
            /// </summary>
            PushPull,

            /// <summary>
            /// Open Drain (current sink) output driver.
            /// </summary>
            OpenDrain,

            /// <summary>
            /// Open Source (current source) output driver.
            /// </summary>
            OpenSource
        };

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

        private enum Kinds
        {
            Input,
            Output,
            Interrupt
        };

        private void CalculateFlags(IO.Interfaces.GPIO.Direction dir,
            Driver driver, Edge edge, Polarity polarity, out int flags,
            out int events, out Kinds kind)
        {
            flags = 0;
            events = 0;
            kind = Kinds.Input;

            // Validate parameters

            if ((dir < IO.Interfaces.GPIO.Direction.Input) ||
                (dir > IO.Interfaces.GPIO.Direction.Output))
            {
                throw new Exception("Invalid direction parameter");
            }

            if ((driver < Driver.PushPull) || (driver > Driver.OpenSource))
            {
                throw new Exception("Invalid driver parameter");
            }

            if ((edge < Edge.None) || (edge > Edge.Both))
            {
                throw new Exception("Invalid edge parameter");
            }

            if ((polarity < Polarity.ActiveLow) || (polarity > Polarity.ActiveHigh))
            {
                throw new Exception("Invalid polarity parameter");
            }

            // Set flags for the GPIO pin data direction

            switch (dir)
            {
                case IO.Interfaces.GPIO.Direction.Input:
                    flags |= IO.Bindings.libsimpleio.libGPIO.LINE_REQUEST_INPUT;
                    break;

                case IO.Interfaces.GPIO.Direction.Output:
                    flags |= IO.Bindings.libsimpleio.libGPIO.LINE_REQUEST_OUTPUT;
                    break;
            }

            // Set flags for the GPIO pin output driver

            switch (driver)
            {
                case Driver.PushPull:
                    flags |= IO.Bindings.libsimpleio.libGPIO.LINE_REQUEST_PUSH_PULL;
                    break;

                case Driver.OpenDrain:
                    flags |= IO.Bindings.libsimpleio.libGPIO.LINE_REQUEST_OPEN_DRAIN;
                    break;

                case Driver.OpenSource:
                    flags |= IO.Bindings.libsimpleio.libGPIO.LINE_REQUEST_OPEN_SOURCE;
                    break;
            }

            // Set flags for the GPIO pin polarity

            switch (polarity)
            {
                case Polarity.ActiveLow:
                    flags |= IO.Bindings.libsimpleio.libGPIO.LINE_REQUEST_ACTIVE_LOW;
                    break;

                case Polarity.ActiveHigh:
                    flags |= IO.Bindings.libsimpleio.libGPIO.LINE_REQUEST_ACTIVE_HIGH;
                    break;
            }

            // Set flags for the GPIO pin input interrupt trigger edge(s)

            switch (edge)
            {
                case Edge.None:
                    events |= IO.Bindings.libsimpleio.libGPIO.EVENT_REQUEST_NONE;
                    break;

                case Edge.Rising:
                    events |= IO.Bindings.libsimpleio.libGPIO.EVENT_REQUEST_RISING;
                    break;

                case Edge.Falling:
                    events |= IO.Bindings.libsimpleio.libGPIO.EVENT_REQUEST_FALLING;
                    break;

                case Edge.Both:
                    events |= IO.Bindings.libsimpleio.libGPIO.EVENT_REQUEST_BOTH;
                    break;
            }

            if (dir == Interfaces.GPIO.Direction.Output)
                kind = Kinds.Output;
            else if (edge != Edge.None)
                kind = Kinds.Interrupt;
            else
                kind = Kinds.Input;
        }

        /// <summary>
        /// Constructor for a single GPIO pin.
        /// </summary>
        /// <param name="desg">GPIO pin designator.</param>
        /// <param name="dir">Data direction.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <param name="driver">Output driver setting</param>
        /// <param name="edge">Interrupt edge setting.</param>
        /// <param name="polarity">Polarity setting.</param>
        public Pin(IO.Objects.libsimpleio.Device.Designator desg,
            IO.Interfaces.GPIO.Direction dir, bool state = false,
            Driver driver = Driver.PushPull, Edge edge = Edge.None,
            Polarity polarity = Polarity.ActiveHigh)
        {
            // Validate the GPIO pin designator

            if ((desg.chip == IO.Objects.libsimpleio.Device.Designator.Unavailable.chip) ||
                (desg.chan == IO.Objects.libsimpleio.Device.Designator.Unavailable.chan))
            {
                throw new Exception("Invalid designator");
            }

            int flags;
            int events;
            int error;

            CalculateFlags(dir, driver, edge, polarity, out flags, out events,
                out this.kind);

            IO.Bindings.libsimpleio.libGPIO.GPIO_line_open((int)desg.chip,
                (int)desg.chan, flags, events, state ? 1 : 0, out this.myfd,
                out error);

            if (error != 0)
            {
                throw new Exception("GPIO_line_open() failed", error);
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
                int value = 0;

                switch (this.kind)
                {
                    case Kinds.Input:
                    case Kinds.Output:
                        IO.Bindings.libsimpleio.libGPIO.GPIO_line_read(this.myfd,
                            out value, out error);

                        if (error != 0)
                        {
                            throw new Exception("GPIO_line_read() failed", error);
                        }
                        break;

                    case Kinds.Interrupt:
                        IO.Bindings.libsimpleio.libGPIO.GPIO_line_event(this.myfd,
                            out value, out error);

                        if (error != 0)
                        {
                            throw new Exception("GPIO_line_event() failed", error);
                        }
                        break;
                }

                return (value == 0) ? false : true;
            }

            set
            {
                int error;

                switch (this.kind)
                {
                    case Kinds.Input:
                    case Kinds.Interrupt:
                        throw new Exception("Cannot write to input pin");

                    case Kinds.Output:
                        IO.Bindings.libsimpleio.libGPIO.GPIO_line_write(this.myfd,
                            value ? 1 : 0, out error);

                        if (error != 0)
                        {
                            throw new Exception("GPIO_line_write() failed", error);
                        }
                        break;
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
