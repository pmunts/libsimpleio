// SPI device services using IO.Objects.SimpleIO

// Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Objects.SimpleIO.SPI
{
    /// <summary>
    /// Encapsulates Linux SPI slave devices using <c>libsimpleio</c>.
    /// </summary>
    public class Device: IO.Interfaces.SPI.Device
    {
        private readonly int myfd;
        private readonly int myfdcs;

        private static int SlaveSelect(string devname,
            IO.Objects.SimpleIO.Device.Designator? cspin)
        {
            string ShieldName = System.Environment.GetEnvironmentVariable("SHIELDNAME");

            // Special processing for the Mikroelektronika BeagleBone click
            // SHIELD (MIKROE-1596):  Socket 1 has CS connected to GPIO44
            // instead of SPI1 CS0, so we have to do software slave select.

            if (ShieldName.Equals("BeagleBoneClick2", StringComparison.OrdinalIgnoreCase) &&
                (devname.Equals("/dev/spidev1.0")))
            {
                var SSS = new IO.Objects.SimpleIO.GPIO.Pin
                    (IO.Objects.SimpleIO.Platforms.BeagleBone.GPIO44,
                     IO.Interfaces.GPIO.Direction.Output, true);

                return SSS.fd;
            }

            // Special processing for the Mikroelektronika BeagleBone click
            // SHIELD (MIKROE-1596):  Socket 2 has CS connected to GPIO46
            // instead of SPI1 CS1, so we have to do software slave select.

            if (ShieldName.Equals("BeagleBoneClick2", StringComparison.OrdinalIgnoreCase) &&
                (devname.Equals("/dev/spidev1.1")))
            {
                var SSS = new IO.Objects.SimpleIO.GPIO.Pin
                    (IO.Objects.SimpleIO.Platforms.BeagleBone.GPIO46,
                     IO.Interfaces.GPIO.Direction.Output, true);

                return SSS.fd;
            }

            // Explicit software slave select.

            if (cspin is IO.Objects.SimpleIO.Device.Designator desg)
            {
                var SSS = new IO.Objects.SimpleIO.GPIO.Pin(desg,
                    IO.Interfaces.GPIO.Direction.Output, true);

                return SSS.fd;
            }

            // Implicit hardware slave select

            return IO.Bindings.libsimpleio.SPI_AUTO_CS;
        }

        /// <summary>
        /// Constructor for a single SPI device.
        /// </summary>
        /// <param name="desg">SPI slave device designator.</param>
        /// <param name="mode">SPI clock mode.</param>
        /// <param name="wordsize">SPI transfer word size.</param>
        /// <param name="speed">SPI transfer speed.</param>
        /// <param name="cspin">SPI software slave select GPIO pin designator,
        /// or <c>null</c>.</param>
        public Device(IO.Objects.SimpleIO.Device.Designator desg, int mode,
            int wordsize, int speed,
            IO.Objects.SimpleIO.Device.Designator? cspin = null)
        {
            // Validate the SPI slave designator

            if ((desg.chip == IO.Objects.SimpleIO.Device.Designator.Unavailable.chip) ||
                (desg.chan == IO.Objects.SimpleIO.Device.Designator.Unavailable.chan))
            {
                throw new Exception("Invalid designator");
            }

            System.String devname = System.String.Format("/dev/spidev{0}.{1}",
              desg.chip, desg.chan);

            IO.Bindings.libsimpleio.SPI_open(devname, mode, wordsize,
                speed, out this.myfd, out int error);

            if (error != 0)
            {
                throw new Exception("SPI_open() failed, " +
                    errno.strerror(error));
            }

            this.myfdcs = SlaveSelect(devname, cspin);
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

            IO.Bindings.libsimpleio.SPI_transaction(this.myfd,
                this.myfdcs, null, 0, 0, resp, resp.Length, out int error);

            if (error != 0)
            {
                throw new Exception("SPI_transaction() failed, " +
                    errno.strerror(error));
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

            IO.Bindings.libsimpleio.SPI_transaction(this.myfd,
                this.myfdcs, cmd, cmdlen, 0, null, 0, out int error);

            if (error != 0)
            {
                throw new Exception("SPI_transaction() failed, " +
                    errno.strerror(error));
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

            IO.Bindings.libsimpleio.SPI_transaction(this.myfd,
                this.myfdcs, cmd, cmdlen, delayus, resp, resplen,
                out int error);

            if (error != 0)
            {
                throw new Exception("SPI_transaction() failed, " +
                    errno.strerror(error));
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
