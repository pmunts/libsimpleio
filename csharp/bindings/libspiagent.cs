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

using System;
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
    public static extern void spiagent_open(string server, out int error);

    /// <summary>
    /// Close the connection to the LPC1114 I/O Processor.
    /// </summary>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_close(out int error);

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
      /// GPIO pin number field.
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
      /// GPIO pin number field.
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
      ref SPIAGENT_RESPONSE_MSG_t resp, out int error);

    /// <summary>
    /// Configure an LPC1114 I/O Processor analog input.
    /// </summary>
    /// <param name="pin">Analog input pin number.</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    /// <remarks>
    /// The resolution of the LPC1114 single chip microcontroller A/D converter
    /// is 10 bits, yielding measurements with at best 3 significant decimal
    /// digits.  Its reference voltage and input span are the LPC1114 power
    /// supply voltage, nominally 3.3V.  Absolute accuracy will therefore
    /// depend upon the accuracy of the power supply (under load!) that feeds
    /// the LPC1114.
    /// </remarks>
    [DllImport("spiagent")]
    public static extern void spiagent_analog_configure(uint pin,
      out int error);

    /// <summary>
    /// Get analog input voltage.
    /// </summary>
    /// <param name="pin">Analog input pin number.</param>
    /// <param name="voltage">Analog input voltage (0.0V to 3.3V).</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    /// <remarks>
    /// The resolution of the LPC1114 single chip microcontroller A/D converter
    /// is 10 bits, yielding measurements with at best 3 significant decimal
    /// digits.  Its reference voltage and input span are the LPC1114 power
    /// supply voltage, nominally 3.3V.  Absolute accuracy will therefore
    /// depend upon the accuracy of the power supply (under load!) that feeds
    /// the LPC1114.
    /// </remarks>
    [DllImport("spiagent")]
    public static extern void spiagent_analog_get(uint pin, out float voltage,
      out int error);

    /// <summary>
    /// Configure an LPC1114 I/O Processor GPIO pin.
    /// </summary>
    /// <param name="pin">GPIO pin number.</param>
    /// <param name="direction">Direction (0=input, 1=output).</param>
    /// <param name="state">Initial state for output pin (0=low, 1=high).
    /// </param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_gpio_configure(uint pin,
      uint direction, uint state, out int error);

    /// <summary>
    /// Configure an LPC1114 I/O Processor GPIO pin.
    /// </summary>
    /// <param name="pin">GPIO pin number.</param>
    /// <param name="mode">Configuration mode.</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_gpio_configure_mode(uint pin,
      uint mode, out int error);

    /// <summary>
    /// Configure an LPC1114 I/O Procesor GPIO pin interrupt mode.
    /// </summary>
    /// <param name="pin">GPIO pin number</param>
    /// <param name="intconfig">Interrupt edge detection configuration
    /// (0=disabled, 1=falling edge, 2=rising edge, 3=both edges).
    /// </param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_gpio_configure_interrupt(uint pin,
      uint intconfig, out int error);

    /// <summary>
    /// Get GPIO pin state.
    /// </summary>
    /// <param name="pin">GPIO pin number.</param>
    /// <param name="state">Set to GPIO pin state (0=low, 1=high).</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_gpio_get(uint pin, out uint state,
      out int error);

    /// <summary>
    /// Put GPIO output pin state.
    /// </summary>
    /// <param name="pin">GPIO pin number.</param>
    /// <param name="state">New output state (0=low, 1=high).</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_gpio_put(uint pin, uint state,
      out int error);

    /// <summary>
    /// Send LEGO® Power Functions Remote Control command.
    /// </summary>
    /// <param name="pin">GPIO pin number to drive infrared emitter.</param>
    /// <param name="channel">Channel number (1 to 4).</param>
    /// <param name="motor">Motor ID (0 to 4: All Stop, Motor A, Motor B,
    /// Combo Direct, Combo PWM).</param>
    /// <param name="direction">Direction (0 to 1: reverse, forward).
    /// </param>
    /// <param name="speed">Speed control (0 to 7 for Motor A or Motor B,
    /// 0 to 15 for Combo Direct, and 0 to 255 for Combo PWM</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_legorc_put(uint pin, uint channel,
      uint motor, uint direction, uint speed, out int error);

    /// <summary>
    /// Set PWM output pulse frequency.
    /// </summary>
    /// <param name="frequency">Pulse frequency in Hz.</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    /// <remarks>
    /// All PWM outputs share the same pulse frequency.
    /// </remarks>
    [DllImport("spiagent")]
    public static extern void spiagent_pwm_set_frequency(uint frequency,
      out int error);

    /// <summary>
    /// Configure a GPIO pin as a PWM output.
    /// </summary>
    /// <param name="pin">PWM output pin number.</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    /// <remarks>
    /// <para>
    /// All PWM outputs share the same pulse frequency.
    /// </para>
    /// <para>
    /// You <b>must</b> set the common PWM pulse output frequency with a call
    /// to <c>spiagent_pwm_set_frequency()</c> <b>before</b> configuring a
    /// PWM output.
    /// </para>
    /// </remarks>
    [DllImport("spiagent")]
    public static extern void spiagent_pwm_configure(uint pin, out int error);

    /// <summary>
    /// Set PWM output pulse duty cycle.
    /// </summary>
    /// <param name="pin">PWM output pin number.</param>
    /// <param name="duty">PWM output duty cycle percentage (0.0 to 100.0).</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_pwm_put(uint pin, float duty, out int error);

    /// <summary>
    /// Configure a GPIO pin as a servo output.
    /// </summary>
    /// <param name="pin">Servo output pin number.</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    /// <remarks>
    /// <para>
    /// All PWM outputs share the same pulse frequency.
    /// </para>
    /// <para>
    /// You <b>must</b> set the common PWM pulse output frequency to a value
    /// from 50 to 400 Hz with a call to <c>spiagent_pwm_set_frequency()</c>
    /// <b>before</b> configuring a servo output.
    /// </para>
    /// </remarks>
    [DllImport("spiagent")]
    public static extern void spiagent_servo_configure(uint pin, out int error);

    /// <summary>
    /// Set servo position.
    /// </summary>
    /// <param name="pin">Servo output pin number.</param>
    /// <param name="position">Normalized servo position (-1.0 to +1.0).</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_servo_put(uint pin, float position,
      out int error);

    /// <summary>
    /// Configure a pair of GPIO pins for an H-Bridge DC motor driver.
    /// </summary>
    /// <param name="pwmpin">Speed PWM output pin number.</param>
    /// <param name="dirpin">Direction GPIO output pin number.</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    /// <remarks>
    /// <para>
    /// All PWM outputs share the same pulse frequency.
    /// </para>
    /// <para>
    /// You <b>must</b> set the common PWM pulse output frequency with a call
    /// to <c>spiagent_pwm_set_frequency()</c> <b>before</b> configuring an
    /// H-Bridge DC motor driver.
    /// </para>
    /// <para>
    /// Certain motor driver modules such as the
    /// <a href="https://www.cytron.io/p-13a-6v-30v-dc-motor-driver">
    /// Cytron MD13s</a> can driven by GPIO direction and PWM speed signals.
    /// Most will require some form of motor driver signal transcoding such as
    /// the <a href="https://tech.munts.com/manuals/MUNTS-0005.pdf">
    /// MUNTS-0005 PWM Isolator/Encoder</a> module.
    /// </para>
    /// </remarks>
    [DllImport("spiagent")]
    public static extern void spiagent_motor_configure(uint pwmpin,
      uint dirpin, out int error);

    /// <summary>
    /// Set motor velocity (<i>i.e.</i> speed and direction of rotation).
    /// </summary>
    /// <param name="pwmpin">Speed PWM output pin number.</param>
    /// <param name="dirpin">Direction GPIO output pin number.</param>
    /// <param name="speed">Normalized motor velocity (-1.0 to +1.0).</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_motor_put(uint pwmpin, uint dirpin,
      float speed, out int error);

    /// <summary>
    /// Read from an LPC1114 Special Function Register
    /// </summary>
    /// <param name="addr">SFR address.</param>
    /// <param name="data">SFR data.</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_sfr_get(uint addr, out uint data,
      out int error);

    /// <summary>
    /// Write to an LPC1114 Special Function Register
    /// </summary>
    /// <param name="addr">SFR address.</param>
    /// <param name="data">SFR data.</param>
    /// <param name="error">Set to <c>0</c> upon success, or an
    /// <a href="https://en.wikipedia.org/wiki/Errno.h"><c>errno</c></a>
    /// error number upon failure.
    /// </param>
    [DllImport("spiagent")]
    public static extern void spiagent_sfr_put(uint addr, uint data,
      out int error);
  }
}
