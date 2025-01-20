// Copyright (C)2017-2025, Philip Munts dba Munts Technologies.
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
using System.Collections.Generic;
using IO.Interfaces.Message64;

namespace IO.Objects.RemoteIO
{
    /// <summary>
    /// Types of remote peripherals
    /// </summary>
    public enum PeripheralTypes
    {
        /// <summary>
        /// A/D inputs
        /// </summary>
        ADC,
        /// <summary>
        /// D/A outputs
        /// </summary>
        DAC,
        /// <summary>
        /// GPIO pins
        /// </summary>
        GPIO,
        /// <summary>
        /// I<sup>2</sup>C bus controllers
        /// </summary>
        I2C,
        /// <summary>
        /// SPI slave devices
        /// </summary>
        PWM,
        /// <summary>
        /// PWM outputs
        /// </summary>
        SPI,
    }

    /// <summary>
    /// Encasulates a Remote I/O Protocol server device.
    /// </summary>
    public partial class Device
    {
        private readonly Messenger transport;
        private readonly String Version_string;
        private readonly String Capability_string;
        private byte msgnum = 0;

        /// <summary>
        /// Maximum number of channels each subsystem can support.
        /// </summary>
        public const int MAX_CHANNELS = 128;

        /// <summary>
        /// Designator for an unavailable channel.
        /// </summary>
        public const int Unavailable = -1;

        // Fetch version string

        private string FetchVersion()
        {
            Message cmd = new Message(0);
            Message resp = new Message();

            cmd.payload[0] = (byte)MessageTypes.VERSION_REQUEST;
            cmd.payload[1] = 1;

            this.transport.Transaction(cmd, resp);
            return System.Text.Encoding.UTF8.GetString(resp.payload, 3, Message.Size - 3).Trim('\0');
        }

        // Fetch capability string

        private string FetchCapabilities()
        {
            Message cmd = new Message(0);
            Message resp = new Message();

            cmd.payload[0] = (byte)MessageTypes.CAPABILITY_REQUEST;
            cmd.payload[1] = 2;

            this.transport.Transaction(cmd, resp);
            return System.Text.Encoding.UTF8.GetString(resp.payload, 3, Message.Size - 3).Trim('\0');
        }

        /// <summary>
        /// Create a Remote I/O server device object using the supplied 
        /// <c>Message64.Messenger</c> transport object.
        /// </summary>
        /// <param name="transport"><c>Message64.Messenger</c> transport
        /// object.</param>
        /// <remarks>
        /// If a value for <c>transport</c> is not supplied, this constructor
        /// will attempt first to connect to the following Remote I/O protocol
        /// servers:
        /// <br/>
        /// A Munts Technologies USB HID Gadget (16D0:0AFA).
        /// <br/>
        /// A Munts Technologies USB Ethernet Gadget at usbgadget.munts.net
        /// running ZeroMQ (port 8088).
        /// </remarks>
        public Device(Messenger transport = null)
        {
            // Use supplied transport

            if (transport != null)
            {
                this.transport = transport;
                this.Version_string = FetchVersion();
                this.Capability_string = FetchCapabilities();
                return;
            }

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
            }

            throw new Exception("Unable to bind a transport mechanism.");
        }

        /// <summary>
        /// Command dispatcher.
        /// </summary>
        /// <param name="cmd">Command to be sent.</param>
        /// <param name="resp">Response to be received.</param>
        public void Dispatcher(Message cmd, Message resp)
        {
            unchecked
            {
                msgnum += 17;
            }

            cmd.payload[1] = msgnum;

            this.transport.Transaction(cmd, resp);

            if (resp.payload[0] != cmd.payload[0] + 1)
                throw new Exception("Invalid response message type");

            if (resp.payload[1] != cmd.payload[1])
                throw new Exception("Invalid response message number");

            if (resp.payload[2] != 0)
                throw new Exception("Command failed, error=" +
                  resp.payload[2].ToString());
        }

        /// <summary>
        /// Version string from the Remote I/O device.
        /// </summary>
        public String Version
        {
            get { return this.Version_string; }
        }

        /// <summary>
        /// Capability string from the Remote I/O device.
        /// </summary>
        public String Capabilities
        {
            get { return this.Capability_string; }
        }

        private static readonly string[] CapStrings = new string[]
        {
            "ADC",
            "DAC",
            "GPIO",
            "I2C",
            "PWM",
            "SPI",
        };

        private static readonly MessageTypes[] MsgTypes = new MessageTypes[]
        {
            MessageTypes.ADC_PRESENT_REQUEST,
            MessageTypes.DAC_PRESENT_REQUEST,
            MessageTypes.GPIO_PRESENT_REQUEST,
            MessageTypes.I2C_PRESENT_REQUEST,
            MessageTypes.PWM_PRESENT_REQUEST,
            MessageTypes.SPI_PRESENT_REQUEST,
        };

        private List<int> Available(PeripheralTypes t)
        {
            List<int> peripherals = new List<int>(MAX_CHANNELS);

            // Check whether the Remote I/O device supports this peripheral type

            if (this.Capabilities == String.Empty)
                return peripherals;

            if (this.Capabilities.IndexOf(CapStrings[(int)t]) < 0)
                return peripherals;

            // Query available peripherals

            Message cmd = new Message(0);
            Message resp = new Message();

            cmd.payload[0] = (byte)MsgTypes[(int)t];
            cmd.payload[1] = 5;

            this.transport.Transaction(cmd, resp);

            // Build the list of available peripherals

            for (int num = 0; num < MAX_CHANNELS; num++)
            {
                int bytenum = num / 8;
                byte bitmask = (byte)(1 << (7 - num % 8));

                if ((resp.payload[3 + bytenum] & bitmask) != 0)
                    peripherals.Add(num);
            }

            // Return the list of available peripherals

            return peripherals;
        }
    }
}
