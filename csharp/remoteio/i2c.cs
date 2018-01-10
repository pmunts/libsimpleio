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

using System;
using IO.Interfaces.Message64;

namespace IO.Remote
{
    public partial class Device
    {
        /// <summary>
        /// Query available I<sup>2</sup>C buses.
        /// </summary>
        /// <returns>List of available I<sup>2</sup>C bus numbers.</returns>
        public System.Collections.Generic.List<int> I2C_Available()
        {
            return Available(PeripheralTypes.I2C);
        }

        /// <summary>
        /// Create a remote I<sup>2</sup>C bus controller.
        /// </summary>
        /// <param name="num">I<sup>2</sup>C bus number: 0 to 127.</param>
        /// <param name="speed">I<sup>2</sup>C bus clock frequency in Hz</param>
        /// <returns>I<sup>2</sup>C bus controller object.</returns>
        public IO.Interfaces.I2C.Bus I2C_Create(int num,
            int speed = IO.Interfaces.I2C.Speeds.StandardMode)
        {
            return new I2C(this, num, speed);
        }
    }

    /// <summary>
    /// Encapsulates remote I<sup>2</sup>C buses.
    /// </summary>
    public class I2C: IO.Interfaces.I2C.Bus
    {
        private Device device;
        private int num;

        /// <summary>
        /// Create a remote I<sup>2</sup>C bus controller.
        /// </summary>
        /// <param name="dev">Remote I/O device object.</param>
        /// <param name="num">I<sup>2</sup>C bus number: 0 to 127.</param>
        /// <param name="speed">I<sup>2</sup>C bus clock frequency in Hz</param>
        /// <remarks>Use <c>Device.I2C_Create()</c> instead of this constructor.</remarks>
        public I2C(Device dev, int num,
            int speed = IO.Interfaces.I2C.Speeds.StandardMode)
        {
            this.device = dev;
            this.num = (byte)num;

            // Validate parameters

            if ((num < 0) || (num >= Device.MAX_CHANNELS))
                throw new Exception("Invalid I2C bus number");

            if ((speed < 0) || (speed > IO.Interfaces.I2C.Speeds.FastModePlus))
                throw new Exception("Invalid I2C bus speed");

            Message cmd = new Message(0);
            Message resp = new Message();

            cmd.payload[0] = (byte)MessageTypes.I2C_CONFIGURE_REQUEST;
            cmd.payload[1] = 6;
            cmd.payload[2] = (byte)num;
            cmd.payload[3] = (byte)((speed >> 24) & 0xFF);
            cmd.payload[4] = (byte)((speed >> 16) & 0xFF);
            cmd.payload[5] = (byte)((speed >> 8) & 0xFF);
            cmd.payload[6] = (byte)(speed & 0xFF);

            device.Dispatcher(cmd, resp);
        }

        /// <summary>
        /// Read bytes from an I<sup>2</sup>C slave device.
        /// </summary>
        /// <param name="slaveaddr">I<sup>2</sup>C slave address.</param>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read.</param>
        public void Read(int slaveaddr, byte[] resp, int resplen)
        {
            // Validate parameters

            if ((slaveaddr < 0) || (slaveaddr > 255))
                throw new Exception("Invalid I2C slave address");

            if ((resplen < 1) || (resplen > 60) || (resp.Length < resplen))
                throw new Exception("Invalid response length");

            Message cmsg = new Message(0);
            Message rmsg = new Message();

            cmsg.payload[0] = (byte)MessageTypes.I2C_TRANSACTION_REQUEST;
            cmsg.payload[1] = 7;
            cmsg.payload[2] = (byte)this.num;
            cmsg.payload[3] = (byte)slaveaddr;
            cmsg.payload[4] = 0;
            cmsg.payload[5] = (byte)resplen;

            this.device.Dispatcher(cmsg, rmsg);

            for (int i = 0; i < resplen; i++)
                resp[i] = rmsg.payload[i + 4];
        }

        /// <summary>
        /// Write bytes to an I<sup>2</sup>C slave device.
        /// </summary>
        /// <param name="slaveaddr">I<sup>2</sup>C slave address.</param>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write.</param>
        public void Write(int slaveaddr, byte[] cmd, int cmdlen)
        {
            // Validate parameters

            if ((slaveaddr < 0) || (slaveaddr > 255))
                throw new Exception("Invalid I2C slave address");

            if ((cmdlen < 1) || (cmdlen > 58) || (cmd.Length < cmdlen))
                throw new Exception("Invalid command length");

            Message cmsg = new Message(0);
            Message rmsg = new Message();

            for (int i = 0; i < cmdlen; i++)
              cmsg.payload[i + 6] = cmd[i];

            cmsg.payload[0] = (byte)MessageTypes.I2C_TRANSACTION_REQUEST;
            cmsg.payload[1] = 7;
            cmsg.payload[2] = (byte)this.num;
            cmsg.payload[3] = (byte)slaveaddr;
            cmsg.payload[4] = (byte)cmdlen;
            cmsg.payload[5] = 0;

            this.device.Dispatcher(cmsg, rmsg);
        }

        /// <summary>
        /// Write and read bytes to and from an I<sup>2</sup>C slave device.
        /// </summary>
        /// <param name="slaveaddr">I<sup>2</sup>C slave address.</param>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write.</param>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read.</param>
        public void Transaction(int slaveaddr, byte[] cmd, int cmdlen,
            byte[] resp, int resplen)
        {
            // Validate parameters

            if ((slaveaddr < 0) || (slaveaddr > 255))
                throw new Exception("Invalid I2C slave address");

            if ((cmdlen < 1) || (cmdlen > 58) || (cmd.Length < cmdlen))
                throw new Exception("Invalid command length");

            if ((resplen < 1) || (resplen > 60) || (resp.Length < resplen))
                throw new Exception("Invalid response length");

            Message cmsg = new Message(0);
            Message rmsg = new Message();

            for (int i = 0; i < cmdlen; i++)
              cmsg.payload[i + 6] = cmd[i];

            cmsg.payload[0] = (byte)MessageTypes.I2C_TRANSACTION_REQUEST;
            cmsg.payload[1] = 7;
            cmsg.payload[2] = (byte)this.num;
            cmsg.payload[3] = (byte)slaveaddr;
            cmsg.payload[4] = (byte)cmdlen;
            cmsg.payload[5] = (byte)resplen;

            this.device.Dispatcher(cmsg, rmsg);

            for (int i = 0; i < resplen; i++)
                resp[i] = rmsg.payload[i + 4];
        }
    }
}
