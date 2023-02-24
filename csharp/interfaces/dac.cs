// Abstract interface for an DAC (Digital to Analog Converter) input

// Copyright (C)2018-2023, Philip Munts.
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

namespace IO.Interfaces.DAC
{
    /// <summary>
    /// Abstract interface for DAC outputs accepting an integer output sample
    /// value.
    /// </summary>
    public interface Sample
    {
        /// <summary>
        /// Write-only property for setting the DAC output level.
        /// </summary>
        int sample
        {
            set;
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
    /// Abstract interface for DAC outputs accepting a floating point
    /// output voltage value.
    /// </summary>
    public interface Voltage
    {
        /// <summary>
        /// Write-only property for setting the DAC output voltage.
        /// </summary>
        double voltage
        {
            set;
        }
    }

    /// <summary>
    /// Encapsulates DAC voltage outputs.
    /// </summary>
    public class Output : Voltage
    {
        private readonly Sample output;
        private readonly double stepsize;

        /// <summary>
        /// Create an DAC voltage output.
        /// </summary>
        /// <param name="output">DAC output object.</param>
        /// <param name="reference">DAC output reference in volts.</param>
        /// <param name="gain">DAC output gain in volts per volt.</param>
        public Output(Sample output, double reference, double gain = 1.0)
        {
            if (reference == 0.0)
            {
                throw new System.Exception("reference parameter is invalid");
            }

            if (gain == 0.0)
            {
                throw new System.Exception("gain parameter is invalid");
            }

            this.output = output;

            this.stepsize =
                reference / System.Math.Pow(2, output.resolution) / gain;
        }

        /// <summary>
        /// Write-only for setting the DAC output voltage.
        /// </summary>
        public double voltage
        {
            set
            {
                this.output.sample = (int)(value / this.stepsize + 0.5);
            }
        }
    }
}
