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

using System;
using IO.Interfaces.Message64;

namespace IO.Remote
{
    public partial class Device
    {
        /// <summary>
        /// Query available A/D inputs.
        /// </summary>
        /// <returns>List of available A/D input numbers.</returns>
        public System.Collections.Generic.List<int> ADC_Available()
        {
            return Available(PeripheralTypes.ADC);
        }

        /// <summary>
        /// Create a remote A/D input.
        /// </summary>
        /// <param name="num">A/D input number: 0 to 127.</param>
        /// <returns>A/D input object.</returns>
        public IO.Interfaces.ADC.Sample ADC_Create(int num)
        {
            return new ADC(this, num);
        }
    }

    /// <summary>
    /// Encapsulates remote A/D inputs.
    /// </summary>
    public class ADC: IO.Interfaces.ADC.Sample
    {
        private Device device;
        private int num;

        /// <summary>
        /// Create a remote A/D input.
        /// </summary>
        /// <param name="dev">Remote I/O device object.</param>
        /// <param name="num">A/D input number: 0 to 127.</param>
        /// <remarks>Use <c>Device.ADC_Create()</c> instead of this constructor.</remarks>
        public ADC(Device dev, int num)
        {
            this.device = dev;
            this.num = (byte)num;

            // Validate parameters

            if ((num < 0) || (num >= Device.MAX_CHANNELS))
                throw new Exception("Invalid A/D input number");

            Message cmd = new Message(0);
            Message resp = new Message();

            cmd.payload[0] = (byte)MessageTypes.ADC_CONFIGURE_REQUEST;
            cmd.payload[1] = 6;
            cmd.payload[2] = (byte)num;

            device.Dispatcher(cmd, resp);
        }

        /// <summary>
        /// Read-only property returning an integer analog input sample.
        /// </summary>
        public int sample
        {
            get
            {
                Message cmd = new Message(0);
                Message resp = new Message();

                cmd.payload[0] = (byte)MessageTypes.ADC_READ_REQUEST;
                cmd.payload[1] = 7;
                cmd.payload[2] = (byte)this.num;

                this.device.Dispatcher(cmd, resp);

                return unchecked((int)(
                    ((uint)(resp.payload[3]) << 24) +
                    ((uint)(resp.payload[4]) << 16) +
                    ((uint)(resp.payload[5]) << 8) +
                    (uint)resp.payload[6]));
            }
        }
    }
}
