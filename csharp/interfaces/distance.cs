// Abstract Interface for Distance Sensors

// Copyright (C)2026, Philip Munts dba Munts Technologies.
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

namespace IO.Interfaces.Distance
{
    /// <summary>
    /// Abstract interface for distance sensors.
    /// </summary>
    public interface Sensor
    {
        /// <summary>
        /// Read-only property returning the distance to an object in
        /// <b>meters</b>.
        /// </summary>
        double meters
        {
            get;
        }
        /// <summary>
        /// Read-only property returning the distance to an object in
        /// <b>centimeters</b>.
        /// </summary>
        double centimeters
        {
            get;
        }
        /// <summary>
        /// Read-only property returning the distance to an object in
        /// <b>inches</b>.
        /// </summary>
        double inches
        {
            get;
        }
    }

    /// <summary>
    /// Distance conversion functions.
    /// </summary>
    /// <remarks>
    /// Conversion factors for meters to Standard <i>aka</i> English units
    /// were extracted from the <i>CRC Handbook of Chemistry and Physics 60th
    /// Edition</i>, page F-321.
    /// </remarks>
    public class Conversions
    {
        /// <summary>
        /// Convert meters to milliimeters
        /// </summary>
        /// <param name="meters">Distance in meters.</param>
        /// <returns>Distance in milliimeters.</returns>
        public static double MetersToMillimeters(double meters)
        {
            return meters*1000.0;
        }

        /// <summary>
        /// Convert meters to centimeters
        /// </summary>
        /// <param name="meters">Distance in meters.</param>
        /// <returns>Distance in centimeters.</returns>
        public static double MetersToCentimeters(double meters)
        {
            return meters*100.0;
        }

        /// <summary>
        /// Convert meters to kilometers
        /// </summary>
        /// <param name="meters">Distance in meters.</param>
        /// <returns>Distance in kilometers.</returns>
        public static double MetersToKilometers(double meters)
        {
            return meters/1000.0;
        }

        /// <summary>
        /// Convert meters to inches
        /// </summary>
        /// <param name="meters">Distance in meters.</param>
        /// <returns>Distance in inches.</returns>
        public static double MetersToInches(double meters)
        {
            return meters*39.370079;
        }

        /// <summary>
        /// Convert meters to feet
        /// </summary>
        /// <param name="meters">Distance in meters.</param>
        /// <returns>Distance in feet.</returns>
        public static double MetersToFeet(double meters)
        {
            return meters*3.2808399;
        }

        /// <summary>
        /// Convert meters to yards
        /// </summary>
        /// <param name="meters">Distance in meters.</param>
        /// <returns>Distance in yarts.</returns>
        public static double MetersToYards(double meters)
        {
            return meters*1.0936133;
        }

        /// <summary>
        /// Convert meters to statute miles
        /// </summary>
        /// <param name="meters">Distance in meters.</param>
        /// <returns>Distance in statute miles.</returns>
        public static double MetersToMiles(double meters)
        {
            return meters*0.00062137119;
        }
    }
}
