// Servo output services using IO.Objects.libsimpleio

// Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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

namespace IO.Objects.libsimpleio.Servo
{
    /// <summary>
    /// Encapsulates Linux servo outputs using <c>libsimpleio</c>.
    /// </summary>
    public class Output: IO.Interfaces.Servo.Output
    {
        private int myfd;

        /// <summary>
        /// Constructor for a single servo output.
        /// </summary>
        /// <param name="desg">PWM output designator.</param>
        /// <param name="frequency">PWM pulse frequency.</param>
        /// <param name="position">Initial servo position).
        /// Allowed values are -1.0 to +1.0.</param>
        public Output(IO.Objects.libsimpleio.Device.Designator desg, int frequency = 50,
            double position = IO.Interfaces.Servo.Positions.Neutral)
        {
            // Validate the PWM output designator

            if ((desg.chip == IO.Objects.libsimpleio.Device.Designator.Unavailable.chip) ||
                (desg.chan == IO.Objects.libsimpleio.Device.Designator.Unavailable.chan))
            {
                throw new Exception("Invalid designator");
            }

            // Validate other parameters


            if ((frequency < 1) || (frequency > 400))
            {
                throw new Exception("Invalid frequency");
            }

            if ((position < IO.Interfaces.Servo.Positions.Minimum) ||
                (position > IO.Interfaces.Servo.Positions.Maximum))
            {
                throw new Exception("Invalid position");
            }

            int period = (int)(1E9 / frequency + 0.5);
            int ontime = (int)(1500000.0 + 500000.0 * position);
            int error;

            IO.Bindings.libsimpleio.libPWM.PWM_configure((int)desg.chip,
                (int)desg.chan, period, ontime,
                IO.Bindings.libsimpleio.libPWM.ActiveHigh, out error);

            if (error != 0)
            {
                throw new Exception("PWM_configure() failed", error);
            }

            IO.Bindings.libsimpleio.libPWM.PWM_open((int)desg.chip,
                (int)desg.chan, out this.myfd, out error);

            if (error != 0)
            {
                throw new Exception("PWM_open() failed", error);
            }
        }

        /// <summary>
        /// Write-only property for setting the servo position.
        /// Allowed values are -1.0 to +1.0.
        /// </summary>
        public double position
        {
            set
            {
                if ((value < IO.Interfaces.Servo.Positions.Minimum) ||
                    (value > IO.Interfaces.Servo.Positions.Maximum))
                {
                    throw new Exception("Invalid position");
                }

                int ontime = (int)(1500000.0 + 500000.0 * value);
                int error;

                IO.Bindings.libsimpleio.libPWM.PWM_write(this.myfd,
                    ontime, out error);

                if (error != 0)
                {
                    throw new Exception("PWM_write() failed", error);
                }
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for the
        /// servo output.
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
