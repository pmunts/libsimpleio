// Copyright (C)2018-2026, Philip Munts dba Munts Technologies.
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

namespace IO.Objects.Servo.PWM
{
    /// <summary>
    /// Encapsulates servo outputs using PWM outputs.
    /// </summary>
    public class Output : IO.Interfaces.Servo.Output
    {
        private readonly IO.Interfaces.PWM.Output pwm;
        private readonly double period;
        private readonly double swing;
        private readonly double midpoint;

        /// <summary>
        /// Constructor for a single servo output.
        /// </summary>
        /// <param name="pwm">PWM output instance.</param>
        /// <param name="freq">PWM pulse frequency.</param>
        /// <param name="position">Initial servo position.</param>
        /// <param name="minwidth">Minimum servo output pulse width.</param>
        /// <param name="maxwidth">Maximum servo output pulse width.</param>
        public Output(IO.Interfaces.PWM.Output pwm, int freq = 50,
          double position = IO.Interfaces.Servo.Positions.Neutral,
          double minwidth = 1.0E-3, double maxwidth = 2.0E-3)
        {
            if ((position < IO.Interfaces.Servo.Positions.Minimum) ||
                (position > IO.Interfaces.Servo.Positions.Maximum))
                throw new System.Exception("Invalid servo position");

            this.pwm = pwm;
            this.period = 1.0/freq;
            this.swing = (maxwidth - minwidth)/2;
            this.midpoint = minwidth + swing;
            this.position = position;
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
                    throw new System.Exception("Invalid servo position");

                double ontime = this.midpoint + this.swing*value;
                this.pwm.dutycycle = ontime/this.period*100.0;
            }
        }
    }
}
