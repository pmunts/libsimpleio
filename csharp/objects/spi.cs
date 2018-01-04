// SPI device services using libsimpleio

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

using libsimpleio.Exceptions;

namespace libsimpleio.SPI
{
    /// <summary>
    /// Encapsulates Linux SPI devices using <c>libsimpleio</c>.
    /// </summary>
    public class Device: IO.Interfaces.SPI.Device
    {
        /// <summary>
        /// Use hardware slave select.
        /// </summary>
        public const int AUTOCHIPSELECT = -1;

        private int myfd;
        private int myfdcs;

        /// <summary>
        /// Constructor for a single SPI device.
        /// </summary>
        /// <param name="devname">Device node name.</param>
        /// <param name="mode">SPI clock mode.</param>
        /// <param name="wordsize">SPI transfer word size.</param>
        /// <param name="speed">SPI transfer speed.</param>
        /// <param name="cspin">SPI slave select GPIO pin number, or
        /// <c>AUTOCHIPSELECT</c>.</param>
        public Device(string devname, int mode, int wordsize,
            int speed, int cspin = AUTOCHIPSELECT)
        {
            int error;

            this.myfdcs = AUTOCHIPSELECT;

            libsimpleio.libSPI.SPI_open(devname, mode, wordsize, speed,
                out this.myfd, out error);

            if (error != 0)
            {
                throw new Exception("SPI_open() failed", error);
            }

            if (cspin != AUTOCHIPSELECT)
            {
                libsimpleio.libGPIO.GPIO_configure(cspin,
                    libsimpleio.libGPIO.DIRECTION_OUTPUT, 1,
                    libsimpleio.libGPIO.EDGE_NONE,
                    libsimpleio.libGPIO.POLARITY_ACTIVEHIGH, out error);

                if (error != 0)
                {
                    throw new Exception("GPIO_configure() failed", error);
                }

                libsimpleio.libGPIO.GPIO_open(cspin, out this.myfdcs,
                    out error);

                if (error != 0)
                {
                    throw new Exception("GPIO_open() failed", error);
                }
            }
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

            libsimpleio.libSPI.SPI_transaction(this.myfd, this.myfdcs, cmd, 0,
                0, resp, resp.Length, out error);

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

            libsimpleio.libSPI.SPI_transaction(this.myfd, this.myfdcs, cmd,
                cmd.Length, 0, resp, resp.Length, out error);

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
        public void Transaction(byte[] cmd, int cmdlen, int delayus,
            byte[] resp, int resplen)
        {
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

            libsimpleio.libSPI.SPI_transaction(this.myfd, this.myfdcs, cmd,
                cmd.Length, delayus, resp, resp.Length, out error);

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
