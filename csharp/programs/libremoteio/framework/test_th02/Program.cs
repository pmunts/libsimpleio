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

using System;
using System.Threading;

namespace TH02
{
    /// <summary>
    /// Encapsulates the TH02 temperature and humidity sensor.
    /// </summary>
    public class Device
    {
        // TH02 register addresses

        private static byte STATUS = 0;
        private static byte DATAH = 1;
        private static byte DATAL = 2;
        private static byte CONFIG = 3;
        private static byte ID = 17;

        private IO.Interfaces.I2C.Device i2cdev;

        /// <summary>
        /// Constructor for a TH02 temperature and humidity sensor device object.
        /// </summary>
        /// <param name="bus">I<sup>2</sup>C bus controller.</param>
        /// <param name="addr">I<sup>2</sup>C slave address.</param>
        public Device(IO.Interfaces.I2C.Bus bus, byte addr = 0x40)
        {
            this.i2cdev = new IO.Interfaces.I2C.Device(bus, addr);

            this.WriteRegister(CONFIG, 0x00);
        }

        private void WriteRegister(byte addr, byte data)
        {
            byte[] cmd = new byte[2] { addr, data };

            this.i2cdev.Write(cmd, cmd.Length);
        }

        private byte ReadRegister(byte addr)
        {
            byte[] cmd = new byte[1] { addr };
            byte[] resp = new byte[1];

            this.i2cdev.Transaction(cmd, cmd.Length, resp, resp.Length);
            return resp[0];
        }

        private ushort ReadResult()
        {
            byte[] cmd = new byte[1] { DATAH };
            byte[] resp = new byte[2];

            this.i2cdev.Transaction(cmd, cmd.Length, resp, resp.Length);
            return (ushort)((resp[0] << 8) + resp[1]);
        }

        /// <summary>
        /// Read-only property returning a temperature measurement.
        /// </summary>
        public double temperature
        {
            get
            {
                // Start conversion

                this.WriteRegister(CONFIG, 0x11);

                // Poll until done

                while ((ReadRegister(STATUS) & 0x01) != 0x01);

                // Return the temperature

                return (this.ReadResult() >> 2)/32.0 - 50.0;
            }
        }
    }
}

namespace test_th02
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nUSB HID Remote I/O TH02 Sensor Test\n");

            IO.Remote.Device dev =
                new IO.Remote.Device(new IO.Objects.USB.HID.Messenger());

            IO.Interfaces.I2C.Bus bus = dev.I2C_Create(0);

            TH02.Device sensor = new TH02.Device(bus);

            for (;;)
            {
                Console.WriteLine("Temperature is " + sensor.temperature);
                Thread.Sleep(1000);
            }
        }
    }
}
