// Copyright (C)2020-2025, Philip Munts dba Munts Technologies.
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
    /// Encasulates a Remote I/O Protocol server device.
    /// </summary>
    public partial class Device
    {
        /// <summary>
        /// Create a Remote I/O server device object.
        /// </summary>
        /// <remarks>
        /// This constructor will attempt to connect to the following Remote
        /// I/O protocol servers:
        /// <br/>
        /// <br/>
        /// First, Munts Technologies USB HID Gadget at 16D0:0AFA.
        /// <br/>
        /// Then, Munts Technologies USB Ethernet Gadget at usbgadget.munts.net
        /// running ZeroMQ at port 8088.
        /// </remarks>
        public Device()
        {
            // Attempt to connect to Munts Technologies USB HID Gadget

            try
            {
                this.transport = new IO.Objects.Message64.HID.Messenger();
                this.Version_string = FetchVersion();
                this.Capability_string = FetchCapabilities();
                return;
            }

            catch
            {
                // That didn't work...
            }

            // Attempt to connect to Munts Technologies USB Ethernet Gadget
            // running ZeroMQ server

            try
            {
                this.transport = new IO.Objects.Message64.ZeroMQ.Messenger();
                this.Version_string = FetchVersion();
                this.Capability_string = FetchCapabilities();
                return;
            }

            catch
            {
                // That didn't work...
            }

            throw new Exception("Unable to bind a transport mechanism.");
        }

    }
}
