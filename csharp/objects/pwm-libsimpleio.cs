// PWM output services using libsimpleio

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

using libsimpleio.Exceptions;

namespace libsimpleio.PWM
{
    /// <summary>
    /// Encapsulates Linux PWM outputs using <c>libsimpleio</c>.
    /// </summary>
    public class Output: IO.Interfaces.PWM.Output
    {
        private int period;
        private int myfd;
        private double lastduty;

        /// <summary>
        /// Constructor for a single PWM output.
        /// </summary>
        /// <param name="chip">PWM chip number.</param>
        /// <param name="channel">PWM channel number.</param>
        /// <param name="frequency">PWM pulse frequency.</param>
        /// <param name="dutycycle">PWM output duty cycle (0.0 to 100.0).</param>
        /// <param name="polarity">PWM output polarity.</param>
        public Output(int chip, int channel, int frequency,
            double dutycycle = IO.Interfaces.PWM.DutyCycles.Minimum,
            int polarity = libsimpleio.libPWM.ActiveHigh)
        {
            if (chip < 0)
            {
                throw new Exception("Invalid chip number");
            }

            if (channel < 0)
            {
                throw new Exception("Invalid channel number");
            }

            if (frequency < 0)
            {
                throw new Exception("Invalid frequency");
            }

            if ((dutycycle < IO.Interfaces.PWM.DutyCycles.Minimum) ||
                (dutycycle > IO.Interfaces.PWM.DutyCycles.Maximum))
            {
                throw new Exception("Invalid duty cycle");
            }

            if ((polarity < libsimpleio.libPWM.ActiveLow) ||
                (polarity > libsimpleio.libPWM.ActiveHigh))
            {
                throw new Exception("Invalid polarity");
            }

            this.period = (int)(1.0E9 / frequency);
            int ontime = (int)(dutycycle / IO.Interfaces.PWM.DutyCycles.Maximum * this.period);
            int error;

            libsimpleio.libPWM.PWM_configure(chip, channel, period, ontime,
                (int)polarity, out error);

            if (error != 0)
            {
                throw new Exception("PWM_configure() failed", error);
            }

            libsimpleio.libPWM.PWM_open(chip, channel, out this.myfd, out error);

            if (error != 0)
            {
                throw new Exception("PWM_open() failed", error);
            }

            this.lastduty = dutycycle;
        }

        /// <summary>
        /// Read/Write property for getting or setting the PWM output duty cycle.
        /// </summary>
        public double dutycycle
        {
            get
            {
                return this.lastduty;
            }

            set
            {
                if ((value < IO.Interfaces.PWM.DutyCycles.Minimum) ||
                    (value > IO.Interfaces.PWM.DutyCycles.Maximum))
                {
                    throw new Exception("Invalid duty cycle");
                }

                int ontime = (int)(value / IO.Interfaces.PWM.DutyCycles.Maximum * this.period);
                int error;

                libsimpleio.libPWM.PWM_write(this.myfd, ontime, out error);

                if (error != 0)
                {
                    throw new Exception("PWM_write() failed", error);
                }

                this.lastduty = value;
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
