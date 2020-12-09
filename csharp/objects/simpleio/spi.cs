// SPI device services using IO.Objects.libsimpleio

// Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.
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

using IO.Objects.libsimpleio.Exceptions;

namespace IO.Objects.libsimpleio.SPI
{
    /// <summary>
    /// Encapsulates Linux SPI devices using <c>libsimpleio</c>.
    /// </summary>
    public class Device: IO.Interfaces.SPI.Device
    {
        /// <summary>
        /// Use hardware slave select.
        /// </summary>
        public const IO.Objects.libsimpleio.GPIO.Pin AUTOCHIPSELECT = null;

        private int myfd;
        private int myfdcs;

        /// <summary>
        /// Constructor for a single SPI device.
        /// </summary>
        /// <param name="devname">SPI device node name.</param>
        /// <param name="mode">SPI clock mode.</param>
        /// <param name="wordsize">SPI transfer word size.</param>
        /// <param name="speed">SPI transfer speed.</param>
        /// <param name="cspin">SPI slave select GPIO pin number, or
        /// <c>AUTOCHIPSELECT</c>.</param>
        public Device(string devname, int mode, int wordsize,
            int speed, IO.Objects.libsimpleio.GPIO.Pin cspin = AUTOCHIPSELECT)
        {
            IO.Bindings.libsimpleio.SPI_open(devname, mode, wordsize,
                speed, out this.myfd, out int error);

            if (error != 0)
            {
                throw new Exception("SPI_open() failed", error);
            }

            if (cspin == AUTOCHIPSELECT)
                this.myfdcs = IO.Bindings.libsimpleio.SPI_AUTO_CS;
            else
                this.myfdcs = cspin.fd;
        }

        /// <summary>
        /// Constructor for a single SPI device.
        /// </summary>
        /// <param name="desg">SPI device designator.</param>
        /// <param name="mode">SPI clock mode.</param>
        /// <param name="wordsize">SPI transfer word size.</param>
        /// <param name="speed">SPI transfer speed.</param>
        /// <param name="cspin">SPI slave select GPIO pin number, or
        /// <c>AUTOCHIPSELECT</c>.</param>
        public Device(IO.Objects.libsimpleio.Device.Designator desg, int mode,
            int wordsize, int speed,
            IO.Objects.libsimpleio.GPIO.Pin cspin = AUTOCHIPSELECT)
        {
            // Validate the I2C bus designator

            if ((desg.chip == IO.Objects.libsimpleio.Device.Designator.Unavailable.chip) ||
                (desg.chan == IO.Objects.libsimpleio.Device.Designator.Unavailable.chan))
            {
                throw new Exception("Invalid designator");
            }

            System.String devname = System.String.Format("/dev/spidev{0}.{1}",
              desg.chip, desg.chan);

            IO.Bindings.libsimpleio.SPI_open(devname, mode, wordsize,
                speed, out this.myfd, out int error);

            if (error != 0)
            {
                throw new Exception("SPI_open() failed", error);
            }

            if (cspin == AUTOCHIPSELECT)
                this.myfdcs = IO.Bindings.libsimpleio.SPI_AUTO_CS;
            else
                this.myfdcs = cspin.fd;
        }

        /// <summary>
        /// Read bytes from an SPI slave device.
        /// </summary>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read.</param>
        public void Read(byte[] resp, int resplen)
        {
            if ((resplen < 0) || (resplen > resp.Length))
            {
                throw new Exception("Invalid response length");
            }

            byte[] cmd = new byte[1];
            int error;

            IO.Bindings.libsimpleio.SPI_transaction(this.myfd,
                this.myfdcs, null, 0, 0, resp, resp.Length, out error);

            if (error != 0)
            {
                throw new Exception("SPI_transaction() failed", error);
            }
        }

        /// <summary>
        /// Write bytes to an SPI slave device.
        /// </summary>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write.</param>
        public void Write(byte[] cmd, int cmdlen)
        {
            if ((cmdlen < 0) || (cmdlen > cmd.Length))
            {
                throw new Exception("Invalid command length");
            }

            byte[] resp = new byte[1];
            int error;

            IO.Bindings.libsimpleio.SPI_transaction(this.myfd,
                this.myfdcs, cmd, cmdlen, 0, null, 0, out error);

            if (error != 0)
            {
                throw new Exception("SPI_transaction() failed", error);
            }
        }

        /// <summary>
        /// Write and read bytes to and from an SPI slave device.
        /// </summary>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write.</param>
        /// <param name="delayus">Delay in microseconds between write and read
        /// operations.</param>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read.</param>
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

            int error;

            IO.Bindings.libsimpleio.SPI_transaction(this.myfd,
                this.myfdcs, cmd, cmdlen, delayus, resp, resplen,
                out error);

            if (error != 0)
            {
                throw new Exception("SPI_transaction() failed", error);
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for the
        /// SPI slave device.
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
