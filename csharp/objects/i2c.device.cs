// I2C device class

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

using IO.Interfaces.I2C;

namespace IO.Devices.I2C
{
    /// <summary>
    /// Encapsulates I<sup>2</sup>C slave devices.
    /// </summary>
    public class Device
    {
        private Bus bus;
        private int addr;

        /// <summary>
        /// Create an I<sup>2</sup>C slave device.
        /// </summary>
        /// <param name="bus">I<sup>2</sup>C bus controller object.</param>
        /// <param name="slaveaddr">I<sup>2</sup>C slave address.</param>
        public Device(Bus bus, int slaveaddr)
        {
            if ((slaveaddr < 0) || (slaveaddr > 127))
            {
                throw new System.Exception("Invalid slave address");
            }

            this.bus = bus;
            this.addr = slaveaddr;
        }

        /// <summary>
        /// Read bytes from an I<sup>2</sup>C slave device.
        /// </summary>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read.</param>
        public void Read(byte[] resp, int resplen)
        {
            this.bus.Read(this.addr, resp, resplen);
        }

        /// <summary>
        /// Write bytes to an I<sup>2</sup>C slave device.
        /// </summary>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write.</param>
        public void Write(byte[] cmd, int cmdlen)
        {
            this.bus.Write(this.addr, cmd, cmdlen);
        }

        /// <summary>
        /// Write and read bytes to and from an I<sup>2</sup>C slave device.
        /// </summary>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write.</param>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read.</param>
        public void Transaction(byte[] cmd, int cmdlen, byte[] resp, int resplen)
        {
            this.bus.Transaction(this.addr, cmd, cmdlen, resp, resplen);
        }
    }
}
