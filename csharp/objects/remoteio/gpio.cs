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
using IO.Interfaces.Message64;

namespace IO.Objects.RemoteIO
{
    public partial class Device
    {
        /// <summary>
        /// Query available GPIO pins.
        /// </summary>
        /// <returns>List of available GPIO pin numbers.</returns>
        public System.Collections.Generic.List<int> GPIO_Available()
        {
            return Available(PeripheralTypes.GPIO);
        }

        /// <summary>
        /// Create a remote GPIO pin object.
        /// </summary>
        /// <param name="num">GPIO pin number: 0 to 127.</param>
        /// <param name="dir">GPIO pin data direction: Input or Output.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <returns>GPIO pin object.</returns>
        public IO.Interfaces.GPIO.Pin GPIO_Create(int num, IO.Interfaces.GPIO.Direction dir, bool state = false)
        {
            return new GPIO(this, num, dir, state);
        }
    }

    /// <summary>
    /// Encapsulates remote GPIO pins.
    /// </summary>
    public class GPIO: IO.Interfaces.GPIO.Pin
    {
        private readonly Device device;
        private readonly int num;

        /// <summary>
        /// Create a remote GPIO pin.
        /// </summary>
        /// <param name="dev">Remote I/O device object.</param>
        /// <param name="num">GPIO pin number: 0 to 127.</param>
        /// <param name="dir">GPIO pin data direction: Input or Output.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <remarks>Use <c>Device.GPIO_Create()</c> instead of this constructor.</remarks>
        public GPIO(Device dev, int num, IO.Interfaces.GPIO.Direction dir, bool state = false)
        {
            this.device = dev;
            this.num = num;

            // Validate parameters

            if ((num < 0) || (num >= Device.MAX_CHANNELS))
                throw new Exception("Invalid GPIO pin number");

            if ((dir < IO.Interfaces.GPIO.Direction.Input) ||
                (dir > IO.Interfaces.GPIO.Direction.Output))
                throw new Exception("Invalid GPIO pin direction");

            int bytenum = num / 8;
            byte bitmask = (byte)(1 << (7 - num % 8));

            Message cmd = new Message(0);
            Message resp = new Message();

            cmd.payload[0] = (byte)MessageTypes.GPIO_CONFIGURE_REQUEST;
            cmd.payload[2 + bytenum] |= bitmask;

            if (dir == IO.Interfaces.GPIO.Direction.Output)
                cmd.payload[18 + bytenum] |= bitmask;

            device.Dispatcher(cmd, resp);

            cmd = new Message(0);

            cmd.payload[0] = (byte)MessageTypes.GPIO_WRITE_REQUEST;
            cmd.payload[2 + bytenum] |= bitmask;

            if (state == true)
                cmd.payload[18 + bytenum] |= bitmask;

            device.Dispatcher(cmd, resp);
        }

        /// <summary>
        /// Read/Write GPIO state property.
        /// </summary>
        public bool state
        {
            get
            {
                int bytenum = this.num / 8;
                byte bitmask = (byte)(1 << (7 - this.num % 8));

                Message cmd = new Message(0);
                Message resp = new Message();

                cmd.payload[0] = (byte)MessageTypes.GPIO_READ_REQUEST;
                cmd.payload[2 + bytenum] |= bitmask;

                this.device.Dispatcher(cmd, resp);

                return (resp.payload[3 + bytenum] & bitmask) != 0;
            }

            set
            {
                int bytenum = this.num / 8;
                byte bitmask = (byte)(1 << (7 - this.num % 8));

                Message cmd = new Message(0);
                Message resp = new Message();

                cmd.payload[0] = (byte)MessageTypes.GPIO_WRITE_REQUEST;
                cmd.payload[2 + bytenum] |= bitmask;

                if (value)
                    cmd.payload[18 + bytenum] |= bitmask;

                this.device.Dispatcher(cmd, resp);
            }
        }
    }
}
