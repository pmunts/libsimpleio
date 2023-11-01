// Abstract Interface for Temperature Sensors

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

namespace IO.Interfaces.Temperature
{
    /// <summary>
    /// Abstract interface for temperature sensors.
    /// </summary>
    public interface Sensor
    {
        /// <summary>
        /// Read-only property returning the temperature in Kelvins.
        /// </summary>
        double Kelvins
        {
            get;
        }

        /// <summary>
        /// Read-only property returning the temperature in degrees Celsius.
        /// </summary>
        double Celsius
        {
            get;
        }

        /// <summary>
        /// Read-only property returning the temperature in degrees Fahrenheit.
        /// </summary>
        double Fahrenheit
        {
            get;
        }
    }

    /// <summary>
    /// Temperature conversion functions.
    /// </summary>
    public class Conversions
    {
        /// <summary>
        /// Convert Kelvins to degrees Celsius.
        /// </summary>
        /// <param name="kelvins">Temperature in Kelvins.</param>
        /// <returns>Temperature in degrees Celsius.</returns>
        public static double KelvinsToCelsius(double kelvins)
        {
            return kelvins - 273.15;
        }

        /// <summary>
        /// Convert Kelvins to degrees Fahrenheit.
        /// </summary>
        /// <param name="kelvins">Temperature in Kelivns.</param>
        /// <returns>Temperature in degrees Fahrenheit.</returns>
        public static double KelvinsToFahrenheit(double kelvins)
        {
            return kelvins * 9.0 / 5.0 - 459.67;
        }

        /// <summary>
        /// Convert degrees Celsius to Kelvins.
        /// </summary>
        /// <param name="celsius">Temperature in degrees Celsius.</param>
        /// <returns>Temperature in Kelvins.</returns>
        public static double CelsiusToKelvins(double celsius)
        {
            return celsius + 273.15;
        }

        /// <summary>
        /// Convert degrees Celsius to degrees Fahrenheit.
        /// </summary>
        /// <param name="celsius">Temperature in degrees Celsius.</param>
        /// <returns>Temperature in degrees Fahrenheit.</returns>
        public static double CelsiusToFahrenheit(double celsius)
        {
            return celsius * 9.0 / 5.0 + 32;
        }

        /// <summary>
        /// Convert degrees Fahrenheit to Kelvins.
        /// </summary>
        /// <param name="fahrenheit">Temperature in degrees Fahrenheit.</param>
        /// <returns>Temperature in Kelvins.</returns>
        public static double FahrenheitToKelvins(double fahrenheit)
        {
            return (fahrenheit - 32.0) * 5.0 / 9.0 + 273.15;
        }

        /// <summary>
        /// Convert degrees Fahrenheit to degrees Celsius.
        /// </summary>
        /// <param name="fahrenheit">Temperature in degrees Fahrenheit.</param>
        /// <returns>Temperature in degrees Celsius.</returns>
        public static double FahrenheitToCelsius(double fahrenheit)
        {
            return (fahrenheit - 32.0) * 5.0 / 9.0;
        }
    }
}
