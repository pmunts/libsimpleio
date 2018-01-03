// I2C bus controller services using libsimpleio

// Copyright (C)2017, Philip Munts, President, Munts AM Corp.
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

using EmbeddedLinux.Exceptions;

namespace EmbeddedLinux.I2C
{
    /// <summary>
    /// Encapsulates Linux I<sup>2</sup>C bus controllers using <c>libsimpleio</c>.
    /// </summary>
    public class Bus_libsimpleio : IO.Interfaces.I2C.Bus
    {
        private int myfd;

        /// <summary>
        /// Constructor for a single I<sup>2</sup>C bus controller.
        /// </summary>
        /// <param name="devname">Device node name.</param>
        public Bus_libsimpleio(string devname)
        {
            int error;

            libsimpleio.libI2C.I2C_open(devname, out this.myfd, out error);

            if (error != 0)
            {
                throw new Exception("I2C_open() failed", error);
            }
        }

        /// <summary>
        /// Read bytes from an I<sup>2</sup>C device.
        /// </summary>
        /// <param name="slaveaddr">Slave device address.</param>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read.</param>
        public void Read(int slaveaddr, byte[] resp, int resplen)
        {
            if ((slaveaddr < 0) || (slaveaddr > 127))
            {
                throw new Exception("Invalid slave address");
            }

            if ((resplen < 0) || (resplen > resp.Length))
            {
                throw new Exception("Invalid response length");
            }

            byte[] cmd = new byte[1];
            int error;

            libsimpleio.libI2C.I2C_transaction(this.myfd, slaveaddr, cmd, 0,
                resp, resplen, out error);

            if (error != 0)
            {
                throw new Exception("I2C_transaction() failed", error);
            }
        }

        /// <summary>
        /// Write bytes to an I<sup>2</sup>C device.
        /// </summary>
        /// <param name="slaveaddr">Slave device address.</param>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write.</param>
        public void Write(int slaveaddr, byte[] cmd, int cmdlen)
        {
            if ((slaveaddr < 0) || (slaveaddr > 127))
            {
                throw new Exception("Invalid slave address");
            }

            if ((cmdlen < 0) || (cmdlen > cmd.Length))
            {
                throw new Exception("Invalid command length");
            }

            byte[] resp = new byte[1];
            int error;

            libsimpleio.libI2C.I2C_transaction(this.myfd, slaveaddr, cmd,
                cmdlen, resp, 0, out error);

            if (error != 0)
            {
                throw new Exception("I2C_transaction() failed", error);
            }
        }

        /// <summary>
        /// Write and receive bytes to/from an I<sup>2</sup>C device.
        /// </summary>
        /// <param name="slaveaddr">Device slave address.</param>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write.</param>
        /// <param name="delayus">Delay in microseconds between write and read
        /// operations.</param>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read.</param>
        public void Transaction(int slaveaddr, byte[] cmd, int cmdlen, int delayus,
            byte[] resp, int resplen)
        {
            if ((slaveaddr < 0) || (slaveaddr > 127))
            {
                throw new Exception("Invalid slave address");
            }

            if (delayus < 0)
            {
                throw new Exception("Invalid transaction delay");
            }

            if ((cmdlen < 0) || (cmdlen > cmd.Length))
            {
                throw new Exception("Invalid command length");
            }

            if ((resplen < 0) || (resplen > resp.Length))
            {
                throw new Exception("Invalid response length");
            }

            int error;

            libsimpleio.libI2C.I2C_transaction(this.myfd, slaveaddr, cmd,
                cmdlen, resp, resplen, out error);

            if (error != 0)
            {
                throw new Exception("I2C_transaction() failed", error);
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for the I<sup>2</sup>C bus controller.
        /// </summary>
        public int fd
        {
            get
            {
                return this.myfd;
            }
        }
    }
}
