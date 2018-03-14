// Motor using servo output (e.g. continuous rotation servo)

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

namespace IO.Objects.Motor.Servo
{
    /// <summary>
    /// Encapsulates motors connected to servo outputs (e.g. continuous
    /// rotation servos).
    /// </summary>
    public class Output : IO.Interfaces.Motor.Output
    {
        private IO.Interfaces.Servo.Output servo;

        /// <summary>
        /// Consructor for a single motor output.
        /// </summary>
        /// <param name="servo">Servo output instance.</param>
        /// <param name="velocity">Initial normalized motor velocity.
        /// Allowed values are -1.0 (full speed reverse) to +1.0
        /// (full speed forward.</param>
        public Output(IO.Interfaces.Servo.Output servo,
          double velocity = IO.Interfaces.Motor.Velocities.Minimum)
        {
            servo.position = velocity;
            this.servo = servo;
        }

        /// <summary>
        /// Write-only property for setting the normalized motor velocity.
        /// Allowed values are -1.0 (full speed reverse) to +1.0
        /// (full speed forward.
        /// </summary>
        public double velocity
        {
            set
            {
                this.servo.position = value;
            }
        }
    }
}
