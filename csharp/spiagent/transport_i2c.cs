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

namespace SPIAgent
{
  /// <summary>
  /// SPIAgent transport implementation using I<sup>2</sup>C to
  /// communicate with the LPC1114 I/O Processor.
  /// </summary>
  public class Transport_I2C : ITransport
  {
    private const byte LPC1114_I2C_ADDRESS = 0x44;
    private readonly IO.Interfaces.I2C.Device dev;
    private readonly bool clockstretch;
    private readonly System.Diagnostics.Stopwatch timer;
    private readonly long ClocksPerMicrosecond;
    private byte[] cmd_bytes;
    private byte[] resp_bytes;

    /// <summary>
    /// Constructor for an SPIAgent transport object.
    /// </summary>
    /// <param name="bus">I<sup>2</sup>C bus controller instance.</param>
    /// <param name="clockstretch"><c>true</c> if the I<sup>2</sup>C bus
    /// controller supports clock stretching.</param>
    public Transport_I2C(IO.Interfaces.I2C.Bus bus, bool clockstretch = false)
    {
      this.dev = new IO.Interfaces.I2C.Device(bus, LPC1114_I2C_ADDRESS);
      this.clockstretch = clockstretch;
      this.timer = new System.Diagnostics.Stopwatch();
      this.ClocksPerMicrosecond = System.Diagnostics.Stopwatch.Frequency / 1000000L;
      this.cmd_bytes = new byte[12];
      this.resp_bytes = new byte[16];
    }

    // Busy wait for at least the specified number of microseconds

    private void usleep(int usecs)
    {
      timer.Restart();

      long limit = timer.ElapsedTicks + usecs * ClocksPerMicrosecond;
      while (timer.ElapsedTicks < limit) ;

      timer.Stop();
    }

    // Split a 32-bit integer into individual bytes

    private static byte Split32(int n, int b)
    {
      return System.Convert.ToByte((n >> (b * 8)) & 0xFF);
    }

    // Combine 4 bytes into a 32-bit integer

    private static int Build32(byte b0, byte b1, byte b2, byte b3)
    {
      return (b3 << 24) | (b2 << 16) | (b1 << 8) | b0;
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
      // Split the command message into a byte array

      cmd_bytes[0] = Split32(cmd.command, 0);
      cmd_bytes[1] = Split32(cmd.command, 1);
      cmd_bytes[2] = Split32(cmd.command, 2);
      cmd_bytes[3] = Split32(cmd.command, 3);

      cmd_bytes[4] = Split32(cmd.pin, 0);
      cmd_bytes[5] = Split32(cmd.pin, 1);
      cmd_bytes[6] = Split32(cmd.pin, 2);
      cmd_bytes[7] = Split32(cmd.pin, 3);

      cmd_bytes[8] = Split32(cmd.data, 0);
      cmd_bytes[9] = Split32(cmd.data, 1);
      cmd_bytes[10] = Split32(cmd.data, 2);
      cmd_bytes[11] = Split32(cmd.data, 3);

      // Dispatch the command

      if (cmd.command == (int)Commands.SPIAGENT_CMD_PUT_LEGORC)
      {
        // The LEGO infrared protocol takes a REALLY LONG time...

        dev.Transaction(cmd_bytes, cmd_bytes.Length, resp_bytes,
          resp_bytes.Length, 20000);
      }
      else if (clockstretch)
      {
        // The I2C bus supports clock stretching, so we can send the commmand
        // and receive the response in a single I2C transaction.

        dev.Transaction(cmd_bytes, cmd_bytes.Length, resp_bytes,
          resp_bytes.Length);
      }
      else
      {
        // The I2C bus does not support clock stretching, so we have to pause
        // between sending the command and receiving the response.

        dev.Transaction(cmd_bytes, cmd_bytes.Length, resp_bytes,
          resp_bytes.Length, 100);
      }

      // Assemble the response message from the response byte array

      resp.command = Build32(resp_bytes[0], resp_bytes[1],
        resp_bytes[2], resp_bytes[3]);

      resp.pin = Build32(resp_bytes[4], resp_bytes[5],
        resp_bytes[6], resp_bytes[7]);

      resp.data = Build32(resp_bytes[8], resp_bytes[9],
        resp_bytes[10], resp_bytes[11]);

      resp.error = Build32(resp_bytes[12], resp_bytes[13],
        resp_bytes[14], resp_bytes[15]);
    }
  }
}
