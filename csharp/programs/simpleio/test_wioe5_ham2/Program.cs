// Wio-E5 LoRa Transceiver Test

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

// This program requires a receive station running either test_wioe5_rx_ham2
// or wioe5_ham2_responder.
//
// See also: https://git.munts.com/libsimpleio/doc/WioE5LoRaP2P.pdf

using static System.Console;
using static System.Environment;
using static System.Threading.Thread;

WriteLine("\nWio-E5 LoRa Transceiver Test\n");

if (args.Length != 3)
{
  WriteLine("Usage: test_wioe5_ham2 <network id> <node id> <iterations>\n");
  Exit(1);
}

var dev           = new IO.Devices.WioE5.Ham2.Device();
var msg           = new byte[255];
var respondernet  = args[0];
var respondernode = int.Parse(args[1]);
var iterations    = int.Parse(args[2]);

for (int i = 1; i <= iterations; i++)
{
  dev.Send("This is test " + i.ToString(), respondernet, respondernode);

  Sleep(400);

  dev.Receive(msg, out int len, out string srcnet, out int srcnode,
    out string dstnet, out int dstnode, out int RSS, out int SNR);

  WriteLine("LEN: {0} bytes RSS:{1} dBm SNR: {2} dB", len, RSS, SNR);
  WriteLine(System.Text.Encoding.UTF8.GetString(msg, 0, len));
}
