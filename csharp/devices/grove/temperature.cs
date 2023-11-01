// Seeed Studio Grove Temperature Sensor (thermistor) Services

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

namespace IO.Devices.Grove.Temperature
{
    /// <summary>
    /// Encapsulates the Seeed Studio Grove Temperature Sensor (thermistor).
    /// </summary>
    public class Device : IO.Interfaces.Temperature.Sensor
    {
        // Module physical parameters

        private const double B = 4250.0;
        private const double R0 = 100000.0;
        private const double T0 = 298.15;
        private const double Rs = 100000.0;

        private readonly IO.Interfaces.ADC.Voltage myVin;
        private readonly double myVcc;
        private readonly IO.Devices.Thermistor.NTC_B myTh;

        /// <summary>
        /// Constructor for a Seeed Studio Grove Temperature Sensor
        /// (thermistor).
        /// </summary>
        /// <param name="Vin">Voltage input object.</param>
        /// <param name="Vcc">Reference voltage.</param>
        public Device(IO.Interfaces.ADC.Voltage Vin, double Vcc = 3.3)
        {
            myVin = Vin;
            myVcc = Vcc;
            myTh = new IO.Devices.Thermistor.NTC_B(B, R0, T0);
        }

        /// <summary>
        /// Read-only property returning the temperature in Kelvins.
        /// </summary>
        public double Kelvins
        {
            get
            {
                return myTh.Kelvins(myVcc * Rs / myVin.voltage - Rs);
            }
        }
        /// <summary>
        /// Read-only property returning the temperature in degrees Celsius.
        /// </summary>
        public double Celsius
        {
            get
            {
                return IO.Interfaces.Temperature.Conversions.KelvinsToCelsius(Kelvins);
            }
        }

        /// <summary>
        /// Read-only property returning the temperature in degrees Fahrenheit.
        /// </summary>
        public double Fahrenheit
        {
            get
            {
                return IO.Interfaces.Temperature.Conversions.KelvinsToFahrenheit(Kelvins);
            }
        }
    }
}
