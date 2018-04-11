// Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

namespace IO.Objects.USB.HID
{
    /// <summary>
    /// Encapsulates USB raw HID devices, using the HidSharp library.
    /// </summary>
    public class Messenger : IO.Interfaces.Message64.Messenger
    {
        // Transport library selector

        private enum Transport
        {
            libsimpleio,
            HidSharp,
        };

        private Transport transport;

        // Private information for the libsimpleio library

        private class libHIDRaw
        {
            [System.Runtime.InteropServices.DllImport("simpleio")]
            public static extern void HIDRAW_open_id(int VID, int PID,
                out int fd, out int error);

            [System.Runtime.InteropServices.DllImport("simpleio")]
            public static extern void HIDRAW_close(int fd, out int error);

            [System.Runtime.InteropServices.DllImport("simpleio")]
            public static extern void HIDRAW_get_name(int fd,
                System.Text.StringBuilder name, int size, out int error);

            [System.Runtime.InteropServices.DllImport("simpleio")]
            public static extern void HIDRAW_send(int fd, byte[] buf,
                int bufsize, out int count, out int error);

            [System.Runtime.InteropServices.DllImport("simpleio")]
            public static extern void HIDRAW_receive(int fd, byte[] buf,
                int bufsize, out int count, out int error);
        }

        private class libLinux
        {
            public const int POLLIN = 0x01;
            public const int POLLOUT = 0x04;

            [System.Runtime.InteropServices.DllImport("simpleio")]
            public static extern void LINUX_poll(int numfiles, int[] files,
                int[] events, int[] results, int timeoutms, out int error);
        }

        private int fd = -1;
        private int timeout = 0;

        // Private information for the HidSharp library

        private int reportID_offset = 1;  // Skip the report ID byte
        private HidSharp.HidDevice hid_device;
        private HidSharp.HidStream hid_stream;

        /// <summary>
        /// Create a 64-byte messenger object bound to a USB HID device.
        /// </summary>
        /// <param name="vid">USB vendor ID</param>
        /// <param name="pid">USB product ID</param>
        /// <param name="timeoutms">Time in milliseconds to wait for
        /// read and write operations to complete.  Zero means wait
        /// forever.</param>
        public Messenger(int vid = IO.Objects.USB.Munts.HID.Vendor,
          int pid = IO.Objects.USB.Munts.HID.Product, int timeoutms = 5000)
        {
            // Validate parameters

            if (timeoutms < 0)
            {
                throw new Exception("Invalid timeout");
            }

            if ((vid < 0) || (vid > 65535))
            {
                throw new Exception("Invalid vendor ID");
            }

            if ((pid < 0) || (pid > 65535))
            {
                throw new Exception("Invalid product ID");
            }

            if (System.IO.File.Exists("/usr/lib/libsimpleio.so") ||
                System.IO.File.Exists("/usr/local/lib/libsimpleio.so"))
            {
                // Use libsimpleio libHIDRaw

                this.transport = Transport.libsimpleio;

                // Open the raw HID device

                int error;

                libHIDRaw.HIDRAW_open_id(vid, pid, out this.fd, out error);

                if (error != 0)
                {
                    throw new Exception("Cannot open USB device");
                }
            }
            else
            {
                // Use HidSharp library

                this.transport = Transport.HidSharp;

                // No report ID byte on  Unix or MacOS

                if ((Environment.OSVersion.Platform == PlatformID.Unix) ||
                    (Environment.OSVersion.Platform == PlatformID.MacOSX))
                {
                    reportID_offset = 0;
                }

                try
                {
                    // Open the USB HID device

                    HidSharp.HidDeviceLoader loader = new HidSharp.HidDeviceLoader();
                    hid_device = loader.GetDeviceOrDefault(vid, pid);

                    if (hid_device == null)
                    {
                        throw new Exception("Cannot find matching USB device");
                    }

                    hid_stream = hid_device.Open();

                    hid_stream.ReadTimeout = timeoutms;
                    hid_stream.WriteTimeout = timeoutms;
                }
                catch (System.Exception e)
                {
                    throw new Exception("Cannot open USB HID device, " + e.Message);
                }
            }

            this.timeout = timeoutms;
        }

