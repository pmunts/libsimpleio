// Motor services, using PWM and GPIO outputs

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

namespace IO.Objects.Motor.PWM
{
    /// <summary>
    /// Encapsulates motors controlled by PWM and GPIO outputs.
    /// </summary>
    public class Output : IO.Interfaces.Motor.Output
    {
        private readonly IO.Interfaces.GPIO.Pin dirpin;
        private readonly IO.Interfaces.PWM.Output pwm0; // CW
        private readonly IO.Interfaces.PWM.Output pwm1; // CCW

        // Type 1 motor drivers, using one GPIO output for direction,
        // and one PWM output for speed

        /// <summary>
        /// Constructor for a single motor, using one GPIO pin for
        /// direction control, and one PWM output for speed control.
        /// </summary>
        /// <param name="direction">GPIO pin instance (for direction
        /// control).</param>
        /// <param name="speed">PWM output instance (for speed
        /// control).</param>
        /// <param name="velocity">Initial motor velocity.</param>
        public Output(IO.Interfaces.GPIO.Pin direction,
          IO.Interfaces.PWM.Output speed,
          double velocity = IO.Interfaces.Motor.Velocities.Stop)
        {
            if ((velocity < IO.Interfaces.Motor.Velocities.Minimum) ||
                (velocity > IO.Interfaces.Motor.Velocities.Maximum))
                throw new System.Exception("Invalid motor velocity");

            dirpin = direction;
            pwm0 = speed;
            pwm1 = null;

            this.velocity = velocity;
        }

        // Type 2 motor drivers, using two PWM outputs: One for CW
        // rotation and one for CCW rotation

        /// <summary>
        /// Constructor for a single motor, using two PWM outputs
        /// for clockwise and counterclockwise rotation control.
        /// </summary>
        /// <param name="clockwise">PWM output instance (for clockwise
        /// rotation control).</param>
        /// <param name="counterclockwise">PWM output instance (for
        /// counterclockwise rotation control).</param>
        /// <param name="velocity">Initial motor velocity.</param>
        public Output(IO.Interfaces.PWM.Output clockwise,
            IO.Interfaces.PWM.Output counterclockwise,
          double velocity = IO.Interfaces.Motor.Velocities.Stop)
        {
            if ((velocity < IO.Interfaces.Motor.Velocities.Minimum) ||
                (velocity > IO.Interfaces.Motor.Velocities.Maximum))
                throw new System.Exception("Invalid motor velocity");

            dirpin = null;
            pwm0 = clockwise;
            pwm1 = counterclockwise;

            this.velocity = velocity;
        }

        /// <summary>
        /// Write-only property for setting the normalized motor velocity.
        /// Allowed values are -1.0 (full speed reverse) to +1.0
        /// (full speed forward).
        /// </summary>
        public double velocity
        {
            set
            {
                if ((value < IO.Interfaces.Motor.Velocities.Minimum) ||
                    (value > IO.Interfaces.Motor.Velocities.Maximum))
                    throw new System.Exception("Invalid motor velocity");

                // Type 1 motor drivers, using one GPIO output for direction,
                // and one PWM output for speed

                if (this.dirpin != null)
                {
                    if (value >= IO.Interfaces.Motor.Velocities.Stop)
                    {
                        this.dirpin.state = true;

                        this.pwm0.dutycycle =
                            IO.Interfaces.PWM.DutyCycles.Maximum * value;
                    }
                    else
                    {
                        this.dirpin.state = false;

                        this.pwm0.dutycycle =
                            -IO.Interfaces.PWM.DutyCycles.Maximum * value;
                    }
                }

                // Type 2 motor drivers, using two PWM outputs: One for CW
                // rotation and one for CCW rotation

                else
                {
                    if (value >= IO.Interfaces.Motor.Velocities.Stop)
                    {
                        this.pwm1.dutycycle =
                            IO.Interfaces.PWM.DutyCycles.Minimum;

                        this.pwm0.dutycycle =
                            IO.Interfaces.PWM.DutyCycles.Maximum * value;
                    }
                    else
                    {
                        this.pwm0.dutycycle =
                            IO.Interfaces.PWM.DutyCycles.Minimum;

                        this.pwm1.dutycycle =
                            -IO.Interfaces.PWM.DutyCycles.Maximum * value;
                    }
                }
            }
        }
    }
}
