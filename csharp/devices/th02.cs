// Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

namespace IO.Devices.TH02
{
    /// <summary>
    /// Encapsulates the TH02 temperature and humidity sensor.
    /// </summary>
    public class Device : IO.Interfaces.Temperature.Sensor,
        IO.Interfaces.Humidity.Sensor
    {
        private readonly IO.Interfaces.I2C.Device dev;
        private byte[] cmd = { 0, 0, 0 };
        private byte[] resp = { 0, 0 };

        // TH02 register addresses

        private const byte regStatus = 0x00;
        private const byte regDataH = 0x01;
        private const byte regDataL = 0x02;
        private const byte regConfig = 0x03;
        private const byte regID = 0x11;

        // TH02 commands

        private const byte cmdInit = 0x00;  // Turn heater off
        private const byte cmdTemp = 0x11;
        private const byte cmdHumid = 0x01;

        // TH02 status masks

        private const byte mskBusy = 0x01;  // Nonzero during conversion

        // TH02 humidity correction coefficients (from the TH02 datasheet)

        private const double A0 = -4.7844;
        private const double A1 = 0.4008;
        private const double A2 = -0.00393;

        private const double Q0 = 0.1973;
        private const double Q1 = 0.00237;

        /// <summary>
        /// Constructor for an TH02 temperature and humidity sensor object.
        /// </summary>
        /// <param name="bus">I<sup>2</sup>C bus controller.</param>
        public Device(IO.Interfaces.I2C.Bus bus)
        {
            dev = new IO.Interfaces.I2C.Device(bus, 0x40);
            Write(regConfig, cmdInit);
        }

        // Read from an TH02 device register.

        private byte Read(byte reg)
        {
            // Validate parameters

            if (reg > regID)
                throw new System.Exception("Invalid register address");

            if ((reg > regConfig) && (reg < regID))
                throw new System.Exception("Invalid register address");

            // Issue I2C transaction

            cmd[0] = reg;
            dev.Transaction(cmd, 1, resp, 1);
            return resp[0];
        }

        // Write to an TH02 device register.

        private void Write(byte reg, byte data)
        {
            // Validate parameters

            if (reg > regID)
                throw new System.Exception("Invalid register address");

            if ((reg > regConfig) && (reg < regID))
                throw new System.Exception("Invalid register address");

            // Issue I2C transaction

            cmd[0] = reg;
            cmd[1] = data;
            dev.Write(cmd, 2);
        }

        // Get raw sample data

        private ushort Sample(byte what)
        {
          // Start conversion

          Write(regConfig, what);

          // Wait for completion

          while ((Read(regStatus) & mskBusy) != 0);

          // Fetch result

          cmd[0] = regDataH;
          dev.Transaction(cmd, 1, resp, 2);

          // Return result

          return (ushort)(resp[0]*256 + resp[1]);
        }

        /// <summary>
        /// Read-only property returning the temperature in degrees Celsius.
        /// </summary>
        public double Celsius
        {
            get
            {
                return (Sample(cmdTemp) >> 2) / 32.0 - 50.0;
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
                // Get humidity sample

                double RHvalue = (Sample(cmdHumid) >> 4)/16.0 - 24.0;

                // Perform linearization

                double RHlinear = RHvalue -
                  (RHvalue*RHvalue*A2 + RHvalue*A1 + A0);

                // Perform temperature compensation

                return RHlinear + (Celsius - 30.0)*(RHlinear*Q1 + Q0);
            }
        }

        /// <summary>
        /// Read-only property returning the device ID.
        /// </summary>
        public byte DeviceID
        {
            get
            {
                return Read(regID);
            }
        }
    }
}
