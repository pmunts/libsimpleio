// GPIO pin services using libsimpleio

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

namespace libsimpleio.Serial
{
    /// <summary>
    /// Encapsulates Linux asynchronous serial port devices using
    /// <c>libsimpleio</c>.
    /// </summary>
    public class Port: IO.Interfaces.Serial.Port
    {
        private int myfd;

        /// <summary>
        /// Constructor for a single asynchronous serial port device.
        /// </summary>
        /// <param name="devname">Device node name.</param>
        /// <param name="baudrate">Baud rate.</param>
        /// <param name="parity">Parity.</param>
        /// <param name="databits">Data bits (5 to 8).</param>
        /// <param name="stopbits">Stop bits (1 or 2).</param>
        public Port(string devname, int baudrate, int parity,
            int databits, int stopbits)
        {
            int error;

            libsimpleio.libSerial.SERIAL_open(devname, baudrate, parity,
                databits, stopbits, out this.myfd, out error);

            if (error != 0)
            {
                throw new Exception("SERIAL_open() failed", error);
            }
        }

        /// <summary>
        /// Write bytes to the serial port device.
        /// </summary>
        /// <param name="buf">Transmit data buffer.</param>
        /// <param name="bufsize">Number of bytes to send.</param>
        /// <param name="count">Number of bytes actually sent.</param>
        public void Send(byte[] buf, int bufsize, out int count)
        {
            int error;

            libsimpleio.libSerial.SERIAL_send(this.myfd, buf, bufsize,
                out count, out error);

            if (error != 0)
            {
                throw new Exception("SERIAL_send() failed", error);
            }
        }

        /// <summary>
        /// Write an ASCII string to the serial port device.
        /// </summary>
        /// <param name="s">String to send.</param>
        /// <param name="count">Number of bytes actually sent.</param>
        public void Send(string s, out int count)
        {
            byte[] buf = System.Text.Encoding.ASCII.GetBytes(s);

            this.Send(buf, buf.Length, out count);
        }

        /// <summary>
        /// Receive bytes from a serial port device.
        /// </summary>
        /// <param name="buf">Receive data buffer.</param>
        /// <param name="bufsize">Size of the receive data buffer.</param>
        /// <param name="count">Number of bytes actually received.</param>
        public void Receive(byte[] buf, int bufsize, out int count)
        {
            int error;

            libsimpleio.libSerial.SERIAL_receive(this.myfd, buf, bufsize,
                out count, out error);

            if (error != 0)
            {
                throw new Exception("SERIAL_receive() failed", error);
            }
        }

        /// <summary>
        /// Receive an ASCII string from a serial port device.
        /// </summary>
        /// <param name="s">Destination string.</param>
        /// <param name="bufsize">Maximum number of bytes to receive.</param>
        public void Receive(out string s, int bufsize = 256)
        {
            byte[] buf = new byte[bufsize];
            int count;

            this.Receive(buf, bufsize, out count);

            s = System.Text.Encoding.ASCII.GetString(buf, 0, count);
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for the
        /// serial port device.
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
