// Abstract interface for an ADC input

// Copyright (C)2017-2018-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Interfaces.ADC
{
    /// <summary>
    /// Abstract interface for ADC inputs returning an integer sample value.
    /// </summary>
    public interface Sample
    {
        /// <summary>
        /// Read-only property returning an integer analog sample value.
        /// </summary>
        int sample
        {
            get;
        }

        /// <summary>
        /// Read-only property returning the number of bits of resolution.
        /// </summary>
        int resolution
        {
            get;
        }
    }

    /// <summary>
    /// Abstract interface for ADC inputs returning a floating point voltage
    /// value.
    /// </summary>
    public interface Voltage
    {
        /// <summary>
        /// Read-only property returning a floating point analog voltage value.
        /// </summary>
        double voltage
        {
            get;
        }
    }

    /// <summary>
    /// Encapsulates ADC voltage inputs.
    /// </summary>
    public class Input: Voltage
    {
        private readonly Sample input;
        private readonly double stepsize;

        /// <summary>
        /// Create an ADC voltage input.
        /// </summary>
        /// <param name="input">ADC sample object.</param>
        /// <param name="reference">ADC reference in volts.</param>
        /// <param name="gain">ADC input gain in volts per volt.</param>
        public Input(Sample input, double reference, double gain = 1.0)
        {
            if (reference == 0.0)
            {
                throw new System.Exception("reference parameter is invalid");
            }

            if (gain == 0.0)
            {
                throw new System.Exception("gain parameter is invalid");
            }

            this.input = input;

            this.stepsize =
                reference / System.Math.Pow(2, input.resolution) / gain;
        }

        /// <summary>
        /// Read-only property returning the analog input voltage.
        /// </summary>
        public double voltage
        {
            get
            {
                return this.input.sample * this.stepsize;
            }
        }
    }
}
