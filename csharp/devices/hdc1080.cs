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

namespace IO.Devices.HDC1080
{
    /// <summary>
    /// Encapsulates the HDC1080 temperature and humidity sensor.
    /// </summary>
    public class Device
    {
        private IO.Interfaces.I2C.Device dev;
        private byte[] cmd = { 0, 0, 0 };
        private byte[] resp = { 0, 0 };

        /// <summary>
        /// Temperature Register address.
        /// </summary>
        public const byte RegTemperature = 0x00;

        /// <summary>
        /// Humidity Register address.
        /// </summary>
        public const byte RegHumdity = 0x01;

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
        }

        /// <summary>
        /// Read from an HDC1080 device register.
        /// </summary>
        /// <param name="reg">8-bit register address.</param>
        /// <returns>16-bit register data</returns>
        public ushort Read(byte reg)
        {
            if ((reg > RegConfiguration) && (reg < RegSerialNumberFirst))
                throw new System.Exception("Invalid register address");

            this.cmd[0] = reg;
            this.dev.Transaction(cmd, 1, resp, 2);
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
    }
}