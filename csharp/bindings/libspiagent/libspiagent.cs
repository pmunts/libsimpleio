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

using System.Runtime.InteropServices;

namespace IO.Bindings
{
  /// <summary>
  /// <para>
  /// Thin binding class for <c>libspiagent.so</c>, the C driver library for
  /// the <a href="https://tech.munts.com/manuals/MUNTS-0004.pdf">MUNTS-0004
  /// Raspberry Pi LPC1114 I/O Processor Expansion Board</a>, the
  /// <a href="https://tech.munts.com/manuals/MUNTS-0007.pdf">LPC1114 I/O
  /// Processor Grove Module</a>, and other boards.
  /// </para>
  /// <para>These boards all have an
  /// <a href="https://www.nxp.com/products/LPC1100">LPC1114</a> 32-bit ARM
  /// single chip microcontroller running firmware (the "SPI Agent")
  /// that acts as an I/O processor for another computer.  A host computer
  /// board such as a Raspberry Pi or an Arduino (the "Master") can send
  /// commands to the LPC1114 I/O Processor (the "Slave") via an SPI
  /// (<a href="https://en.wikipedia.org/wiki/Serial_Peripheral_Interface">
  /// Serial Peripheral Interface</a>) peripheral bus or an I<sup>2</sup>C
  /// (<a href="https://en.wikipedia.org/wiki/I2C">Inter-Integrated Circuit</a>)
  /// peripheral bus.
  /// </para>
  /// </summary>
  /// <remarks>
  /// The underlying library <c>libspiagent.so</c> only supports a single
  /// connection to a single LPC1114 I/O Processor at a time.
  /// </remarks>
  public static class libspiagent
  {
    /// <summary>
    /// Open a connection to an LPC1114 I/O Processor.
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
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    /// <example>
    /// <para>
    /// LPC1114 I/O Processor attached to a network server:
    /// </para>
    /// <para>
    /// <code>
    /// spiagent_open("http://yourhost.yourmain", out error);
    /// </code>
    /// </para>
    /// <para>
    /// <code>
    /// spiagent_open("oncrpc://yourhost.yourdomain", out error);
    /// </code>
    /// </para>
    /// <para>
    /// <code>
    /// spiagent_open("xmlrpc://yourhost.yourdomain", out error);
    /// </code>
    /// </para>
    /// <para>
    /// LPC1114 I/O processor attached to the computer the calling program is
    /// running on:
    /// </para>
    /// <para>
    /// <code>
    /// spiagent_open("ioctl://localhost", out error);
    /// </code>
    /// </para>
    /// </example>
    /// <remarks>
    /// The underlying library <c>libspiagent.so</c> only supports a single
    /// connection to a single LPC1114 I/O Processor at a time.
    /// </remarks>
    [DllImport("spiagent")]
    public static extern void spiagent_open(string server, out uint error);

    /// <summary>
    /// Close the connection to the LPC1114 I/O Processor.
    /// </summary>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_close(out uint error);

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
    /// LPC1114 I/O Processor command message structure.
    /// </summary>
    [StructLayout(LayoutKind.Sequential)]
    public struct SPIAGENT_COMMAND_MSG_t
    {
      /// <summary>
      /// Command number field.
      /// </summary>
      public uint command;
      /// <summary>
      /// Pin number field.
      /// </summary>
      public uint pin;
      /// <summary>
      /// Command data field.
      /// </summary>
      public uint data;
    }

    /// <summary>
    /// LPC1114 I/O Processor response message struture.
    /// </summary>
    [StructLayout(LayoutKind.Sequential)]
    public struct SPIAGENT_RESPONSE_MSG_t
    {
      /// <summary>
      /// Command number field.
      /// </summary>
      public uint command;
      /// <summary>
      /// Pin number field.
      /// </summary>
      public uint pin;
      /// <summary>
      /// Response data field.
      /// </summary>
      public uint data;
      /// <summary>
      /// Error number field.
      /// </summary>
      public uint error;
    }

    /// <summary>
    /// Dispatch a command to the LPC1114 I/O Processor.
    /// </summary>
    /// <param name="cmd">Command buffer.</param>
    /// <param name="resp">Response buffer.</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    /// <remarks>
    /// See the <a href="https://tech.munts.com/manuals/MUNTS-0004.pdf">
    /// Raspberry Pi LPC1114 I/O Processor Expansion Board User Guide</a> for
    /// the full specification of the <code>cmd</code> and <code>resp</code>
    /// arguments.
    /// </remarks>
    [DllImport("spiagent")]
    public static extern void spiagent_command(ref SPIAGENT_COMMAND_MSG_t cmd,
      ref SPIAGENT_RESPONSE_MSG_t resp, out uint error);

  }
}