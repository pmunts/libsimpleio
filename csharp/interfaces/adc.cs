// Abstract interface for an ADC input

// Copyright (C)2017, Philip Munts, President, Munts AM Corp.
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
        private Sample inp;
        private double stepsize;
        private double offset;

        /// <summary>
        /// Create an ADC voltage input.
        /// </summary>
        /// <param name="inp">ADC input object.</param>
        /// <param name="stepsize">ADC step size in volts.</param>
        /// <param name="offset">ADC input offset in volts.</param>
        public Input(Sample inp, double stepsize,
            double offset = 0.0)
        {
            if (stepsize <= 0.0)
            {
                throw new System.Exception("stepsize parameter is invalid");
            }

            this.inp = inp;
            this.stepsize = stepsize;
            this.offset = offset;
        }

        /// <summary>
        /// Create an ADC voltage input.
        /// </summary>
        /// <param name="inp">ADC input object.</param>
        /// <param name="resolution">ADC resolution in bits.</param>
        /// <param name="reference">ADC reference in volts.</param>
        /// <param name="gain">Analog input gain in volts per volt.</param>
        /// <param name="offset">Analog input offset in volts.</param>
        public Input(Sample inp, int resolution,
            double reference, double gain = 1.0, double offset = 0.0)
        {
            if (resolution < 1)
            {
                throw new System.Exception("resolution parameter is invalid");
            }

            if (reference == 0.0)
            {
                throw new System.Exception("reference parameter is invalid");
            }

            if (gain == 0.0)
            {
                throw new System.Exception("gain parameter is invalid");
            }

            this.inp = inp;
            this.stepsize = reference / System.Math.Pow(2, resolution) / gain;
            this.offset = offset;
        }

        /// <summary>
        /// Read-only property returning the analog input voltage.
        /// </summary>
        public double voltage
        {
            get
            {
                return this.inp.sample * this.stepsize - this.offset;
            }
        }
    }
}
