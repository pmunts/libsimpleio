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

namespace IO.Devices.PCA9534
{
    /// <summary>
    /// Encapsulates PCA9534 (and similar) I<sup>2</sup>C GPIO Expanders.
    /// </summary>
    public class Device
    {
        private readonly IO.Interfaces.I2C.Device dev;
        private byte config;
        private byte latch;
        private byte[] cmd = { 0, 0 };  // I2C command buffer
        private byte[] resp = { 0 };    // I2C response buffer

        /// <summary>
        /// The number of available GPIO pins per chip.
        /// </summary>
        public const int MAX_PINS = 8;

        /// <summary>
        /// Input Port Register address.
        /// </summary>
        public const byte InputPortReg = 0;

        /// <summary>
        /// Output Port Register address.
        /// </summary>
        public const byte OutputPortReg = 1;

        /// <summary>
        /// Input Port Polarity Register address.
        /// </summary>
        public const byte InputPolarityReg = 2;

        /// <summary>
        /// Configuration Register address.
        /// </summary>
        public const byte ConfigurationReg = 3;

        /// <summary>
        /// Configure all pins as inputs.
        /// </summary>
        public const byte AllInputs = 0xFF;

        /// <summary>
        /// Configure all pins as outputs.
        /// </summary>
        public const byte AllOutputs = 0x00;

        /// <summary>
        /// Configure all inputs as normal polarity.
        /// </summary>
        public const byte AllNormal = 0x00;

        /// <summary>
        /// Turn all outputs off.
        /// </summary>
        public const byte AllOff = 0x00;

        /// <summary>
        /// Constructor for a PCA9534 (or similar) GPIO Expander.
        /// </summary>
        /// <param name="bus">I<sup>2</sup>C bus controller.</param>
        /// <param name="addr">I<sup>2</sup>C slave address.</param>
        /// <param name="config">GPIO pin configuration.</param>
        /// <param name="states">Initial output states.</param>
        public Device(IO.Interfaces.I2C.Bus bus, int addr,
          byte config = AllInputs, byte states = AllOff)
        {
            this.dev = new IO.Interfaces.I2C.Device(bus, addr);
            this.Write(ConfigurationReg, config);
            this.Write(InputPolarityReg, AllNormal);
            this.Write(OutputPortReg, states);
        }

        /// <summary>
        /// Read from the specified PCA9534 device register.
        /// </summary>
        /// <param name="addr">Register address.</param>
        /// <returns>Register contents.</returns>
        public byte Read(byte addr)
        {
            if (addr > ConfigurationReg)
                throw new System.Exception("Invalid register address");

            this.cmd[0] = addr;
            this.dev.Transaction(this.cmd, 1, this.resp, 1);
            return this.resp[0];
        }

        /// <summary>
        /// Write to the specified PCA9534 device register.
        /// </summary>
        /// <param name="addr">Register address.</param>
        /// <param name="data">Data to written.</param>
        public void Write(byte addr, byte data)
        {
            if (addr > ConfigurationReg)
                throw new System.Exception("Invalid register address");

            if (addr == InputPortReg)
                throw new System.Exception("Cannot write to input port register");

            this.cmd[0] = addr;
            this.cmd[1] = data;
            this.dev.Write(cmd, 2);

            if (addr == ConfigurationReg)
                this.config = data;
            else if (addr == OutputPortReg)
                this.latch = data;
        }

        /// <summary>
        /// Return actual state of the GPIO pins.
        /// </summary>
        /// <returns>Pin states (MSB = GPIO7).</returns>
        public byte Read()
        {
            return this.Read(InputPortReg);
        }

        /// <summary>
        /// Write all GPIO pins.
        /// </summary>
        /// <param name="data">Data to write to pins (MSB = GPIO7).</param>
        public void Write(byte data)
        {
            this.Write(OutputPortReg, data);
        }

        /// <summary>
        /// This read-only property returns the last value written to the
        /// configuration register.
        /// </summary>
        public byte Config
        {
            get
            {
                return this.config;
            }
        }

        /// <summary>
        /// This read-only property returns the last value written to the
        /// output port register.
        /// </summary>
        public byte Latch
        {
            get
            {
                return this.latch;
            }
        }
    }
}
