// GPIO pin services using IO.Interfaces.PWM

// Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

namespace IO.Objects.GPIO.PWM
{
    /// <summary>
    /// Encapsulates GPIO output pins implemented with PWM outputs.
    /// </summary>
    /// <remarks>
    /// Use cases for this class include ON/OFF things like an LED or a
    /// solenoid valve driven from a PWM output.
    /// </remarks>
    /// <remarks>
    /// Depending on the PWM hardware implementation, the OFF duty cycle may
    /// be slightly greater than 0 % and/or the ON duty cycle may be slightly
    /// less than 100 %.
    /// </remarks>
    public class Pin : IO.Interfaces.GPIO.Pin
    {
        private readonly IO.Interfaces.PWM.Output myoutput;
        private readonly double myduty;
        private bool mystate;

        /// <summary>
        /// Constructor for a single GPIO pin.
        /// </summary>
        /// <param name="outp">PWM output instance.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <param name="dutycycle">Initial PWM output duty cycle.
        /// Allowed values are 0.0 to 100.0 percent.</param>
        public Pin(IO.Interfaces.PWM.Output outp, bool state = false,
            double dutycycle = IO.Interfaces.PWM.DutyCycles.Maximum)
        {
            this.myoutput = outp;
            this.myduty = dutycycle;
            this.state = state;
        }

        /// <summary>
        /// Read/Write GPIO state property.
        /// </summary>
        public bool state
        {
            get
            {
                return this.mystate;
            }

            set
            {
                if (value)
                    this.myoutput.dutycycle = this.myduty;
                else
                    this.myoutput.dutycycle = IO.Interfaces.PWM.DutyCycles.Minimum;

                this.mystate = value;
            }
        }
    }
}
