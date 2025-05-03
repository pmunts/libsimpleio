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

using System;
using static System.Console;
using static System.Threading.Thread;
using static IO.Bindings.libwioe5p2p;

WriteLine("\nWio-E5 LoRa Transceiver Test\n");

int handle;
int error;

wioe5p2p_init("/dev/ttyAMA0", 115200, 915.0F, 7, 500, 12, 15, 22,
    out handle, out error);

if (error != 0)
{
    WriteLine("ERROR: wioe5p2p_init() failed, error=" + error.ToString());
    return;
}

wioe5p2p_send_string(handle, "This is a test", out error);

if (error != 0)
{
    WriteLine("ERROR: wioe5p2p_send_string() failed, error=" + error.ToString());
    return;
}

Sleep(300);

var msg = new byte[255];
int len;
int RSS;
int SNR;

wioe5p2p_receive(handle, msg, out len, out RSS, out SNR, out error);

if (error != 0)
{
    WriteLine("ERROR: wioe5p2p_receive() failed, error=" + error.ToString());
    return;
}

WriteLine("LEN: {0} bytes RSS:{1} dBm SNR: {2} dB", len, RSS, SNR); 
WriteLine(System.Text.Encoding.UTF8.GetString(msg, 0, len));
