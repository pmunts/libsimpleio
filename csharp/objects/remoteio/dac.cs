// Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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
    public partial class Device
    {
        /// <summary>
        /// Query available D/A outputs.
        /// </summary>
        /// <returns>List of available D/A output numbers.</returns>
        public System.Collections.Generic.List<int> DAC_Available()
        {
            return Available(PeripheralTypes.DAC);
        }

        /// <summary>
        /// Create a remote D/A output.
        /// </summary>
        /// <param name="num">D/A output number: 0 to 127.</param>
        /// <param name="sample">Initial DAC output sample.</param>
        /// <returns>D/A output object.</returns>
        public IO.Interfaces.DAC.Sample DAC_Create(int num, int sample = 0)
        {
            return new DAC(this, num, sample);
        }
    }

    /// <summary>
    /// Encapsulates remote D/A outputs.
    /// </summary>
    public class DAC: IO.Interfaces.DAC.Sample
    {
        private readonly Device device;
        private readonly int num;
        private readonly int nbits;

        /// <summary>
        /// Create a remote D/A output.
        /// </summary>
        /// <param name="dev">Remote I/O device object.</param>
        /// <param name="num">D/A output number: 0 to 127.</param>
        /// <param name="sample">Initial DAC output sample.</param>
        /// <remarks>Use <c>Device.DAC_Create()</c> instead of this
        /// constructor.</remarks>
        public DAC(Device dev, int num, int sample = 0)
        {
            this.device = dev;
            this.num = (byte)num;

            // Validate parameters

            if ((num < 0) || (num >= Device.MAX_CHANNELS))
                throw new Exception("Invalid D/A output number");

            // Dispatch command message

            Message cmd = new Message(0);
            Message resp = new Message();

            cmd.payload[0] = (byte)MessageTypes.DAC_CONFIGURE_REQUEST;
            cmd.payload[2] = (byte)num;

            device.Dispatcher(cmd, resp);

            // Save resolution from the response message

            this.nbits = resp.payload[3];
            this.sample = sample;
        }

        /// <summary>
        /// Write-only property for writing an integer analog sample to a DAC
        /// output.
        /// </summary>
        public int sample
        {
            set
            {
                Message cmd = new Message(0);
                Message resp = new Message();

                cmd.payload[0] = (byte)MessageTypes.DAC_WRITE_REQUEST;
                cmd.payload[2] = (byte)this.num;
                cmd.payload[3] = (byte)(value >> 24);
                cmd.payload[4] = (byte)((value >> 16) & 0xFF);
                cmd.payload[5] = (byte)((value >> 8) & 0xFF);
                cmd.payload[6] = (byte)(value & 0xFF);

                this.device.Dispatcher(cmd, resp);
            }
        }

        /// <summary>
        /// Read-only property returning the number of bits of resolution.
        /// </summary>
        public int resolution
        {
            get
            {
                return this.nbits;
            }
        }
    }
}
