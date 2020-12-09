// Abstract interface for an I2C bus controller

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

namespace IO.Interfaces.I2C
{
    /// <summary>
    /// I<sup>2</sup>C bus speed constants.
    /// </summary>
    public static class Speeds
    {
        /// <summary>
        /// Standard Mode
        /// </summary>
        public const int StandardMode = 100000;

        /// <summary>
        /// Fast Mode
        /// </summary>
        public const int FastMode = 400000;

        /// <summary>
        /// Fast Mode Plus
        /// </summary>
        public const int FastModePlus = 1000000;
    }

    /// <summary>
    /// Abstract interface for I<sup>2</sup>C bus controllers.
    /// </summary>
    public interface Bus
    {
        /// <summary>
        /// Read bytes from an I<sup>2</sup>C slave device.
        /// </summary>
        /// <param name="slaveaddr">I<sup>2</sup>C slave address.</param>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read.</param>
        void Read(int slaveaddr, byte[] resp, int resplen);

        /// <summary>
        /// Write bytes to an I<sup>2</sup>C slave device.
        /// </summary>
        /// <param name="slaveaddr">I<sup>2</sup>C slave address.</param>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write.</param>
        void Write(int slaveaddr, byte[] cmd, int cmdlen);

        /// <summary>
        /// Write and read bytes to and from an I<sup>2</sup>C slave device.
        /// </summary>
        /// <param name="slaveaddr">I<sup>2</sup>C slave address.</param>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write.</param>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read.</param>
        /// <param name="delayus">Delay in microseconds between the I<sup>2</sup>C
        /// write and read cycles.  Allowed values are 0 to 65535 microseconds.</param>
        void Transaction(int slaveaddr, byte[] cmd, int cmdlen, byte[] resp,
            int resplen, int delayus = 0);
    }

    /// <summary>
    /// Encapsulates a single I<sup>2</sup>C slave device.
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
        /// <param name="delayus">Delay in microseconds between the I<sup>2</sup>C
        /// write and read cycles.  Allowed values are 0 to 65535 microseconds.</param>
        public void Transaction(byte[] cmd, int cmdlen, byte[] resp,
            int resplen, int delayus = 0)
        {
            this.bus.Transaction(this.addr, cmd, cmdlen, resp, resplen, delayus);
        }
    }
}
