// Copyright (C)2020-2023, Philip Munts.
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

namespace IO.Objects.RemoteIO
{
    /// <summary>
    /// Encasulates a remote I/O device.
    /// </summary>
    public partial class Device
    {
        /// <summary>
        /// Create a Remote I/O Device object instance for the specified
        /// USB Raw HID Remote I/O Server.
        /// </summary>
        /// <param name="VID">Vendor ID</param>
        /// <param name="PID">Product</param>
        /// <param name="serialnumber">Serial number</param>
        /// <param name="timeoutms">Time in milliseconds to wait for
        /// read and write operations to complete.  Zero means wait
        /// forever.</param>
        public Device(int VID = 0x16D0, int PID = 0x0AFA,
            string serialnumber = null, int timeoutms = 1000)
        {
            transport = new IO.Objects.SimpleIO.HID.Messenger(VID, PID, 
                serialnumber, timeoutms);

            Message cmd = new Message(0);
            Message resp = new Message();

            cmd.payload[0] = (byte)MessageTypes.VERSION_REQUEST;
            cmd.payload[1] = 1;

            transport.Transaction(cmd, resp);
            Version_string = System.Text.Encoding.UTF8.GetString(resp.payload, 3, Message.Size - 3).Trim('\0');

            cmd.payload[0] = (byte)MessageTypes.CAPABILITY_REQUEST;
            cmd.payload[1] = 2;

            transport.Transaction(cmd, resp);
            Capability_string = System.Text.Encoding.UTF8.GetString(resp.payload, 3, Message.Size - 3).Trim('\0');
        }
    }
}
