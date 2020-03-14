// Model an NTC thermistor with the B parameter formula

// Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

using static System.Math;

namespace IO.Devices.Thermistor
{
    /// <summary>
    /// Encapsulate an NTC thermistor.
    /// </summary>
    public class NTC_B
    {
        private readonly double myB;
        private readonly double myR;

        /// <summary>
        /// Constructor for a single NTC thermistor object instance.
        /// </summary>
        /// <param name="B">Thermistor B parameter.</param>
        /// <param name="R0">Thermistor resistance in ohms at the specified
        /// reference temperature.</param>
        /// <param name="T0">Thermistor reference temperature in
        /// Kelvins.</param>
        public NTC_B(double B, double R0, double T0 = 298.15)
        {
            myB = B;
            myR = R0 * Exp(-B / T0);
        }

        /// <summary>
        /// Kelvin temperature as a function of the thermistor resistance.
        /// </summary>
        /// <param name="R">Thermistor resistance in ohms.</param>
        /// <returns>Temperature in Kelvins.</returns>
        public double Kelvins(double R)
        {
            return myB / Log(R / myR);
        }
    }
}
