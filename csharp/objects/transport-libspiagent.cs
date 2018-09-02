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

using System.Runtime.InteropServices;
using IO.Objects.libsimpleio.Exceptions;

namespace SPIAgent
{
  /// <summary>
  /// SPIAgent transport implementation using <c>libspiagent.so</c> to
  /// communicate with the LPC1114 I/O Processor.
  /// </summary>
  public class Transport_libspiagent : ITransport
  {
    private int[] cmdbuf;
    private int[] respbuf;

    [DllImport("spiagent")]
    private static extern void spiagent_open(string devname, out int error);

    [DllImport("spiagent")]
    private static extern void spiagent_close(out int error);

    [DllImport("spiagent")]
    private static extern void spiagent_command(int[] cmd, int[] resp,
      out int error);

    /// <summary>
    /// Constructor for an SPIAgent transport object.
    /// </summary>
    /// <param name="servername">Server name.</param>
    public Transport_libspiagent(string servername)
    {
      int error;

      spiagent_open(servername, out error);

      if (error != 0)
        throw new Exception("spiagent_open() failed", error);

      cmdbuf = new int[3];
      respbuf = new int[4];
    }

    ~Transport_libspiagent()
    {
      int error;

      spiagent_close(out error);

      if (error != 0)
        throw new Exception("spiagent_close() failed", error);
    }

    /// <summary>
    /// Issue a command to and receive a response from the LPC1114 I/O
    /// Processor.
    /// </summary>
    /// <param name="cmd">Command message object.</param>
    /// <param name="resp">Response message object.</param>
    public void Command(SPIAGENT_COMMAND_MSG_t cmd,
      ref SPIAGENT_RESPONSE_MSG_t resp)
    {
      int error;

      cmdbuf[0] = cmd.command;
      cmdbuf[1] = cmd.pin;
      cmdbuf[2] = cmd.data;

      spiagent_command(cmdbuf, respbuf, out error);

      if (error != 0)
        throw new Exception("spiagent_command() failed", error);

      resp.command = respbuf[0];
      resp.pin     = respbuf[1];
      resp.data    = respbuf[2];
      resp.error   = respbuf[3];
    }
  }
}
