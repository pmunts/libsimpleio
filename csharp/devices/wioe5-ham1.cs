// Copyright (C)2025, Philip Munts dba Munts Technologies.
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
using static System.Environment;
using static IO.Bindings.libwioe5ham1;

namespace IO.Devices.WioE5.Ham1
{
    /// <summary>
    /// Encapsulates the
    /// <a href="https://wiki.seeedstudio.com/LoRa-E5_STM32WLE5JC_Module">
    /// Wio-E5 LoRa Transceiver Module</a> in P2P (Peer to Peer or Point to
    /// Point) broadcast mode with Amateur Radio Unicast Address Header
    /// Flavor #1:
    /// <para/>
    /// <para/>
    /// 8 bytes network ID <i>aka</i> callsign, left justified and space
    /// padded.<br/>
    /// 1 byte destination node ID (ARCNET style: 0=broadcast or 1 to
    /// 255).<br/>
    /// 1 byte source node ID (ARCNET style: 1 to 255).
    /// </summary>
    public class Device
    {
        private readonly int handle;

        /// <summary>
        /// Constructor for a Wio-E5 LoRa Transceiver Module device object
        /// instance.
        /// </summary>
        /// <param name="portname">Serial Port device name <i>e.g.</i>
        /// "<c>/dev/ttyAMA0</c>" or "<c>/dev/ttyUSB0</c>" or "<c>COM1</c>".
        /// </param>
        /// <param name="baudrate">Serial port data rate in bits per second
        /// (9600, 19200, 38400, 57600, 115200, or 230400).</param>
        /// <param name="network">Network ID <i>aka</i> callsign, 8 ASCII
        /// characters, left justified and automatically space padded
        /// <i>e.g.</i> "WA7AAA".</param>
        /// <param name="node">Node ID, ARCNET Style: 1 to 255.</param>
        /// <param name="freq">RF center frequency in MHz, 902.0 to 928.0
        /// (<a href="https://en.wikipedia.org/wiki/33-centimeter_band">U.S.
        /// Amateur Radio Allocation</a>).</param>
        /// <param name="spreading">Spreading Factor, 7 to 12.</param>
        /// <param name="bandwidth">Bandwidth in kHz, 125, 250, or 500.</param>
        /// <param name="txpreamble">Number of transmit preamble bits.</param>
        /// <param name="rxpreamble">Number of receive preamble bits.</param>
        /// <param name="power">Transmit power in dBm, -1 to 22.</param>
        public Device(string portname, int baudrate, string network,
            int node, float freq, int spreading = 7, int bandwidth = 500,
            int txpreamble = 12, int rxpreamble = 15, int power = 22)
        {
            wioe5ham1_init(portname, baudrate, network, node, freq,
                spreading, bandwidth, txpreamble, rxpreamble, power,
                out this.handle, out int error);

            if (error != 0)
            {
                throw new Exception("wioe5ham1_init() failed, " +
                    errno.strerror(error));
            }
        }

