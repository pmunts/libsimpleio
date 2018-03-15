// Raw HID device services using IO.Objects.libsimpleio

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

using IO.Objects.libsimpleio.Exceptions;

namespace IO.Objects.libsimpleio.HID
{
    /// <summary>
    /// Encapsulates Linux raw HID devices using <c>libsimpleio</c>.
    /// </summary>
    public class Messenger : IO.Interfaces.Message64.Messenger
    {
        private int myfd;

        /// <summary>
        /// Constructor for a single raw HID device.
        /// </summary>
        /// <param name="devname">Device node name.</param>
        public Messenger(string devname)
        {
            int error;

            IO.Bindings.libsimpleio.libHIDRaw.HIDRAW_open(devname,
                out this.myfd, out error);

            if (error != 0)
            {
                throw new Exception("HIDRAW_open() failed", error);
            }
        }

        /// <summary>
        /// Constructor for a single raw HID device.
        /// </summary>
        /// <param name="VID">Vendor ID.</param>
        /// <param name="PID">Product ID.</param>
        public Messenger(int VID = IO.Objects.USB.Munts.HID.Vendor,
            int PID = IO.Objects.USB.Munts.HID.Product)
        {
            if ((VID < 0) || (VID > 65535))
            {
                throw new Exception("Invalid vendor ID");
            }

            if ((PID < 0) || (PID > 65535))
            {
                throw new Exception("Invalid product ID");
            }

            int error;

            IO.Bindings.libsimpleio.libHIDRaw.HIDRAW_open_id(VID, PID,
                out this.myfd, out error);

            if (error != 0)
            {
                throw new Exception("HIDRAW_open_id() failed", error);
            }
        }

        /// <summary>
        /// Send a 64-byte command message to a raw HID device.
        /// </summary>
        /// <param name="cmd">64-byte command message.</param>
        public void Send(IO.Interfaces.Message64.Message cmd)
        {
            int count;
            int error;

            IO.Bindings.libsimpleio.libHIDRaw.HIDRAW_send(this.myfd,
                cmd.payload, IO.Interfaces.Message64.Message.Size, out count,
                out error);

            if (error != 0)
            {
                throw new Exception("HIDRAW_send() failed", error);
            }
        }

        /// <summary>
        /// Receive a 64-byte response message from a raw HID device.
        /// </summary>
        /// <param name="resp">64-byte response message.</param>
        public void Receive(IO.Interfaces.Message64.Message resp)
        {
            int count;
            int error;

            IO.Bindings.libsimpleio.libHIDRaw.HIDRAW_receive(this.myfd,
                resp.payload, IO.Interfaces.Message64.Message.Size,
                out count, out error);

            if (error != 0)
            {
                throw new Exception("HIDRAW_send() failed", error);
            }
        }

        /// <summary>
        /// Send a 64-byte command message and receive a 64-byte response
        /// message.
        /// </summary>
        /// <param name="cmd">64-byte command message.</param>
        /// <param name="resp">64-byte response message.</param>
        /// <param name="timeoutms">Time in milliseconds to wait for
        /// a response.  Zero means wait forever.</param>
        public void Transaction(IO.Interfaces.Message64.Message cmd,
            IO.Interfaces.Message64.Message resp, int timeoutms = 0)
        {
            // Validate parameters

            if (timeoutms < 0)
            {
                throw new Exception("Invalid timeout");
            }

            // Send the command message

            this.Send(cmd);

            // Wait for the response message

            if (timeoutms > 0)
            {
                int[] files = { this.fd };
                int[] events = { IO.Bindings.libsimpleio.libLinux.POLLIN };
                int[] results = { 0 };
                int error;

                IO.Bindings.libsimpleio.libLinux.LINUX_poll(1, files, events,
                    results, timeoutms, out error);

                if (error != 0)
                {
                    throw new Exception("LINUX_poll() failed", error);
                }
            }

            // Receive the response message

            this.Receive(resp);
        }

        /// <summary>
        /// Read-only property returning the device information string for a
        /// raw HID device.
        /// </summary>
        public string name
        {
            get
            {
                System.Text.StringBuilder buf =
                    new System.Text.StringBuilder(256);
                int error;

                IO.Bindings.libsimpleio.libHIDRaw.HIDRAW_get_name(this.fd, buf,
                    buf.Capacity, out error);

                if (error != 0)
                {
                    throw new Exception("HIDRAW_get_name() failed", error);
                }

                return buf.ToString();
            }
        }

        /// <summary>
        /// Read-only property returning the bus type identifierfor a raw HID
        /// device.
        /// </summary>
        public int bustype
        {
            get
            {
                int error;
                int bus;
                int vid;
                int pid;

                IO.Bindings.libsimpleio.libHIDRaw.HIDRAW_get_info(this.fd,
                    out bus, out vid, out pid, out error);

                if (error != 0)
                {
                    throw new Exception("HIDRAW_get_info() failed", error);
                }

                return bus;
            }
        }

        /// <summary>
        /// Read-only property returning the bus type identifierfor a raw HID
        /// device.
        /// </summary>
        public int vendor
        {
            get
            {
                int error;
                int bus;
                int vid;
                int pid;

                IO.Bindings.libsimpleio.libHIDRaw.HIDRAW_get_info(this.fd,
                    out bus, out vid, out pid, out error);

                if (error != 0)
                {
                    throw new Exception("HIDRAW_get_info() failed", error);
                }

                return vid;
            }
        }

        /// <summary>
        /// Read-only property returning the vendor identifierfor a raw HID
        /// device.
        /// </summary>
        public int product
        {
            get
            {
                int error;
                int bus;
                int vid;
                int pid;

                IO.Bindings.libsimpleio.libHIDRaw.HIDRAW_get_info(this.fd,
                    out bus, out vid, out pid, out error);

                if (error != 0)
                {
                    throw new Exception("HIDRAW_get_info() failed", error);
                }

                return pid;
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for a raw
        /// HID device.
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
