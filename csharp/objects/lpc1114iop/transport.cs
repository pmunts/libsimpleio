// Copyright (C)2026, Philip Munts dba Munts Technologies.
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

using static IO.Bindings.libspiagent;

namespace IO.Objects.LPC1114IOP
{
  /// <summary>
  /// LPC1114 I/O Processor transport services.
  /// </summary>
  public static class Transport
  {
    /// <summary>
    /// Open a transport connection to an LPC1114 I/O Processor.
    /// </summary>
    /// <param name="server">
    /// <para>
    /// Indicates the communication protocol and host name (Domain name or IP
    /// address) of the network server with an attached LPC1114 I/O Processor,
    /// of the form <c>[protocol]://[host]</c>.
    /// </para>
    /// <para>
    /// The following network communication protocols are supported:
    /// </para>
    /// <para>
    /// <c>http</c> (<a href="https://en.wikipedia.org/wiki/HTTP">
    /// Hypertext Transfer Protocol</a>),
    /// <br/>
    /// <c>oncrpc</c> (<a href="https://en.wikipedia.org/wiki/Sun_RPC">
    /// Open Network Computing Remote Procedure Call</a>), and
    /// <br/>
    /// <c>xmlrpc</c> (<a href="https://en.wikipedia.org/wiki/XML-RPC">
    /// XML Remote Procedure Call</a>).
    /// </para>
    /// <para>
    /// The additional special string <c>ioctl://localhost</c> indicates the
    /// LPC1114 I/O Processor is attached directly to the computer the calling
    /// program is running on, either to an SPI
    /// (<a href="https://en.wikipedia.org/wiki/Serial_Peripheral_Interface">
    /// Serial Peripheral Interface</a>) peripheral bus, or to an I<sup>2</sup>C
    /// (<a href="https://en.wikipedia.org/wiki/I2C">Inter-Integrated Circuit</a>)
    /// peripheral bus.
    /// </para>
    /// </param>
    /// <remarks>
    /// The underlying library <c>libspiagent.so</c> only supports a single
    /// transport connection to a single LPC1114 I/O Processor at a time.
    /// </remarks>
    public static void Open(string server = "ioctl://localhost")
    {
      int error;

      spiagent_open(server, out error);

      if (error != 0)
        throw new System.Exception("spiagent_open() failed, error=" +
          error.ToString());
    }

    /// <summary>
    /// Close the existing transport connection to an LPC1114 I/O Processor.
    /// </summary>
    public static void Close()
    {
      int error;

      IO.Bindings.libspiagent.spiagent_close(out error);

      if (error != 0)
        throw new System.Exception("spiagent_open() failed, error=" +
          error.ToString());
    }

    /// <summary>
    /// LPC1114 I/O Processor command codes.
    /// </summary>
    public enum SPIAGENT_COMMAND_t
    {
      SPIAGENT_CMD_NOP,
      SPIAGENT_CMD_LOOPBACK,
      SPIAGENT_CMD_CONFIGURE_ANALOG_INPUT,
      SPIAGENT_CMD_CONFIGURE_GPIO_INPUT,
      SPIAGENT_CMD_CONFIGURE_GPIO_OUTPUT,
      SPIAGENT_CMD_CONFIGURE_PWM_OUTPUT,
      SPIAGENT_CMD_GET_ANALOG,
      SPIAGENT_CMD_GET_GPIO,
      SPIAGENT_CMD_PUT_GPIO,
      SPIAGENT_CMD_PUT_PWM,
      SPIAGENT_CMD_CONFIGURE_GPIO_INTERRUPT,
      SPIAGENT_CMD_CONFIGURE_GPIO,
      SPIAGENT_CMD_PUT_LEGORC,
      SPIAGENT_CMD_GET_SFR,
      SPIAGENT_CMD_PUT_SFR,
      SPIAGENT_CMD_CONFIGURE_TIMER_MODE,
      SPIAGENT_CMD_CONFIGURE_TIMER_PRESCALER,
      SPIAGENT_CMD_CONFIGURE_TIMER_CAPTURE,
      SPIAGENT_CMD_CONFIGURE_TIMER_MATCH0,
      SPIAGENT_CMD_CONFIGURE_TIMER_MATCH1,
      SPIAGENT_CMD_CONFIGURE_TIMER_MATCH2,
      SPIAGENT_CMD_CONFIGURE_TIMER_MATCH3,
      SPIAGENT_CMD_CONFIGURE_TIMER_MATCH0_VALUE,
      SPIAGENT_CMD_CONFIGURE_TIMER_MATCH1_VALUE,
      SPIAGENT_CMD_CONFIGURE_TIMER_MATCH2_VALUE,
      SPIAGENT_CMD_CONFIGURE_TIMER_MATCH3_VALUE,
      SPIAGENT_CMD_GET_TIMER_VALUE,
      SPIAGENT_CMD_GET_TIMER_CAPTURE,
      SPIAGENT_CMD_GET_TIMER_CAPTURE_DELTA,
      SPIAGENT_CMD_INIT_TIMER
    }

    /// <summary>
    /// Command message object instance factory.
    /// </summary>
    /// <param name="command">Command number.</param>
    /// <param name="pin">Pin number.</param>
    /// <param name="data">Command data.</param>
    /// <returns>Command message object instance.</returns>
    public static SPIAGENT_COMMAND_MSG_t CommandFactory(SPIAGENT_COMMAND_t
      command = SPIAGENT_COMMAND_t.SPIAGENT_CMD_NOP, uint pin = 0,
      uint data = 0)
    {
      SPIAGENT_COMMAND_MSG_t cmd;
      cmd.command = (uint)command;
      cmd.pin = pin;
      cmd.data = data;
      return cmd;
    }

    /// <summary>
    /// Response message object instance factory.
    /// </summary>
    /// <param name="command">Command number.</param>
    /// <param name="pin">Pin number.</param>
    /// <param name="data">Response data.</param>
    /// <param name="error"><c>errno</c> Error number.</param>
    /// <returns></returns>
    public static SPIAGENT_RESPONSE_MSG_t ResponseFactory(SPIAGENT_COMMAND_t
      command = SPIAGENT_COMMAND_t.SPIAGENT_CMD_NOP, uint pin = 0,
      uint data = 0, uint error = 0)
    {
      SPIAGENT_RESPONSE_MSG_t resp;
      resp.command = 0;
      resp.pin = 0;
      resp.data = 0;
      resp.error = 0;
      return resp;
    }

    /// <summary>
    /// Dispatch a command to an LPC1114 I/O Processor and retrieve results.
    /// </summary>
    /// <param name="cmd">Command buffer.</param>
    /// <param name="resp">Response buffer.</param>
    /// <remarks>
    /// See the <a href="https://tech.munts.com/manuals/MUNTS-0004.pdf">
    /// Raspberry Pi LPC1114 I/O Processor Expansion Board User Guide</a> for
    /// the full specification of the <code>cmd</code> and <code>resp</code>
    /// arguments.
    /// </remarks>
    public static void Execute(ref SPIAGENT_COMMAND_MSG_t cmd,
      ref SPIAGENT_RESPONSE_MSG_t resp)
    {
      int error;

      IO.Bindings.libspiagent.spiagent_command(ref cmd, ref resp, out error);

      if (error != 0)
        throw new System.Exception("spiagent_command() failed, error=" +
          error.ToString());

      if (resp.error != 0)
        throw new System.Exception("LPC1114 I/O Processor operation failed, error=" +
          error.ToString());
    }
  }
}