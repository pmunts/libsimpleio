// PWM output services using IO.Objects.SimpleIO

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

using System;

namespace IO.Objects.SimpleIO.PWM
{
    /// <summary>
    /// Encapsulates Linux PWM outputs using <c>libsimpleio</c>.
    /// </summary>
    public class Output: IO.Interfaces.PWM.Output
    {
        private int period;
        private int myfd;

        /// <summary>
        /// Constructor for a single PWM output.
        /// </summary>
        /// <param name="desg">PWM output designator.</param>
        /// <param name="frequency">PWM pulse frequency.</param>
        /// <param name="dutycycle">Initial PWM output duty cycle.
        /// Allowed values are 0.0 to 100.0 percent.</param>
        /// <param name="polarity">PWM output polarity.</param>
        public Output(IO.Objects.SimpleIO.Device.Designator desg,
            int frequency, double dutycycle = IO.Interfaces.PWM.DutyCycles.Minimum,
            int polarity = IO.Bindings.libsimpleio.PWM_POLARITY_ACTIVEHIGH)
        {
            // Validate the PWM output designator

            if ((desg.chip == IO.Objects.SimpleIO.Device.Designator.Unavailable.chip) ||
                (desg.chan == IO.Objects.SimpleIO.Device.Designator.Unavailable.chan))
            {
                throw new Exception("Invalid designator");
            }

            // Validate other parameters

            if (frequency < 1)
            {
                throw new Exception("Invalid frequency");
            }

            if ((dutycycle < IO.Interfaces.PWM.DutyCycles.Minimum) ||
                (dutycycle > IO.Interfaces.PWM.DutyCycles.Maximum))
            {
                throw new Exception("Invalid duty cycle");
            }

            if ((polarity < IO.Bindings.libsimpleio.PWM_POLARITY_ACTIVELOW) ||
                (polarity > IO.Bindings.libsimpleio.PWM_POLARITY_ACTIVEHIGH))
            {
                throw new Exception("Invalid polarity");
            }

            this.period = (int)(1.0E9 / frequency);
            int ontime =(int)(dutycycle / IO.Interfaces.PWM.DutyCycles.Maximum * this.period);
            int error;

            IO.Bindings.libsimpleio.PWM_configure((int)desg.chip,
                (int)desg.chan, period, ontime, (int)polarity, out error);

            if (error != 0)
            {
                throw new Exception("PWM_configure() failed, " +
                    errno.strerror(error));
            }

            IO.Bindings.libsimpleio.PWM_open((int)desg.chip,
                (int)desg.chan, out this.myfd, out error);

            if (error != 0)
            {
                throw new Exception("PWM_open() failed, " +
                    errno.strerror(error));
            }
        }

        /// <summary>
        /// Write-only property for setting the PWM output duty cycle.
        /// Allowed values are 0.0 to 100.0 percent.
        /// </summary>
        public double dutycycle
        {
            set
            {
                if ((value < IO.Interfaces.PWM.DutyCycles.Minimum) ||
                    (value > IO.Interfaces.PWM.DutyCycles.Maximum))
                {
                    throw new Exception("Invalid duty cycle");
                }

                int ontime = (int)(value / IO.Interfaces.PWM.DutyCycles.Maximum * this.period);
                int error;

                IO.Bindings.libsimpleio.PWM_write(this.myfd,
                    ontime, out error);

                if (error != 0)
                {
                    throw new Exception("PWM_write() failed, " +
                        errno.strerror(error));
                }
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for the PWM
        /// output.
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
