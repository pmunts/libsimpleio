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

// NOTE: This module bit-bangs the step signal to the A4988 driver.  For more
// accurate timing, you should generate the step signal from some kind of
// dedicated real-time hardware, such as a microcontroller.

using System;

namespace IO.Devices.A4988
{
    /// <summary>
    /// Encapsulates the A4988 Stepper Motor Controller.
    /// </summary>
    public class Device : IO.Interfaces.Stepper.Output
    {
        private readonly int num_steps;
        private readonly IO.Interfaces.GPIO.Pin pin_step;
        private readonly IO.Interfaces.GPIO.Pin pin_dir;
        private readonly IO.Interfaces.GPIO.Pin pin_enable = null;
        private readonly IO.Interfaces.GPIO.Pin pin_reset = null;
        private readonly IO.Interfaces.GPIO.Pin pin_sleep = null;

        /// <summary>
        /// Constructor for a single A4988 device.
        /// </summary>
        /// <param name="StepsPerRotation">The number of steps per rotation.
        /// This is a physical characteristic of the particular stepper motor
        /// being driven.</param>
        /// <param name="Step">GPIO pin object for the
        /// <c>STEP</c> signal.</param>
        /// <param name="Dir">GPIO pin object for the
        /// <c>DIR</c> signal.</param>
        /// <param name="Enable">GPIO pin object for the
        /// <c>-ENABLE</c> signal.</param>
        /// <param name="Reset">GPIO pin object for the
        /// <c>-RESET</c> signal.</param>
        /// <param name="Sleep">GPIO pin object for the
        /// <c>-SLEEP</c> signal.</param>
        public Device(int StepsPerRotation,
            IO.Interfaces.GPIO.Pin Step,
            IO.Interfaces.GPIO.Pin Dir,
            IO.Interfaces.GPIO.Pin Enable = null,
            IO.Interfaces.GPIO.Pin Reset = null,
            IO.Interfaces.GPIO.Pin Sleep = null)
        {
            this.num_steps = StepsPerRotation;
            this.pin_step = Step;
            this.pin_dir = Dir;
            this.pin_enable = Enable;
            this.pin_reset = Reset;
            this.pin_sleep = Sleep;

            this.Reset();
            this.Disable();
            this.Sleep();
            this.Wakeup();
            this.Enable();
        }

        /// <summary>
        /// Move the stepper motor a specified number of steps at a
        /// specified rate.
        /// </summary>
        /// <param name="steps">Number of steps to move.
        /// Negative values indicate reverse motion and positive values
        /// indicate forward motion.  (The directions are nominal and depend on
        /// how the stepper motor coils are wired).  Zero indicates the stepper
        /// motor should be stopped.</param>
        /// <param name="rate">The rate of motion, in steps per second.
        /// Negative values indicate reverse motion and positive values
        /// indicate forward motion.  (The directions are nominal and depend on
        /// how the stepper motor coils are wired).  Zero indicates the stepper
        /// motor should be stopped.</param>
        /// <remarks>This implementation supports a maximum rate of 500 steps
        /// per second.</remarks>
        public void Move(int steps, float rate)
        {
            // Validate parameters

            if (steps == 0) return;

            if (rate == 0.0) return;

            int msecs = (int)(1000.0 / Math.Abs(rate) + 0.5);

            if (msecs < 2) throw new System.Exception("Invalid rate parameter.");

            // Set direction signal

            if (((steps < 0) && (rate > 0.0)) || ((steps > 0) && (rate < 0.0)))
                this.pin_dir.state = false;
            else
                this.pin_dir.state = true;

            steps = Math.Abs(steps);

            for (int i = 0; i < steps; i++)
            {
                this.pin_step.state = true;
                System.Threading.Thread.Sleep(1);
                this.pin_step.state = false;
                System.Threading.Thread.Sleep(msecs - 1);
            }
        }

        /// <summary>
        /// Spin (i.e. continuous rotation) the stepper moter at a specified rate.
        /// </summary>
        /// <param name="rate">The rate of motion, in steps per second.
        /// Negative values indicate reverse motion and positive values
        /// indicate forward motion.  (The directions are nominal and depend on
        /// how the stepper motor coils are wired).  Zero indicates the stepper
        /// motor should be stopped.</param>
        /// <remarks>The A4988 stepper motor driver does not support continuous
        /// rotation and this method will always throw an exception.</remarks>
        public void Spin(float rate)
        {
            throw new System.Exception("This driver does not support the Spin() method.");
        }

        /// <summary>
        /// Read-only property returning the number of steps a stepper motor
        /// has.
        /// </summary>
        public int StepsPerRotation
        {
            get
            {
                return this.num_steps;
            }
        }

        /// <summary>
        /// Enable the A4988 device.
        /// </summary>
        public void Enable()
        {
            if (this.pin_enable == null) return;

            this.pin_enable.state = false;  // Enable is active low
        }

        /// <summary>
        /// Disable the A4988 device.
        /// </summary>
        public void Disable()
        {
            if (this.pin_enable == null) return;

            this.pin_enable.state = true;  // Enable is active low
        }

        /// <summary>
        /// Reset the A4988 device.
        /// </summary>
        public void Reset()
        {
            if (this.pin_reset == null) return;

            this.pin_reset.state = false;  // Reset is active low
            System.Threading.Thread.Sleep(1);
            this.pin_reset.state = true;   // Reset is active low
            System.Threading.Thread.Sleep(1);
        }

        /// <summary>
        /// Put the A4988 device to sleep.
        /// </summary>
        public void Sleep()
        {
            if (this.pin_sleep == null) return;

            this.pin_sleep.state = false;  // Sleep is active low
        }

        /// <summary>
        /// Wake up the A4988 device.
        /// </summary>
        public void Wakeup()
        {
            if (this.pin_sleep == null) return;

            this.pin_sleep.state = true;  // Sleep is active low
            System.Threading.Thread.Sleep(1);
        }
    }
}
