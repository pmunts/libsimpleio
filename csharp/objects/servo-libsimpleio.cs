// Servo output services using libsimpleio

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

using libsimpleio.Exceptions;

namespace libsimpleio.Servo
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
        /// <param name="chip">PWM chip number.</param>
        /// <param name="channel">PWM channel number.</param>
        /// <param name="frequency">PWM pulse frequency.</param>
        /// <param name="position">Initial servo position (-1.0 to +1.0).</param>
        public Output(int chip, int channel, int frequency = 50,
            double position = IO.Interfaces.Servo.Positions.Neutral)
        {
            if (chip < 0)
            {
                throw new Exception("Invalid chip number");
            }

            if (channel < 0)
            {
                throw new Exception("Invalid channel number");
            }

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

            libsimpleio.libPWM.PWM_configure(chip, channel, period, ontime,
                libPWM.ActiveHigh, out error);

            if (error != 0)
            {
                throw new Exception("PWM_configure() failed", error);
            }

            libsimpleio.libPWM.PWM_open(chip, channel, out this.myfd,
                out error);

            if (error != 0)
            {
                throw new Exception("PWM_open() failed", error);
            }
        }

        /// <summary>
        /// Write-only property for setting the PWM output duty cycle.
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

                libsimpleio.libPWM.PWM_write(this.myfd, ontime, out error);

                if (error != 0)
                {
                    throw new Exception("PWM_write() failed", error);
                }
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for the PWM output.
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
