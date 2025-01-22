// GPIO pin services using IO.Objects.SimpleIO

// Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Objects.SimpleIO.GPIO
{
    /// <summary>
    /// Encapsulates Linux GPIO pins using <c>libsimpleio</c>.
    /// </summary>
    public class Pin : IO.Interfaces.GPIO.Pin
    {
        private readonly int myfd;
        private readonly Kinds kind;

        private enum Kinds
        {
            Input,
            Output,
            Interrupt
        };

        private void CalculateFlags(IO.Interfaces.GPIO.Direction dir,
            IO.Interfaces.GPIO.Drive drive, IO.Interfaces.GPIO.Edge edge,
            IO.Interfaces.GPIO.Polarity polarity, out int flags,
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

            if ((drive < IO.Interfaces.GPIO.Drive.PushPull) ||
                (drive > IO.Interfaces.GPIO.Drive.OpenSource))
            {
                throw new Exception("Invalid Drive parameter");
            }

            if ((edge < IO.Interfaces.GPIO.Edge.None) ||
                (edge > IO.Interfaces.GPIO.Edge.Both))
            {
                throw new Exception("Invalid edge parameter");
            }

            if ((polarity < IO.Interfaces.GPIO.Polarity.ActiveLow) ||
                (polarity > IO.Interfaces.GPIO.Polarity.ActiveHigh))
            {
                throw new Exception("Invalid polarity parameter");
            }

            // Set flags for the GPIO pin data direction

            switch (dir)
            {
                case IO.Interfaces.GPIO.Direction.Input:
                    flags |= IO.Bindings.libsimpleio.GPIO_LINE_REQUEST_INPUT;
                    break;

                case IO.Interfaces.GPIO.Direction.Output:
                    flags |= IO.Bindings.libsimpleio.GPIO_LINE_REQUEST_OUTPUT;
                    break;
            }

            // Set flags for the GPIO pin output Drive

            switch (drive)
            {
                case IO.Interfaces.GPIO.Drive.PushPull:
                    flags |= IO.Bindings.libsimpleio.GPIO_LINE_REQUEST_PUSH_PULL;
                    break;

                case IO.Interfaces.GPIO.Drive.OpenDrain:
                    flags |= IO.Bindings.libsimpleio.GPIO_LINE_REQUEST_OPEN_DRAIN;
                    break;

                case IO.Interfaces.GPIO.Drive.OpenSource:
                    flags |= IO.Bindings.libsimpleio.GPIO_LINE_REQUEST_OPEN_SOURCE;
                    break;
            }

            // Set flags for the GPIO pin polarity

            switch (polarity)
            {
                case IO.Interfaces.GPIO.Polarity.ActiveLow:
                    flags |= IO.Bindings.libsimpleio.GPIO_LINE_REQUEST_ACTIVE_LOW;
                    break;

                case IO.Interfaces.GPIO.Polarity.ActiveHigh:
                    flags |= IO.Bindings.libsimpleio.GPIO_LINE_REQUEST_ACTIVE_HIGH;
                    break;
            }

            // Set flags for the GPIO pin input interrupt trigger edge(s)

            switch (edge)
            {
                case IO.Interfaces.GPIO.Edge.None:
                    events |= IO.Bindings.libsimpleio.GPIO_EVENT_REQUEST_NONE;
                    break;

                case IO.Interfaces.GPIO.Edge.Rising:
                    events |= IO.Bindings.libsimpleio.GPIO_EVENT_REQUEST_RISING;
                    break;

                case IO.Interfaces.GPIO.Edge.Falling:
                    events |= IO.Bindings.libsimpleio.GPIO_EVENT_REQUEST_FALLING;
                    break;

                case IO.Interfaces.GPIO.Edge.Both:
                    events |= IO.Bindings.libsimpleio.GPIO_EVENT_REQUEST_BOTH;
                    break;
            }

            if (dir == Interfaces.GPIO.Direction.Output)
                kind = Kinds.Output;
            else if (edge != IO.Interfaces.GPIO.Edge.None)
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
        /// <param name="drive">Output Drive setting.</param>
        /// <param name="edge">Input edge setting.</param>
        /// <param name="polarity">Polarity setting.</param>
        public Pin(IO.Objects.SimpleIO.Device.Designator desg,
            IO.Interfaces.GPIO.Direction dir, bool state = false,
            IO.Interfaces.GPIO.Drive drive = IO.Interfaces.GPIO.Drive.PushPull,
            IO.Interfaces.GPIO.Edge edge = IO.Interfaces.GPIO.Edge.None,
            IO.Interfaces.GPIO.Polarity polarity = IO.Interfaces.GPIO.Polarity.ActiveHigh)
        {
            // Validate the GPIO pin designator

            if ((desg.chip == IO.Objects.SimpleIO.Device.Designator.Unavailable.chip) ||
                (desg.chan == IO.Objects.SimpleIO.Device.Designator.Unavailable.chan))
            {
                throw new Exception("Invalid designator");
            }

            CalculateFlags(dir, drive, edge, polarity, out int flags, out int events,
                out this.kind);

            IO.Bindings.libsimpleio.GPIO_line_open((int)desg.chip,
                (int)desg.chan, flags, events, state ? 1 : 0, out this.myfd,
                out int error);

            if (error != 0)
            {
                throw new Exception("GPIO_line_open() failed, " +
                    errno.strerror(error));
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
                        IO.Bindings.libsimpleio.GPIO_line_read(this.myfd,
                            out value, out error);

                        if (error != 0)
                        {
                            throw new Exception("GPIO_line_read() failed, " +
                                errno.strerror(error));
                        }
                        break;

                    case Kinds.Interrupt:
                        IO.Bindings.libsimpleio.GPIO_line_event(this.myfd,
                            out value, out error);

                        if (error != 0)
                        {
                            throw new Exception("GPIO_line_event() failed, " +
                                errno.strerror(error));
                        }
                        break;
                }

                return value != 0;
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
                        IO.Bindings.libsimpleio.GPIO_line_write(this.myfd,
                            value ? 1 : 0, out error);

                        if (error != 0)
                        {
                            throw new Exception("GPIO_line_write() failed, " +
                                errno.strerror(error));
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
