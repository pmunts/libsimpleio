// Abstract interface for stepper motor outputs

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

namespace IO.Interfaces.Stepper
{
    /// <summary>
    ///  Abstract interface for stepper motor outputs.
    /// </summary>
    public interface Output
    {
        /// <summary>
        /// Move the stepper motor a specified number of steps at a
        /// specified rate.
        /// </summary>
        /// <param name="steps">Number of steps to move.
        /// Negative values indicate reverse motion and positive values
        /// indicate forward motion.  (The directions are nominal and depend on
        /// how the stepper motor coils are wired).  Zero indicates the stepper
        /// motor should be stopped.</param>
        /// <param name="rate">The rate of movement, in steps per second.
        /// Negative values indicate reverse motion and positive values
        /// indicate forward motion.  (The directions are nominal and depend on
        /// how the stepper motor coils are wired).  Zero indicates the stepper
        /// motor should be stopped.</param>
        void Move(int steps, float rate);

        /// <summary>
        /// Read-only property returning the number of steps a stepper motor
        /// has.
        /// </summary>
        int StepsPerRotation
        {
            get;
        }
    }
}
