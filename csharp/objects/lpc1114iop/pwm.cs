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

namespace IO.Objects.LPC1114IOP.PWM
{
  /// <summary>
  /// LPC1114 I/O Processor GPIO pin identifiers.
  /// </summary>
  public enum pin_id_t
  {
    /// <summary>
    /// GPIO1 <i>aka</i> LPC1114 pin PIO1_1
    /// </summary>
    PWM1 = IO.Objects.LPC1114IOP.GPIO.pin_id_t.GPIO1,
    /// <summary>
    /// GPIO2 <i>aka</i> LPC1114 pin PIO1_2
    /// </summary>
    PWM2 = IO.Objects.LPC1114IOP.GPIO.pin_id_t.GPIO2,
    /// <summary>
    /// GPIO3 <i>aka</i> LPC1114 pin PIO1_3
    /// </summary>
    PWM3 = IO.Objects.LPC1114IOP.GPIO.pin_id_t.GPIO3,
    /// <summary>
    /// GPIO7 <i>aka</i> LPC1114 pin PIO1_9
    /// </summary>
    PWM4 = IO.Objects.LPC1114IOP.GPIO.pin_id_t.GPIO7,
  }

  /// <summary>
  /// This class encapsulates LPC1114 I/O Processor PWM outputs.
  /// </summary>
  public class Output : IO.Interfaces.PWM.Output
  {
    private static int pwmfreq; // All PWM outputs share the same frequency!
    private uint mypin;
    private float myduty;

    /// <summary>
    /// PWM output object constructor.
    /// </summary>
    /// <param name="pin">PWM output pin number.</param>
    /// <param name="duty">PWM output duty cycle percentage (0.0 to 100.0).</param>
    /// <remarks>
    /// <para>
    /// All PWM outputs share the same pulse frequency.
    /// </para>
    /// <para>
    /// You <b>must</b> set the common PWM output pulse frequency (<i>i.e.</i>
    /// <c>IO.Objects.LPC1114IOP.PWM.Output.frequency = 1000;</c>) <b>before</b>
    /// configuring a PWM output.
    /// </para>
    /// </remarks>
    public Output(pin_id_t pin, double duty = 0.0)
    {
      int error;

      spiagent_pwm_configure((uint) pin, out error);

      if (error != 0)
        throw new System.Exception("spiagent_pwm_configure() failed, error=" +
          error.ToString());

      this.mypin = (uint) pin;
      this.dutycycle = duty;
    }

    /// <summary>
    /// Read/Write PWM duty cycle percentage (0.0 to 100.0) property.
    /// </summary>
    public double dutycycle
    {
      get
      {
        return this.myduty;
      }

      set
      {
        int error;

        spiagent_pwm_put(this.mypin, (float) value, out error);

        if (error != 0)
          throw new System.Exception("spiagent_pwm_put() failed, error=" +
            error.ToString());

        this.myduty = (float) value;
      }
    }

    /// <summary>
    /// Read/Write PWM pulse output frequency property.
    /// </summary>
    /// <remarks>
    /// All PWM outputs share the same pulse frequency.
    /// </remarks>
    public static int frequency
    {
      get
      {
        return pwmfreq;
      }

      set
      {
        if ((value < 50) || (value > 50000))
          throw new System.Exception("PWM pulse frequency is out of range!");

        int error;

        spiagent_pwm_set_frequency((uint) value, out error);

        if (error != 0)
          throw new System.Exception("spiagent_pwm_set_frequency() failed, error=" +
            error.ToString());

        pwmfreq = value;
      }
    }
  }
}
