// Seeed Studio Grove I2C ADC (ADC121C021) Services

// Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Devices.Grove.ADC
{
    /// <summary>
    /// Encapsulates the Seeed Studio Grove I<sup>2</sup>C ADC (ADC121C021).
    /// </summary>
    public class Device
    {
        private readonly IO.Interfaces.ADC.Input myinput;

        /// <summary>
        /// Constructor for a Seeed Studio Grove I<sup>2</sup>C ADC
        /// (ADC121C021).
        /// </summary>
        /// <param name="bus">I<sup>2</sup>C bus object.</param>
        /// <param name="addr">I<sup>2</sup>C device address.</param>
        public Device(IO.Interfaces.I2C.Bus bus, byte addr = 0x50)
        {
            myinput =
                new IO.Interfaces.ADC.Input(new IO.Devices.ADC121C021.Sample(bus, addr),
                3.0, 0.5);
        }

        /// <summary>
        /// Read-only property returning an analog input voltage measurement.
        /// </summary>
        public double voltage
        {
            get
            {
                return myinput.voltage;
            }
        }
    }
}