        /// <summary>
        /// Parameterless constructor for a Wio-E5 LoRa Transceiver Module
        /// device object instance.  Settings are obtained from environment
        /// variables, some of which have default values.
        /// <para/>
        /// <para/>
        /// This is mostly for <a href="https://github.com/pmunts/muntsos">
        /// MuntsOS Embedded Linux</a> targets with
        /// configuration parameters defined in <c>/etc/environment</c>
        /// using the following environment variables:
        /// <para/>
        /// <c>WIOE5_PORT</c><br/>
        /// <c>WIOE5_BAUD</c> (Default: 115200)<br/>
        /// <c>WIOE5_NETWORK</c><br/>
        /// <c>WIOE5_NODE</c><br/>
        /// <c>WIOE5_FREQ</c><br/>
        /// <c>WIOE5_SPREADING</c> (Default: 7)<br/>
        /// <c>WIOE5_BANDWIDTH</c> (Default: 500)<br/>
        /// <c>WIOE5_TXPREAMBLE</c> (Default: 12)<br/>
        /// <c>WIOE5_RXPREAMBLE</c> (Default: 15)<br/>
        /// <c>WIOE5_TXPOWER</c> (Default: 22)<br/>
        /// </summary>
        public Device()
        {
            var port = GetEnvironmentVariable("WIOE5_PORT");

            if (port == null)
            {
                throw new Exception("WIOE5_PORT environment variable is undefined");
            }

            var sbaudrate = GetEnvironmentVariable("WIOE5_BAUD");

            if (sbaudrate == null)
            {
                sbaudrate = "115200";
            }

            if (!int.TryParse(sbaudrate, out int baudrate))
            {
                throw new Exception("WIOE5_PORT environment variable is invalid");
            }

            var network = GetEnvironmentVariable("WIOE5_NETWORK");

            if (network == null)
            {
                throw new Exception("WIOE5_NETWORK environment variable is undefined");
            }

            var snode = GetEnvironmentVariable("WIOE5_NODE");

            if (snode == null)
            {
                throw new Exception("WIOE5_NODE environment variable is undefined");
            }

            if (!int.TryParse(snode, out int node))
            {
                throw new Exception("WIOE5_NODE environment variable is undefined");
            }

            var sfreq = GetEnvironmentVariable("WIOE5_FREQ");

            if (sfreq == null)
            {
                throw new Exception("WIOE5_FREQ environment variable is undefined");
            }

            if (!float.TryParse(sfreq, out float freq))
            {
                throw new Exception("WIOE5_FREQ environment variable is invalid");
            }

            var sspreading = GetEnvironmentVariable("WIOE5_SPREADING");

            if (sspreading == null)
            {
                sspreading = "7";
            }

            if (!int.TryParse(sspreading, out int spreading))
            {
                throw new Exception("WIOE5_FREQ environment variable is invalid");
            }

            var sbandwidth = GetEnvironmentVariable("WIOE5_BANDWIDTH");

            if (sbandwidth == null)
            {
                sbandwidth = "500";
            }

            if (!int.TryParse(sbandwidth, out int bandwidth))
            {
                throw new Exception("WIOE5_BANDWIDTH environment variable is invalid");
            }

            var stxpreamble = GetEnvironmentVariable("WIOE5_TXPREAMBLE");

            if (stxpreamble == null)
            {
                stxpreamble = "12";
            }

            if (!int.TryParse(stxpreamble, out int txpreamble))
            {
                throw new Exception("WIOE5_TXPREAMBLE environment variable is invalid");
            }

            var srxpreamble = GetEnvironmentVariable("WIOE5_RXPREAMBLE");

            if (srxpreamble == null)
            {
                srxpreamble = "15";
            }

            if (!int.TryParse(srxpreamble, out int rxpreamble))
            {
                throw new Exception("WIOE5_RXPREAMBLE environment variable is invalid");
            }

            var spower = GetEnvironmentVariable("WIOE5_POWER");

            if (spower == null)
            {
                spower = "22";
            }

            if (!int.TryParse(spower, out int power))
            {
                throw new Exception("WIOE5_POWER environment variable is invalid");
            }

            wioe5ham1_init(port, baudrate, network, node, freq, spreading,
                bandwidth, txpreamble, rxpreamble, power, out this.handle,
                out int error);

            if (error != 0)
            {
                throw new Exception("wioe5ham1_init() failed, " +
                    errno.strerror(error));
            }
        }

        /// <summary>
        /// Finalizer for a Wio-E5 LoRa Transceiver Module device object
        /// instance.
        /// </summary>
        ~Device()
        {
            wioe5ham1_exit(handle, out int error);
        }

        /// <summary>
        /// Send a text message.
        /// </summary>
        /// <param name="s">Text message to send.  Must be 1 to 243
        /// characters.</param>
        /// <param name="dst">Destination node ID (ARCNET style: 0=broadcast,
        /// or 1 to 255).</param>
        public void Send(string s, int dst)
        {
            wioe5ham1_send_string(this.handle,
                s, dst, out int error);

            if (error != 0)
            {
                throw new Exception("wioe5ham1_send_string() failed, " +
                    errno.strerror(error));
            }
        }

        /// <summary>
        /// Send a binary message.
        /// </summary>
        /// <param name="msg">Binary message.</param>
        /// <param name="len">Message length in bytes, 1 to 243.</param>
        /// <param name="dst">Destination node ID (ARCNET style: 0=broadcast,
        /// or 1 to 255).</param>
        public void Send(byte[] msg, int len, int dst)
        {
            wioe5ham1_send(this.handle, msg, len, dst, out int error);

            if (error != 0)
            {
                throw new Exception("wioe5ham1_send() failed, " +
                    errno.strerror(error));
            }
        }

        /// <summary>
        /// Receive a binary message.
        /// </summary>
        /// <param name="msg">Binary message.  Must be at least 243 bytes.
        /// </param>
        /// <param name="len">Number of bytes received.</param>
        /// <param name="src">Source node ID (ARCNET style: 1 to 255).</param>
        /// <param name="dst">Destination node ID (ARCNET style: 0=broadcast,
        /// or 1 to 255).</param>
        /// <param name="RSS">Received Signal Strength in dBm.</param>
        /// <param name="SNR">Signal to Noise Ratio in dB.</param>
        public void Receive(byte[]msg, out int len, out int src, out int dst,
            out int RSS, out int SNR)
        {
            wioe5ham1_receive(this.handle, msg, out len, out src, out dst,
                out RSS, out SNR, out int error);

            if (error != 0)
            {
                throw new Exception("wioe5ham1_send() failed, " +
                    errno.strerror(error));
            }
        }
    }
}
