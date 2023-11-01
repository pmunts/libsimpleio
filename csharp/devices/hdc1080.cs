// Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Devices.HDC1080
{
    /// <summary>
    /// Encapsulates the HDC1080 temperature and humidity sensor.
    /// </summary>
    public class Device : IO.Interfaces.Temperature.Sensor,
        IO.Interfaces.Humidity.Sensor
    {
        private readonly IO.Interfaces.I2C.Device dev;
        private byte[] cmd = { 0, 0, 0 };
        private byte[] resp = { 0, 0 };

        /// <summary>
        /// Temperature Register address.
        /// </summary>
        public const byte RegTemperature = 0x00;

        /// <summary>
        /// Humidity Register address.
        /// </summary>
        public const byte RegHumidity = 0x01;

        /// <summary>
        /// Configuration Register address.
        /// </summary>
        public const byte RegConfiguration = 0x02;

        /// <summary>
        /// Serial Number First Bits Register address.
        /// </summary>
        public const byte RegSerialNumberFirst = 0xFB;

        /// <summary>
        /// Serial Number Middle Bits Register address.
        /// </summary>
        public const byte RegSerialNumberMid = 0xFC;

        /// <summary>
        /// Serial Number Last Bits Register address.
        /// </summary>
        public const byte RegSerialNumberLast = 0xFD;

        /// <summary>
        /// Manufacturer ID Register address.
        /// </summary>
        public const byte RegManufacturerID = 0xFE;

        /// <summary>
        /// Device ID Register address.
        /// </summary>
        public const byte RegDeviceID = 0xFF;

        /// <summary>
        /// Constructor for an HDC1080 temperature and humidity sensor object.
        /// </summary>
        /// <param name="bus">I<sup>2</sup>C bus controller.</param>
        public Device(IO.Interfaces.I2C.Bus bus)
        {
            this.dev = new IO.Interfaces.I2C.Device(bus, 0x40);

            // Issue software reset

            this.Write(RegConfiguration, 0x8000);
            System.Threading.Thread.Sleep(100);

            // Heater off, acquire temp or humidity, 14 bit resolutions

            this.Write(RegConfiguration, 0x0000);
        }

        /// <summary>
        /// Read from an HDC1080 device register.
        /// </summary>
        /// <param name="reg">8-bit register address.</param>
        /// <returns>16-bit register data</returns>
        public ushort Read(byte reg)
        {
            int delayus = 0;

            if ((reg > RegConfiguration) && (reg < RegSerialNumberFirst))
                throw new System.Exception("Invalid register address");

            if ((reg == RegTemperature) || (reg == RegHumidity))
                delayus = 10000;

            this.cmd[0] = reg;
            this.dev.Transaction(cmd, 1, resp, 2, delayus);
            return (ushort)((resp[0] << 8) + resp[1]);
        }

        /// <summary>
        /// Write to an HDC1080 device register.
        /// </summary>
        /// <param name="reg">8-bit register address.</param>
        /// <param name="data">16-bit register data.</param>
        public void Write(byte reg, ushort data)
        {
            if ((reg > RegConfiguration) && (reg < RegSerialNumberFirst))
                throw new System.Exception("Invalid register address");

            this.cmd[0] = reg;
            this.cmd[1] = (byte)(data / 256);
            this.cmd[2] = (byte)(data % 256);
            this.dev.Write(this.cmd, 3);
        }

        /// <summary>
        /// Read-only property returning the temperature in degrees Celsius.
        /// </summary>
        public double Celsius
        {
            get
            {
                return ((double)(Read(RegTemperature))) / 65536.0 * 165.0 - 40.0;
            }
        }

        /// <summary>
        /// Read-only property returning the temperature in Kelvins.
        /// </summary>
        public double Kelvins
        {
            get
            {
                return IO.Interfaces.Temperature.Conversions.CelsiusToKelvins(Celsius);
            }
        }

        /// <summary>
        /// Read-only property returning the temperature in degrees Fahrenheit.
        /// </summary>
        public double Fahrenheit
        {
            get
            {
                return IO.Interfaces.Temperature.Conversions.CelsiusToFahrenheit(Celsius);
            }
        }

        /// <summary>
        /// Read-only property returning the percentage relative humidity.
        /// </summary>
        public double Humidity
        {
            get
            {
                return ((double)(Read(RegHumidity)))/65536.0*100.0;
            }
        }

        /// <summary>
        /// Read-only property returning the manufacturer ID.
        /// </summary>
        public ushort ManufacturerID
        {
            get
            {
                return Read(RegManufacturerID);
            }
        }

        /// <summary>
        /// Read-only property returning the device ID.
        /// </summary>
        public ushort DeviceID
        {
            get
            {
                return Read(RegDeviceID);
            }
        }
    }
}