        /// <summary>
        /// Information string from the USB HID device.
        /// </summary>
        public String Info
        {
            get
            {
                switch (this.transport)
                {
                    case Transport.libsimpleio:
                        {
                            System.Text.StringBuilder buf =
                                new System.Text.StringBuilder(256);
                            int error;

                            libHIDRaw.HIDRAW_get_name(this.fd, buf, buf.Capacity,
                                out error);

                            if (error != 0)
                            {
                                throw new Exception("HIDRAW_get_name() failed");
                            }

                            return buf.ToString();
                        }

                    case Transport.HidSharp:
                        {
                            return this.hid_device.Manufacturer.Trim() + " " +
                                this.hid_device.ProductName.Trim();
                        }

                    default:
                        {
                            return "";
                        }
                }
            }
        }

        /// <summary>
        /// Send a 64-byte message to a USB HID device.
        /// </summary>
        /// <param name="cmd">Message to be sent.</param>
        public void Send(IO.Interfaces.Message64.Message cmd)
        {
            switch (this.transport)
            {
                case Transport.libsimpleio:
                    {
                        int count;
                        int error;

                        if (this.timeout > 0)
                        {
                            int[] files = { this.fd };
                            int[] events = { libLinux.POLLOUT };
                            int[] results = { 0 };

                            libLinux.LINUX_poll(1, files, events, results,
                                this.timeout, out error);

                            if (error != 0)
                            {
                                throw new Exception("LINUX_poll() failed");
                            }
                        }

                        libHIDRaw.HIDRAW_send(this.fd, cmd.payload,
                            IO.Interfaces.Message64.Message.Size, out count,
                            out error);

                        if (error != 0)
                        {
                            throw new Exception("HIDRAW_send() failed");
                        }

                        return;
                    }

                case Transport.HidSharp:
                    {
                        byte[] outbuf =
                            new byte[IO.Interfaces.Message64.Message.Size + 1];

                        outbuf[0] = 0;

                        for (int i = 0; i < IO.Interfaces.Message64.Message.Size; i++)
                            outbuf[i + this.reportID_offset] = cmd.payload[i];

                        this.hid_stream.Write(outbuf);

                        return;
                    }
            }
        }

        /// <summary>
        /// Receive a 64-byte message from a USB HID device.
        /// </summary>
        /// <param name="resp">Message received.</param>
        public void Receive(IO.Interfaces.Message64.Message resp)
        {
            switch (this.transport)
            {
                case Transport.libsimpleio:
                    {
                        int count;
                        int error;

                        if (this.timeout > 0)
                        {
                            int[] files = { this.fd };
                            int[] events = { libLinux.POLLIN };
                            int[] results = { 0 };

                            libLinux.LINUX_poll(1, files, events, results,
                                this.timeout, out error);

                            if (error != 0)
                            {
                                throw new Exception("LINUX_poll() failed");
                            }
                        }

                        libHIDRaw.HIDRAW_receive(this.fd, resp.payload,
                            IO.Interfaces.Message64.Message.Size, out count,
                            out error);

                        if (error != 0)
                        {
                            throw new Exception("HIDRAW_send() failed");
                        }

                        return;
                    }

                case Transport.HidSharp:
                    {
                        byte[] inbuf =
                            new byte[IO.Interfaces.Message64.Message.Size + 1];

                        int len = this.hid_stream.Read(inbuf);

                        if (len != IO.Interfaces.Message64.Message.Size +
                            this.reportID_offset)
                            throw new Exception("Invalid response message size");

                        for (int i = 0; i < IO.Interfaces.Message64.Message.Size; i++)
                            resp.payload[i] = inbuf[i + this.reportID_offset];

                        return;
                    }
            }
        }

        /// <summary>
        /// Send a 64-byte command message to and receive a 64-byte response
        /// message from a USB HID device.
        /// </summary>
        /// <param name="cmd">Message to be sent.</param>
        /// <param name="resp">Message received.</param>
        public void Transaction(IO.Interfaces.Message64.Message cmd,
            IO.Interfaces.Message64.Message resp)
        {
            Send(cmd);
            Receive(resp);
        }
    }
}
