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

using System.Runtime.InteropServices;

namespace IO.Bindings
{
    /// <summary>
    /// <para>
    /// Wrapper class for the
    /// <a href="https://wiki.seeedstudio.com/LoRa-E5_STM32WLE5JC_Module">
    /// Wio-E5 LoRa Transceiver Module</a> Driver Library
    /// <c>libwioe5ham1.so</c> using test mode <i>aka</i> P2P (Peer to Peer
    /// or Point to Point) mode, adapted for use by U.S. Amateur Radio
    /// Operators.
    /// </para>
    /// <para>
    /// P2P is misleading because there is no station addressing and all
    /// transmissions are broadcasts.  Any station with the same RF settings
    /// (frequency, spreading factor, and chirp bandwidth) will be able to
    /// receive what you transmit with this library.
    /// </para>
    /// <para>
    /// In test <i>aka</i> P2P mode, the Wio-E5 transmits unencrypted
    /// "implicit header" frames consisting of a configurable number of
    /// preamble bits, 1 to 253 payload bytes, and two CRC bytes.  Upon
    /// reception of each frame, the Wio-E5 verifies the CRC, discarding
    /// erroneous frames and passing valid ones to the device driver.
    /// </para>
    /// <para>
    /// Unlike LoRaWan mode, frames with up to 253 payload bytes can be sent
    /// and received using <b>any</b> data rate scheme (the combination of
    /// spreading factor, modulation bandwidth, and the derived RF symbol
    /// rate).
    /// </para>
    /// <para>
    /// <c>libwioe5ham1</c> provides Amateur Radio Service Support Flavor
    /// #1: <i><b>All stations are administered by the same ham radio
    /// operator, using the same callsign, and the first 10 bytes of payload
    /// are dedicated to address information:</b></i>
    /// </para>
    /// <para>
    /// 8 ASCII bytes for the network ID <i>aka</i> callsign, left justified
    /// and space padded.  Unlike AX.25, the ASCII bytes are left
    /// shifted one bit.
    /// </para>
    /// <para>
    /// 1 byte for the destination node ID (ARCNET style: broadcast=0,
    /// unicast=1 to 255).
    /// </para>
    /// <para>
    /// 1 byte for the source node ID (ARCNET style: unicast=1 to 255).
    /// </para>
    /// <para>
    /// <c>libwioe5ham1</c> drops any received frame that does not contain
    /// matching network <i>aka</i> callsign and destination node ID's,
    /// imposing a unicast address scheme onto the broadcast Wio-E5 test
    /// <i>aka</i> P2P mode.
    /// </para>
    /// <para>
    /// In accordance with the digital data transparency required by U.S.
    /// Amateur Radio Service regulations, any Wio-E5 using the same RF
    /// settings (possibly using the related library <c>libwioe5p2p</c>)
    /// can monitor communications among a group of ham radio stations using
    /// <c>libwioe5ham1</c>.
    /// </para>
    /// </summary>
    public static class libwioe5ham1
    {
        /// <summary>
        /// Initialize the Wio-E5 driver shared library and transceiver module.
        /// </summary>
        /// <param name="portname">Serial port device name <i>e.g.</i>
        /// <c>/dev/ttyAMA0</c> or <c>/dev/ttyUSB0</c>.</param>
        /// <param name="baudrate">Serial port baud rate in bits per second
        /// (9600, 19200, 38400, 57600, 115200, or 230400).
        /// </param>
        /// <param name="network">Network ID <i>e.g.</i> callsign (8 ASCII
        /// characters, left justified and blank padded).</param>
        /// <param name="node">Network node ID
        /// (ARCNET Style: 1 to 255).</param>
        /// <param name="freqmhz">RF center frequency in MHz, 902.0 to 928.0
        /// (<a href="https://en.wikipedia.org/wiki/33-centimeter_band">U.S.
        /// Amateur Radio Allocation</a>).
        /// </param>
        /// <param name="spreading">Spreading factor (7 to 12).</param>
        /// <param name="bandwidth">Spread spectrum chirp bandwidth in kHz
        /// (125, 250, or 500).</param>
        /// <param name="txpreamble">Number of transmit preamble bits (12 is
        /// recommended).</param>
        /// <param name="rxpreamble">Number of receive preamble bits (15 is
        /// recommended).</param>
        /// <param name="txpower">Transmit power in dBm (0 to 22).</param>
        /// <param name="handle">Wio-E5 device handle.</param>
        /// <param name="error">Error code.  Zero upon success.</param>
        [DllImport("wioe5ham1")]
        public static extern void wioe5ham1_init
         (string portname,
          int baudrate,
          string network,
          int node,
          float freqmhz,
          int spreading,
          int bandwidth,
          int txpreamble,
          int rxpreamble,
          int txpower,
          out int handle,
          out int error);

        /// <summary>
        /// Terminate the Wio-E5 driver shared library background task.
        /// </summary>
        /// <param name="handle">Wio-E5 device handle.</param>
        /// <param name="error">Error code.  Zero upon success.</param>
        [DllImport("wioe5ham1")]
        public static extern void wioe5ham1_exit
         (int handle,
          out int error);

        /// <summary>
        /// Receive a binary message frame, if available.
        /// </summary>
        /// <param name="handle">Wio-E5 device handle.</param>
        /// <param name="msg">Payload buffer (243 bytes).</param>
        /// <param name="len">Number of payload bytes received.
        /// Zero indicates queue empty, no RF frame available.</param>
        /// <param name="src">Source node ID (ARCNET Style: 1 to 255).</param>
        /// <param name="dst">Destination node ID
        /// (ARCNET Style: 0 for broadcast or 1 to 255 for unicast).</param>
        /// <param name="RSS">Received Signal Strength in dBm.</param>
        /// <param name="SNR">Signal to Noise Ratio in dB.</param>
        /// <param name="error">Error code.  Zero upon success.</param>
        [DllImport("wioe5ham1")]
        public static extern void wioe5ham1_receive
         (int handle,
          byte[] msg,
          out int len,
          out int src,
          out int dst,
          out int RSS,
          out int SNR,
          out int error);

        /// <summary>
        /// Transmit a binary message frame.
        /// </summary>
        /// <param name="handle">Wio-E5 device handle.</param>
        /// <param name="msg">Payload buffer (243 bytes).</param>
        /// <param name="len">Number of payload bytes to transmit
        /// (1 to 243).</param>
        /// <param name="dst">Destination node ID
        /// (ARCNET Style: 0 for broadcast or 1 to 255 for unicast).</param>
        /// <param name="error">Error code.  Zero upon success.</param>
        [DllImport("wioe5ham1")]
        public static extern void wioe5ham1_send
         (int handle,
          byte[] msg,
          int len,
          int dst,
          out int error);

        /// <summary>
        /// Transmit a string message frame.
        /// </summary>
        /// <param name="handle">Wio-E5 device handle.</param>
        /// <param name="msg">Message string (1 to 243 ASCII characters).</param>
        /// <param name="dst">Destination node ID
        /// (ARCNET Style: 0 for broadcast or 1 to 255 for unicast).</param>
        /// <param name="error">Error code.  Zero upon success.</param>
        [DllImport("wioe5ham1")]
        public static extern void wioe5ham1_send_string
         (int handle,
          string msg,
          int dst,
          out int error);
    }
}
