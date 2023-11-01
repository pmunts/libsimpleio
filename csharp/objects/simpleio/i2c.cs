// I2C bus controller services using IO.Objects.SimpleIO

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

namespace IO.Objects.SimpleIO.I2C
{
    /// <summary>
    /// Encapsulates Linux I<sup>2</sup>C bus controllers using
    /// <c>libsimpleio</c>.
    /// </summary>
    public class Bus : IO.Interfaces.I2C.Bus
    {
        // If you have system with more than 64 I2C buses, my condolences.
        // You will need to increase the size of fdtable and rebuild the
        // library.

        private static int[] fdtable =
        {
            -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        };

        private readonly int myfd;

        /// <summary>
        /// Constructor for a single I<sup>2</sup>C bus controller.
        /// </summary>
        /// <param name="desg">I<sup>2</sup> bus designator.</param>
        public Bus(IO.Objects.SimpleIO.Device.Designator desg)
        {
            // Validate the I2C bus designator

            if (desg.Equals(IO.Objects.SimpleIO.Device.Designator.Unavailable))
            {
                throw new Exception("Invalid designator");
            }

            if (desg.chip != 0)
            {
                throw new Exception("Invalid designator");
            }

            // Unlike almost any Linux I/O resource, an I2C bus can be shared
            // among two or more I2C slave devices.  We save open file
            // descriptors in fdtable so we can reuse them if the program
            // attempts to create multiple instances of the same I2C bus.
            // An important use case is a mikroBUS shield with multiple sockets
            // all sharing the same I2C bus.  We want to avoid opening a new
            // I2C bus file descriptor for each socket.

            if (desg.chan > fdtable.Length - 1)
            {
                throw new Exception("Too many I2C buses");
            }

            string devname = String.Format("/dev/i2c-{0}", desg.chan);

            System.Threading.Monitor.Enter(fdtable);

            // Resuse an existing open file descriptor, if possible

            if (fdtable[desg.chan] >= 0)
            {
                this.myfd = fdtable[desg.chan];
            }
            else
            {
                IO.Bindings.libsimpleio.I2C_open(devname, out this.myfd,
                    out int error);

                if (error != 0)
                {
                    System.Threading.Monitor.Exit(fdtable);

                    throw new Exception("I2C_open() failed, " +
                        errno.strerror(error));
                }

                // Save the new open file descriptor to fdtable, if possible

                fdtable[desg.chan] = this.myfd;
            }

            System.Threading.Monitor.Exit(fdtable);
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

            IO.Bindings.libsimpleio.I2C_transaction(this.myfd,
                slaveaddr, null, 0, resp, resplen, out int error);

            if (error != 0)
            {
                throw new Exception("I2C_transaction() failed, " +
                    errno.strerror(error));
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

            IO.Bindings.libsimpleio.I2C_transaction(this.myfd,
                slaveaddr, cmd, cmdlen, null, 0, out int error);

            if (error != 0)
            {
                throw new Exception("I2C_transaction() failed, " +
                    errno.strerror(error));
            }
        }

        /// <summary>
        /// Write and receive bytes to/from an I<sup>2</sup>C device.
        /// </summary>
        /// <param name="slaveaddr">Device slave address.</param>
        /// <param name="cmd">Command buffer.</param>
        /// <param name="cmdlen">Number of bytes to write.</param>
        /// <param name="resp">Response buffer.</param>
        /// <param name="resplen">Number of bytes to read.</param>
        /// <param name="delayus">Delay in microseconds between the I<sup>2</sup>C
        /// write and read cycles.  Allowed values are 0 to 65535 microseconds.</param>
        public void Transaction(int slaveaddr, byte[] cmd, int cmdlen,
                byte[] resp, int resplen, int delayus = 0)
        {
            // Validate parameters

            if ((slaveaddr < 0) || (slaveaddr > 127))
                throw new Exception("Invalid I2C slave address parameter");

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

            if (delayus == 0)
            {
                IO.Bindings.libsimpleio.I2C_transaction(this.myfd,
                    slaveaddr, cmd, cmdlen, resp, resplen, out error);

                if (error != 0)
                {
                    throw new Exception("I2C_transaction() failed, " +
                        errno.strerror(error));
                }
            }
            else
            {
                IO.Bindings.libsimpleio.I2C_transaction(this.myfd,
                    slaveaddr, cmd, cmdlen, null, 0, out error);

                if (error != 0)
                {
                    throw new Exception("I2C_transaction() failed, " +
                        errno.strerror(error));
                }

                IO.Bindings.libsimpleio.LINUX_usleep(delayus, out error);

                if (error != 0)
                {
                    throw new Exception("LINUX_usleep() failed, " +
                        errno.strerror(error));
                }

                IO.Bindings.libsimpleio.I2C_transaction(this.myfd,
                    slaveaddr, null, 0, resp, resplen, out error);

                if (error != 0)
                {
                    throw new Exception("I2C_transaction() failed, " +
                        errno.strerror(error));
                }
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for the
        /// I<sup>2</sup>C bus controller.
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
