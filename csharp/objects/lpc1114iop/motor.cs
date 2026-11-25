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

namespace IO.Objects.LPC1114IOP.Motor
{
  /// <summary>
  /// This class encapsulates LPC1114 I/O Processor H-Bridge DC motor driver
  /// outputs.
  /// </summary>
  public class Output : IO.Interfaces.Motor.Output
  {
    private uint mydirpin;
    private uint mypwmpin;
    private double myvelocity;

    /// <summary>
    /// H-Bridge DC motor driver output object constructor.
    /// </summary>
    /// <param name="dirpin">Direction GPIO output pin number.</param>
    /// <param name="pwmpin">Speed PWM output pin number.</param>
    /// <param name="velocity">Normalized motor velocity (-1.0 to +1.0).</param>
    /// <remarks>
    /// <para>
    /// All PWM outputs share the same pulse frequency.
    /// </para>
    /// <para>
    /// You <b>must</b> set the common PWM output pulse frequency (<i>i.e.</i>
    /// <c>IO.Objects.LPC1114IOP.PWM.Output.frequency = 1000;</c>) <b>before</b>
    /// configuring an H-Bridge DC motor driver output.
    /// </para>
    /// <para>
    /// Certain motor driver modules such as the
    /// <a href="https://www.cytron.io/p-13a-6v-30v-dc-motor-driver">
    /// Cytron MD13s</a> can driven by direction and speed signals.  Most will
    /// require some form of motor driver signal transcoding such as the
    /// <a href="https://tech.munts.com/manuals/MUNTS-0005.pdf">
    /// MUNTS-0005 PWM Isolator/Encoder</a> module.
    /// </para>
    /// </remarks>
    public Output(IO.Objects.LPC1114IOP.GPIO.pin_id_t dirpin,
      IO.Objects.LPC1114IOP.PWM.pin_id_t pwmpin, double velocity = 0.0)
    {
      if ((velocity < -1.0) || (velocity > +1.0))
        throw new System.Exception("motor velocity value is out of range.");

      int error;

      spiagent_motor_configure((uint) pwmpin, (uint) dirpin, out error);

      if (error != 0)
        throw new System.Exception("spiagent_motor_configure() failed, error=" +
          error.ToString());

      spiagent_motor_put((uint) pwmpin, (uint) dirpin, (float) velocity,
        out error);

      if (error != 0)
        throw new System.Exception("spiagent_motor_put() failed, error=" +
          error.ToString());

      this.mydirpin = (uint) dirpin;
      this.mypwmpin = (uint) pwmpin;
      this.myvelocity = (float) velocity;
    }

    /// <summary>
    /// Read/Write normalized motor velocity (-1.0 to +1.0) property.
    /// </summary>
    public double velocity
    {
      get
      {
        return this.myvelocity;
      }

      set
      {
        if ((value < -1.0) || (value > +1.0))
          throw new System.Exception("motor velocity value is out of range.");

        int error;

        spiagent_motor_put(this.mypwmpin, this.mydirpin, (float)value,
          out error);

        if (error != 0)
          throw new System.Exception("spiagent_motor_put() failed, error=" +
            error.ToString());

        this.myvelocity = (float) value;
      }
    }
  }
}
