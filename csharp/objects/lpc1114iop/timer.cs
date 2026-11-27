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
using System.IO;

namespace IO.Objects.LPC1114IOP.Timer
{
  /// <summary>
  /// LPC1114 32-bit hardware timer identifiers.
  /// </summary>
  public enum timer_id_t
  {
    CT32B0,
    CT32B1
  };

  /// <summary>
  /// LPC1114 32-bit hardware timer counting configurations.
  /// </summary>
  /// <remarks>
  /// <c>CT32B0</c> capture input <c>CAP0</c> is <i>aka</i> <c>GPIO5</c>
  /// <i>aka</i> LPC1114 pin <c>PIO1_5</c>.
  /// <br/>
  /// <c>CT32B1</c> capture input <c>CAP0</c> is <i>aka</i> <c>GPIO0</c>
  /// <i>aka</i> LPC1114 pin <c>PIO1_0</c>.
  /// </remarks>
  public enum mode_t
  {
    /// <summary>
    /// Disable counter.
    /// </summary>
    DISABLED,
    /// <summary>
    /// Reset counter.
    /// </summary>
    RESET,
    /// <summary>
    /// Clock source is PCLK, 48 MHz.
    /// </summary>
    PCLK,
    /// <summary>
    /// Clock source is CAP0 input rising edges.
    /// </summary>
    CAP0_RISING,
    /// <summary>
    /// Clock source is CAP0 input falling edges.
    /// </summary>
    CAP0_FALLING,
    /// <summary>
    /// Clock source is CAP0 input rising and falling edges.
    /// </summary>
    CAP0_BOTH
  };

  /// <summary>
  /// LPC1114 32-bit hardware timer capture configurations.
  /// </summary>
  /// <remarks>
  /// <c>CT32B0</c> capture input <c>CAP0</c> is <i>aka</i> <c>GPIO5</c>
  /// <i>aka</i> LPC1114 pin <c>PIO1_5</c>.
  /// <br/>
  /// <c>CT32B1</c> capture input <c>CAP0</c> is <i>aka</i> <c>GPIO0</c>
  /// <i>aka</i> LPC1114 pin <c>PIO1_0</c>.
  /// </remarks>
  public enum capture_edge_t
  {
    /// <summary>
    /// Counter capture is disabled.
    /// </summary>
    DISABLED,
    /// <summary>
    /// Capture counter value on CAP0 input rising edge.
    /// </summary>
    CAP0_RISING,
    /// <summary>
    /// Capture counter value on CAP0 input falling edge.
    /// </summary>
    CAP0_FALLING,
    /// <summary>
    /// Capture counter value on CAP0 input rising and falling edges.
    /// </summary>
    CAP0_BOTH
  };

  /// <summary>
  /// LPC1114 32-bit hardware timer capture interrupt configurations.
  /// </summary>
  public enum capture_interrupt_t
  {
    DISABLED,
    ENABLED
  };

  /// <summary>
  /// LPC1114 32-bit hardware timer match register identifiers.
  /// </summary>
  public enum match_register_t
  {
    /// <summary>
    /// Output to<c>MAT0</c> <i>aka</i> <c>GPIO1</c> <i>aka</i> LPC1114 pin PIO1_1
    /// </summary>
    MATCH0,
    /// <summary>
    /// Output to<c>MAT1</c> <i>aka</i> <c>GPIO2</c> <i>aka</i> LPC1114 pin PIO1_2
    /// </summary>
    MATCH1,
    /// <summary>
    /// Output to<c>MAT2</c> <i>aka</i> <c>GPIO3</c> <i>aka</i> LPC1114 pin PIO1_3
    /// </summary>
    MATCH2,
    /// <summary>
    /// Output to<c>MAT3</c> <i>aka</i> <c>GPIO4</c> <i>aka</i> LPC1114 pin PIO1_4
    /// </summary>
    MATCH3
  };

  /// <summary>
  /// LPC1114 32-bit hardware timer match output action configurations.
  /// </summary>
  public enum match_action_t
  {
    DISABLED,
    CLEAR,
    SET,
    TOGGLE
  };

  /// <summary>
  /// LPC1114 32-bit hardware timer match interrupt configurations.
  /// </summary>
  public enum match_interrupt_t
  {
    DISABLED,
    ENABLED
  };

  /// <summary>
  /// LPC1114 32-bit hardware timer match reset configurations.
  /// </summary>
  public enum match_reset_t
  {
    DISABLED,
    ENABLED
  };

  /// <summary>
  /// LPC1114 32-bit hardware timer match stop configurations.
  /// </summary>
  public enum match_stop_t
  {
    DISABLED,
    ENABLED
  };

