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

using System.Collections.Generic;
using IO.Objects.LPC1114IOP.GPIO;

using static IO.Bindings.libspiagent;

namespace IO.Objects.LPC1114IOP.Interrupt
{
  /// <summary>
  /// Interrupt wait outcomes.
  /// </summary>
  public enum interrupt_outcome_t
  {
    /// <summary>
    /// An interrupt was received from the LPC1114 I/O Processor.
    /// </summary>
    INTERRUPT,
    /// <summary>
    /// The interrupt wait timeout expired.
    /// </summary>
    TIMEOUT
  }

  /// <summary>
  /// This static class encapsulates the portion of the LPC1114 I/O Processor
  /// interrupt chain that runs on the host computer (<i>e.g.</i>
  /// Raspberry Pi).
  /// </summary>
  /// <remarks>
  /// <para>
  /// This class is only usable when the host computer (<i>e.g.</i>
  /// Raspberry Pi) is directly connected to the LPC1114 I/O Processor.
  /// </para>
  /// <para>
  /// The host computer (<i>e.g.</i> Raspberry Pi) interrupt <b>input</b> GPIO
  /// pin that will be driven by the LPC1114 I/O Processor interrupt
  /// <b>output</b> GPIO pin must be defined by the <c>LPC1114_INT</c>
  /// variable in the configuration file
  /// <c>/usr/local/etc/expansion_lpc1114.config</c>.
  /// </para>
  /// </remarks>
  public static class Handler
  {
    /// <summary>
    /// Enable host computer (<i>e.g.</i> Raspberry Pi) interrupt handling
    /// (actually GPIO input edge detection).
    /// </summary>
    public static void Enable()
    {
      int error;

      IO.Bindings.libspiagent.spiagent_interrupt_enable(out error);

      if (error != 0)
        throw new System.Exception("spiagent_interrupt_enable() failed, error=" +
          error.ToString());
    }

    /// <summary>
    /// Disable host computer (<i>e.g.</i> Raspberry Pi) interrupt handling
    /// (actually GPIO input edge detection).
    /// </summary>
    public static void Disable()
    {
      int error;

      IO.Bindings.libspiagent.spiagent_interrupt_disable(out error);

      if (error != 0)
        throw new System.Exception("spiagent_interrupt_disable() failed, error=" +
          error.ToString());
    }

    /// <summary>
    /// Wait for an interrupt from the LPC1114 I/O Processor.
    /// </summary>
    /// <param name="timeout">Time to wait in milliseconds.  A value less than 1
    /// indicates wait forever.
    /// </param>
    /// <param name="outcome">What happened to end the wait for an interrupt.
    /// </param>
    /// <remarks>
    /// This method only blocks the thread from which it was called.
    /// </remarks>
    public static void Wait(int timeout, out interrupt_outcome_t outcome)
    {
      int error;

      IO.Bindings.libspiagent.spiagent_interrupt_wait(timeout, out error);

      switch (error)
      {
        case  0: // EOK
          outcome = interrupt_outcome_t.INTERRUPT;
          return;

        case 11: // EAGAIN
          outcome = interrupt_outcome_t.TIMEOUT;
          return;
      }

      throw new System.Exception("spiagent_interrupt_wait() failed, error=" +
        error.ToString());
    }
  }
}
