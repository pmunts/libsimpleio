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
using IO.Interfaces.Message64;

namespace IO.Remote
{
    public partial class Device
    {
        /// <summary>
        /// Query available PWM outputs.
        /// </summary>
        /// <returns>List of available PWM output numbers.</returns>
        public System.Collections.Generic.List<int> PWM_Available()
        {
            return Available(PeripheralTypes.PWM);
        }

        /// <summary>
        /// Create a remote PWM output.
        /// </summary>
        /// <param name="num">PWM output number: 0 to 127.</param>
        /// <param name="freq">PWM pulse frequency in Hz.</param>
        /// <returns>PWM output object.</returns>
        public IO.Interfaces.PWM.Output PWM_Create(int num, int freq)
        {
            return new PWM(this, num, freq);
        }
    }

    /// <summary>
    /// Encapsulates remote PWM outputs.
    /// </summary>
    public class PWM: IO.Interfaces.PWM.Output
    {
        private Device device;
        private int num;
        private int period;

        /// <summary>
        /// Create a remote PWM output.
        /// </summary>
        /// <param name="dev">Remote I/O device object.</param>
        /// <param name="num">PWM output number: 0 to 127.</param>
        /// <param name="freq">PWM pulse frequency in Hz.</param>
        /// <remarks>Use <c>Device.PWM_Create()</c> instead of this constructor.</remarks>
        public PWM(Device dev, int num, int freq)
        {
            this.device = dev;
            this.num = (byte)num;
            this.period = 1000000000/freq;

            // Validate parameters

            if ((num < 0) || (num >= Device.MAX_CHANNELS))
                throw new Exception("Invalid PWM output number");

            // Dispatch command message

            Message cmd = new Message(0);
            Message resp = new Message();

            cmd.payload[0] = (byte)MessageTypes.PWM_CONFIGURE_REQUEST;
            cmd.payload[2] = (byte)num;
            cmd.payload[3] = (byte)(period >> 24);
            cmd.payload[4] = (byte)((period >> 16) & 0xFF);
            cmd.payload[5] = (byte)((period >> 8) & 0xFF);
            cmd.payload[6] = (byte)(period & 0xFF);

            device.Dispatcher(cmd, resp);
        }

        /// <summary>
        /// Write-only property for setting the PWM output duty cycle.
        /// </summary>
        public double dutycycle
        {
            set
            {
                // Validate parameters

                if (value < IO.Interfaces.PWM.DutyCycles.Minimum)
                  throw new Exception("Invalid PWM output dutycycle");

                if (value > IO.Interfaces.PWM.DutyCycles.Maximum)
                  throw new Exception("Invalid PWM output dutycycle");

                int ontime = (int) (value/100.0 * this.period);

                if (ontime > period)
                  throw new Exception("Invalid PWM output on-time");

                Message cmd = new Message(0);
                Message resp = new Message();

                cmd.payload[0] = (byte)MessageTypes.PWM_WRITE_REQUEST;
                cmd.payload[2] = (byte)this.num;
                cmd.payload[3] = (byte)(ontime >> 24);
                cmd.payload[4] = (byte)((ontime >> 16) & 0xFF);
                cmd.payload[5] = (byte)((ontime >> 8) & 0xFF);
                cmd.payload[6] = (byte)(ontime & 0xFF);

                this.device.Dispatcher(cmd, resp);
            }
        }
    }
}