  /// <summary>
  /// This class encapsulates an LPC1114 32-bit hardware counter/timer.
  /// </summary>
  /// <remarks>
  /// <para>
  /// The internal clock of the LPC1114 microcontroller is only accurate to ±1%
  /// over the temperature range of -40º C to +85º C.
  /// </para>
  /// <para>
  /// The timer services provided by this class are very complicated, in order
  /// to support all of the features of the LPC1114 32-bit hardware
  /// counter/timers.  You will need to carefully study the
  /// <a href="https://www.mikrocontroller.net/attachment/104807/UM10398_-_LPC11xx_UserManual.pdf">
  /// LPC11xx User Manual</a>
  /// in order to fully understand how the counter/timers work.
  /// </para>
  /// </remarks>
  public class Counter
  {
    private uint mytimer;

    /// <summary>
    /// LPC1114 32-bit hardware counter/timer object constructor.
    /// </summary>
    /// <param name="timer">Timer identifier.</param>
    /// <remarks>
    /// This constructor just powers up a LPC1114 32-bit hardware
    /// counter/timer.  You will need to call other methods to finish
    /// configuring it.
    /// </remarks>
    public Counter(timer_id_t timer)
    {
      int error;

      IO.Bindings.libspiagent.spiagent_timer_init((uint) timer, out error);

      if (error != 0)
        throw new System.Exception("spiagent_timer_init() failed, error=" +
          error.ToString());

      this.mytimer = (uint) timer;
    }

    /// <summary>
    /// Configure the LPC1114 32-bit counter/timer counting mode.
    /// </summary>
    /// <param name="mode">Counting mode.</param>
    public void ConfigureMode(mode_t mode)
    {
      int error;

      IO.Bindings.libspiagent.spiagent_timer_configure_mode(this.mytimer,
        (uint) mode, out error);

      if (error != 0)
        throw new System.Exception("spiagent_timer_configure_mode() failed, error=" +
          error.ToString());
    }

    /// <summary>
    /// Configure the LPC1114 32-bit counter/timer prescaler.
    /// </summary>
    /// <param name="divisor">Prescale counter divisor.</param>
    public void ConfigurePrescaler(uint divisor)
    {
      int error;

      IO.Bindings.libspiagent.spiagent_timer_configure_prescaler(this.mytimer,
        divisor, out error);

      if (error != 0)
        throw new System.Exception("spiagent_timer_configure_prescaler() failed, error=" +
          error.ToString());
    }

    /// <summary>
    /// Configure the LPC1114 32-bit counter/timer capture mode.
    /// </summary>
    /// <param name="edge">Capture edge configuration.</param>
    /// <param name="intr">Capture interrupt configuration.</param>
    public void ConfigureCapture(capture_edge_t edge, capture_interrupt_t intr)
    {
      int error;

      IO.Bindings.libspiagent.spiagent_timer_configure_capture(this.mytimer,
        (uint) edge, (uint) intr, out error);

      if (error != 0)
        throw new System.Exception("spiagent_timer_configure_capture() failed, error=" +
          error.ToString());
    }

    /// <summary>
    /// Configure an LPC1114 32-bit counter/timer match register.
    /// </summary>
    /// <param name="reg">Match register ID.</param>
    /// <param name="value">Match value.</param>
    /// <param name="action">Match output action.</param>
    /// <param name="intr">Match interrupt configuration.</param>
    /// <param name="reset">Match reset configuration.</param>
    /// <param name="stop">Match stop configuration.</param>
    public void ConfigureMatch(match_register_t reg, uint value,
      match_action_t action, match_interrupt_t intr, match_reset_t reset,
      match_stop_t stop)
    {
      int error;

      IO.Bindings.libspiagent.spiagent_timer_configure_match(this.mytimer,
        (uint) reg, value, (uint) action, (uint) intr, (uint) reset,
        (uint) stop, out error);

      if (error != 0)
        throw new System.Exception("spiagent_timer_configure_match() failed, error=" +
          error.ToString());
    }

    /// <summary>
    /// Retrieve the contents of the counter register.
    /// </summary>
    /// <returns>32-bit count value.</returns>
    public uint GetCounter()
    {
      uint value;
      int error;

      IO.Bindings.libspiagent.spiagent_timer_get(this.mytimer, out value,
        out error);

      if (error != 0)
        throw new System.Exception("spiagent_timer_get() failed, error=" +
          error.ToString());

      return value;
    }

    /// <summary>
    /// Retrieve the contents of the capture register.
    /// </summary>
    /// <returns>32-bit count value.</returns>
    public uint GetCapture()
    {
      uint value;
      int error;

      IO.Bindings.libspiagent.spiagent_timer_get_capture(this.mytimer,
        out value, out error);

      if (error != 0)
        throw new System.Exception("spiagent_timer_capture() failed, error=" +
          error.ToString());

      return value;
    }

    /// <summary>
    /// Retrieve the difference between the last two capture values.
    /// </summary>
    /// <returns>32-bit count value.</returns>
    public uint GetCaptureDelta()
    {
      uint value;
      int error;

      IO.Bindings.libspiagent.spiagent_timer_get_capture_delta(this.mytimer,
        out value, out error);

      if (error != 0)
        throw new System.Exception("spiagent_timer_capture_delta() failed, error=" +
          error.ToString());

      return value;
    }
  }
}
