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

namespace IO.Objects.LPC1114IOP.LEGORC
{
  /// <summary>
  /// LEGO® Power Functions Remote Control motor ID values.
  /// </summary>
  public enum legorc_motor_id_t
  {
    ALLSTOP,
    MOTORA,
    MOTORB,
    COMBODIRECT,
    COMBOPWM,
  }

  /// <summary>
  /// This class encapsulates LEGO® Power Functions Remote Control motor
  /// services.
  /// </summary>
  public class Output : IO.Interfaces.Motor.Output
  {
    private readonly HashSet<pin_id_t> ValidPins = new HashSet<pin_id_t>
    {
      pin_id_t.GPIO0,
      pin_id_t.GPIO1,
      pin_id_t.GPIO2,
      pin_id_t.GPIO3,
      pin_id_t.GPIO4,
      pin_id_t.GPIO5,
      pin_id_t.GPIO6,
      pin_id_t.GPIO7
    };

    private readonly HashSet<int> ValidChannels = new HashSet<int>
    {
      1,
      2,
      3,
      4
    };

    private readonly HashSet<legorc_motor_id_t> ValidMotors = 
      new HashSet<legorc_motor_id_t>
    {
      legorc_motor_id_t.MOTORA,
      legorc_motor_id_t.MOTORB
    };

    private uint mypin;
    private uint mychannel;
    private uint mymotor;
    private double myvelocity;

  /// <summary>
  /// Constructor for a LEGO® Power Functions DC motor.
  /// </summary>
  /// <param name="pin">GPIO pin to drive infrared emitter.</param>
  /// <param name="channel">Channel number.</param>
  /// <param name="motor">Motor ID (1 for Motor A, 2 for Motor B).</param>
  /// <param name="velocity">Initial normalized motor velocity (-1.0 to
  /// +1.0).</param>
  public Output(IO.Objects.LPC1114IOP.GPIO.pin_id_t pin, int channel,
      legorc_motor_id_t motor, double velocity)
    {
      if (!ValidPins.Contains(pin))
        throw new System.Exception("GPIO pin ID is out of range.");

      if (!ValidChannels.Contains(channel))
        throw new System.Exception("Channel number is out of range.");

      if (!ValidMotors.Contains(motor))
        throw new System.Exception("Motor ID argument is out of range.");

      if ((velocity < -1.0) || (velocity > +1.0))
        throw new System.Exception("Motor velocity value is out of range.");

      int error;

      IO.Bindings.libspiagent.spiagent_gpio_configure((uint) pin, 1, 0,
        out error);

      if (error != 0)
        throw new System.Exception("spiagent_gpio_configure() failed, error=" +
          error.ToString());

      this.mypin = (uint) pin;
      this.mychannel = (uint) channel;
      this.mymotor = (uint) motor;

      this.velocity = velocity;
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
          throw new System.Exception("Motor velocity value is out of range.");

        int speed;

        for (speed = 0; speed < 8; speed++)
          if (System.Math.Abs(value) <= (speed + 1) * 0.125)
            break;

        int error;

        IO.Bindings.libspiagent.spiagent_legorc_put(this.mypin, this.mychannel,
          this.mymotor, (uint) (value < 0 ? 0 : 1), (uint ) speed, out error);

        if (error != 0)
          throw new System.Exception("spiagent_legorc_put() failed, error=" +
            error.ToString());

        this.myvelocity = value;
      }
    }
  }
}