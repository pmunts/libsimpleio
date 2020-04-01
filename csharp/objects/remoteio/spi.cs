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

using System;
using IO.Interfaces.Message64;

namespace IO.Remote
{
    public partial class Device
    {
        /// <summary>
        /// Query available SPI slave devices.
        /// </summary>
        /// <returns>List of available SPI slave device numbers.</returns>
        public System.Collections.Generic.List<int> SPI_Available()
        {
            return Available(PeripheralTypes.SPI);
        }

        /// <summary>
        /// Create a remote SPI slave device.
        /// </summary>
        /// <param name="num">SPI slave device number: 0 to 127.</param>
        /// <param name="mode">SPI transfer mode: 0 to 3.</param>
        /// <param name="wordsize">SPI transfer word size: 8, 16, or 32.</param>
        /// <param name="speed">SPI transfer speed in bits per second.</param>
        /// <returns>SPI slave device object.</returns>
        /// <remarks><para>The actual SPI transfer rate will be the highest
        /// realizable rate that does not exceed the value specified in
        /// <c>speed</c>.</para></remarks>
        public IO.Interfaces.SPI.Device SPI_Create(int num, int mode,
            int wordsize, int speed)
        {
            return new SPI(this, num, mode, wordsize, speed);
        }
    }

    /// <summary>
    /// Encapsulates remote SPI slave devices.
    /// </summary>
    public class SPI: IO.Interfaces.SPI.Device
    {
        private Device device;
        private int num;

        /// <summary>
        /// Create a remote SPI slave device.
        /// </summary>
        /// <param name="dev">Remote I/O device object.</param>
        /// <param name="num">SPI slave device number: 0 to 127.</param>
        /// <param name="mode">SPI transfer mode: 0 to 3.</param>
        /// <param name="wordsize">SPI transfer word size: 8, 16, or 32.</param>
        /// <param name="speed">SPI transfer speed in bits per second.</param>
        /// <remarks><para>Use <c>Device.SPI_Create()</c> instead of this
        /// constructor.</para>
        /// <para>The actual SPI transfer rate will be the highest realizable
        /// rate that does not exceed the value specified in <c>speed</c>.
        /// </para></remarks>
        public SPI(Device dev, int num, int mode, int wordsize, int speed)
        {
            this.device = dev;
            this.num = (byte)num;

            // Validate parameters

            if ((num < 0) || (num >= Device.MAX_CHANNELS))
                throw new Exception("Invalid SPI slave device number");

            if ((mode < 0) || (mode > 3))
                throw new Exception("Invalid SPI transfer mode");

            if ((wordsize != 8) && (wordsize != 16) && (wordsize != 32))
                throw new Exception("Invalid SPI transfer word size");

            if (speed < 1)
                throw new Exception("Invalid SPI transfer speed");

            Message cmd = new Message(0);
            Message resp = new Message();

            cmd.payload[0] = (byte)MessageTypes.SPI_CONFIGURE_REQUEST;
            cmd.payload[2] = (byte)num;
            cmd.payload[3] = (byte)mode;
            cmd.payload[4] = (byte)wordsize;
            cmd.payload[5] = (byte)(speed >> 24);
            cmd.payload[6] = (byte)(speed >> 16);
            cmd.payload[7] = (byte)(speed >> 8);
            cmd.payload[8] = (byte)(speed >> 0);

            device.Dispatcher(cmd, resp);
        }

        /// <summary>
        /// Read bytes from an SPI slave device.
        /// </summary>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read: 1 to 60.</param>
        public void Read(byte[] resp, int resplen)
        {
            // Validate parameters

            if ((resplen < 1) || (resplen > 60) || (resplen > resp.Length))
                throw new Exception("Invalid response length");

            Message cmsg = new Message(0);
            Message rmsg = new Message();

            cmsg.payload[0] = (byte)MessageTypes.SPI_TRANSACTION_REQUEST;
            cmsg.payload[2] = (byte)this.num;
            cmsg.payload[4] = (byte)resplen;

            this.device.Dispatcher(cmsg, rmsg);

            for (int i = 0; i < resplen; i++)
                resp[i] = rmsg.payload[i + 4];
        }

        /// <summary>
        /// Write bytes to an SPI slave device.
        /// </summary>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write: 1 to 57.</param>
        public void Write(byte[] cmd, int cmdlen)
        {
            // Validate parameters

            if ((cmdlen < 1) || (cmdlen > 57) || (cmdlen > cmd.Length))
                throw new Exception("Invalid command length");

            Message cmsg = new Message(0);
            Message rmsg = new Message();

            cmsg.payload[0] = (byte)MessageTypes.SPI_TRANSACTION_REQUEST;
            cmsg.payload[2] = (byte)this.num;
            cmsg.payload[3] = (byte)cmdlen;

            for (int i = 0; i < cmdlen; i++)
                cmsg.payload[i + 7] = cmd[i];

            this.device.Dispatcher(cmsg, rmsg);
        }

        /// <summary>
        /// Write and read bytes to and from an SPI slave device.
        /// </summary>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write: 0 to 57.</param>
        /// <param name="delayus">Delay in microseconds between write and read
        /// operations: 0 to 65535.</param>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read: 0 to 60.</param>
        public void Transaction(byte[] cmd, int cmdlen, byte[] resp,
            int resplen, int delayus = 0)
        {
            if ((cmd == null) && (resp == null))
                throw new Exception("Command buffer and response buffer are both null");

            if ((cmdlen == 0) && (resplen == 0))
                throw new Exception("Command length and response length are both zero");

            if ((cmd == null) && (cmdlen != 0))
                throw new Exception("Command buffer is null but command length is nonzero");

            if ((cmd != null) && (cmdlen == 0))
                throw new Exception("Command buffer is not null but command length is zero");

            if ((resp == null) && (resplen != 0))
                throw new Exception("Response buffer is null but response length is nonzero");

            if ((resp != null) && (resplen == 0))
                throw new Exception("Response buffer is not null but response length is zero");

            if (cmd != null)
                if ((cmdlen < 1) || (cmdlen > 56) || (cmd.Length < cmdlen))
                    throw new Exception("Invalid command length parameter");

            if (resp != null)
                if ((resplen < 1) || (resplen > 60) || (resp.Length < resplen))
                    throw new Exception("Invalid response length parameter");

            if ((delayus < 0) || (delayus > 65535))
                throw new Exception("Invalid delay parameter");

            Message cmsg = new Message(0);
            Message rmsg = new Message();

            cmsg.payload[0] = (byte)MessageTypes.SPI_TRANSACTION_REQUEST;
            cmsg.payload[2] = (byte)this.num;
            cmsg.payload[3] = (byte)cmdlen;
            cmsg.payload[4] = (byte)resplen;
            cmsg.payload[5] = (byte)(delayus >> 8);
            cmsg.payload[6] = (byte)(delayus >> 0);

            for (int i = 0; i < cmdlen; i++)
                cmsg.payload[i + 7] = cmd[i];

            this.device.Dispatcher(cmsg, rmsg);

            for (int i = 0; i < resplen; i++)
                resp[i] = rmsg.payload[i + 4];
        }
    }
}
