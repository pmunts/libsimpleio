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

namespace IO.Objects.LPC1114IOP.Servo
{
  /// <summary>
  /// LPC1114 I/O Processor GPIO pin identifiers.
  /// </summary>
  public enum pin_id_t
  {
    /// <summary>
    /// PWM1 <i>aka</i> GPIO1 <i>aka</i> LPC1114 pin PIO1_1
    /// </summary>
    Servo1 = IO.Objects.LPC1114IOP.PWM.pin_id_t.PWM1,
    /// <summary>
    /// PWM2 <i>aka</i> GPIO2 <i>aka</i> LPC1114 pin PIO1_2
    /// </summary>
    Servo2 = IO.Objects.LPC1114IOP.PWM.pin_id_t.PWM2,
    /// <summary>
    /// PWM3 <i>aka</i> GPIO3 <i>aka</i> LPC1114 pin PIO1_3
    /// </summary>
    Servo3 = IO.Objects.LPC1114IOP.PWM.pin_id_t.PWM3,
    /// <summary>
    /// PWM4 <i>aka</i> GPIO7 <i>aka</i> LPC1114 pin PIO1_9
    /// </summary>
    Servo4 = IO.Objects.LPC1114IOP.PWM.pin_id_t.PWM4,
  }

  /// <summary>
  /// This class encapsulates LPC1114 I/O Processor servo outputs.
  /// </summary>
  public class Output : IO.Interfaces.Servo.Output
  {
    private uint mypin;
    private double myposition;

    /// <summary>
    /// PWM output object constructor.
    /// </summary>
    /// <param name="pin">Servo output pin number.</param>
    /// <param name="position">Servo normalized position (-1.0 to +1.0).</param>
    /// <remarks>
    /// All PWM outputs share the same pulse frequency.<br/><br/>
    /// You <b>must</b> set the common PWM output pulse frequency to a value
    /// from 50 to 400 Hz (<i>i.e.</i>
    /// <c>IO.Objects.LPC1114IOP.PWM.Output.frequency = 50;</c>) <b>before</b>
    /// configuring a servo output.
    /// </remarks>
    public Output(pin_id_t pin, double position = 0.0)
    {
      if ((IO.Objects.LPC1114IOP.PWM.Output.frequency < 50) ||
          (IO.Objects.LPC1114IOP.PWM.Output.frequency > 400))
        throw new System.Exception("PWM pulse frequency is out of range for servos.");

      if ((position < -1.0) || (position > +1.0))
        throw new System.Exception("Servo position value is out of range.");

      int error;

      spiagent_servo_configure((uint) pin, out error);

      if (error != 0)
        throw new System.Exception("spiagent_servo_configure() failed, error=" +
          error.ToString());

      spiagent_servo_put((uint) pin, (float) position, out error);

      if (error != 0)
        throw new System.Exception("spiagent_servo_put() failed, error=" +
          error.ToString());

      this.mypin = (uint) pin;
      this.myposition = (float) position;
    }

    /// <summary>
    /// Read/Write normalize servo position (-1.0 to +1.0) property.
    /// </summary>
    public double position
    {
      get
      {
        return this.myposition;
      }

      set
      {
        if ((value < -1.0) || (value > +1.0))
          throw new System.Exception("Servo position value is out of range.");

        int error;

        spiagent_servo_put(this.mypin, (float)value, out error);

        if (error != 0)
          throw new System.Exception("spiagent_servo_put() failed, error=" +
            error.ToString());

        this.myposition = (float) value;
      }
    }
  }
}
