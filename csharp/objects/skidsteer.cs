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

namespace IO.Objects.SkidSteer
{
  /// <summary>
  /// Skid Steering 2WD vehicle class.
  /// </summary>
  public class Vehicle2WD
  {
    private readonly IO.Interfaces.Motor.Output LeftMotor;
    private readonly IO.Interfaces.Motor.Output RightMotor;
    private const double Sensitivity = 0.1;
    private double GoVelocity = IO.Interfaces.Motor.Velocities.Stop;

    /// <summary>
    /// Skid Steering 2WD vehicle object constructor.
    /// </summary>
    /// <param name="left">Left motor driver output object instance.
    /// instance.</param>
    /// <param name="right">Right motor driver output object instance.
    /// instance.</param>
    public Vehicle2WD(IO.Interfaces.Motor.Output left,
      IO.Interfaces.Motor.Output right)
    {
      LeftMotor  = left;
      RightMotor = right;
    }

    /// <summary>
    /// Initiate forward or reverse motion.
    /// </summary>
    /// <param name="newvelocity">New motor velocity.  Value values range
    /// from -1.0 for full speed astern to +1.0 for full speed ahead.
    /// </param>
    /// <exception cref="System.Exception"></exception>
    public void Go(double newvelocity)
    {
      if (System.Math.Abs(newvelocity) > IO.Interfaces.Motor.Velocities.Maximum)
        throw new System.Exception("Go() velocity is out of range");

      LeftMotor.velocity  = newvelocity;
      RightMotor.velocity = newvelocity;
      GoVelocity          = newvelocity;
    }

    /// <summary>
    /// Initiate forward or reverse motion.
    /// </summary>
    /// <param name="newvelocity">New motor velocity.  Value values range
    /// from -1.0 for full speed astern to +1.0 for full speed ahead.
    /// </param>
    /// <param name="milliseconds">Duration in milliseconds</param>
    /// <exception cref="System.Exception"></exception>
    public void Go(double newvelocity, uint milliseconds)
    {
      Go(newvelocity);
      System.Threading.Thread.Sleep((int)milliseconds);
    }

    /// <summary>
    /// Stop motion.
    /// </summary>
    public void Stop()
    {
      Go(IO.Interfaces.Motor.Velocities.Stop);
    }

    /// <summary>
    /// Initiate a turn.
    /// </summary>
    /// <param name="steering">Normalized conceptual steering wheel position.
    /// Allowed values from -1.0 (steering wheel fully counterclockwise) to
    /// +1.0 (steering wheel fully clockwise).</param>
    /// <param name="milliseconds">Duration in milliseconds.</param>
    /// <exception cref="System.Exception"></exception>
    public void Turn(double steering, uint milliseconds)
    {
      // Validate arguments -- Allowed steering steering values range from
      // -1.0 (hard left) to +1.0 (hard right).

      if (steering < -1.0) throw new System.Exception("Turn() steering is out of range");
      if (steering == 0.0) return;
      if (steering > 1.0) throw new System.Exception("Turn() steering is out of range");

      var SaveVelocity = GoVelocity;

      if ((GoVelocity == IO.Interfaces.Motor.Velocities.Stop) && (steering > 0.0))
      {
        // Spin in place clockwise
        LeftMotor.velocity  = steering;
        RightMotor.velocity = -steering;
      }
      else if ((GoVelocity == IO.Interfaces.Motor.Velocities.Stop) && (steering < 0.0))
      {
        // Spin in place counterclockwise
        LeftMotor.velocity  = steering;
        RightMotor.velocity = -steering;
      }
      else if (GoVelocity > IO.Interfaces.Motor.Velocities.Stop)
      {
        // Moving forward
        LeftMotor.velocity  =
          System.Math.Max(IO.Interfaces.Motor.Velocities.Minimum,
            SaveVelocity + steering * Sensitivity);

        RightMotor.velocity =
          System.Math.Min(IO.Interfaces.Motor.Velocities.Maximum,
            SaveVelocity - steering * Sensitivity);
      }
      else if (GoVelocity < IO.Interfaces.Motor.Velocities.Stop)
      {
        // Moving reverse
        LeftMotor.velocity  =
          System.Math.Max(IO.Interfaces.Motor.Velocities.Minimum,
            SaveVelocity - steering * Sensitivity);

        RightMotor.velocity =
          System.Math.Min(IO.Interfaces.Motor.Velocities.Maximum,
            SaveVelocity + steering * Sensitivity);
      }

      System.Threading.Thread.Sleep((int)milliseconds);

      Go(SaveVelocity);
    }
  }

  /// <summary>
  /// Skid Steering 4WD vehicle class.
  /// </summary>
  public class Vehicle4WD
  {
    private readonly IO.Interfaces.Motor.Output LeftFrontMotor;
    private readonly IO.Interfaces.Motor.Output LeftRearMotor;
    private readonly IO.Interfaces.Motor.Output RightFrontMotor;
    private readonly IO.Interfaces.Motor.Output RightRearMotor;
    private const double Sensitivity = 0.1;
    private double GoVelocity = IO.Interfaces.Motor.Velocities.Stop;

    /// <summary>
    /// Skid Steering vehicle object constructor.
    /// </summary>
    /// <param name="leftfront">Left front motor driver output
    /// instance.</param>
    /// <param name="leftrear">Left rear motor driver output
    /// instance.</param>
    /// <param name="rightfront">Right front motor driver output
    /// instance.</param>
    /// <param name="rightrear">Right rear motor driver output
    /// instance.</param>
    public Vehicle4WD(IO.Interfaces.Motor.Output leftfront,
      IO.Interfaces.Motor.Output leftrear,
      IO.Interfaces.Motor.Output rightfront,
      IO.Interfaces.Motor.Output rightrear)
    {
      LeftFrontMotor  = leftfront;
      LeftRearMotor   = leftfront;
      RightFrontMotor = rightfront;
      RightRearMotor  = rightrear;
    }

    /// <summary>
    /// Initiate forward or reverse motion.
    /// </summary>
    /// <param name="newvelocity">New motor velocity.  Value values range
    /// from -1.0 for full speed astern to +1.0 for full speed ahead.
    /// </param>
    /// <exception cref="System.Exception"></exception>
    public void Go(double newvelocity)
    {
      if (System.Math.Abs(newvelocity) > IO.Interfaces.Motor.Velocities.Maximum)
        throw new System.Exception("Go() velocity is out of range");

      LeftFrontMotor.velocity  = newvelocity;
      LeftRearMotor.velocity   = newvelocity;
      RightFrontMotor.velocity = newvelocity;
      RightRearMotor.velocity  = newvelocity;
      GoVelocity = newvelocity;
    }

    /// <summary>
    /// Initiate forward or reverse motion.
    /// </summary>
    /// <param name="newvelocity">New motor velocity.  Value values range
    /// from -1.0 for full speed astern to +1.0 for full speed ahead.
    /// </param>
    /// <param name="milliseconds">Duration in milliseconds</param>
    /// <exception cref="System.Exception"></exception>
    public void Go(double newvelocity, uint milliseconds)
    {
      Go(newvelocity);
      System.Threading.Thread.Sleep((int)milliseconds);
    }

    /// <summary>
    /// Stop motion.
    /// </summary>
    public void Stop()
    {
      Go(IO.Interfaces.Motor.Velocities.Stop);
    }

    /// <summary>
    /// Initiate a turn.
    /// </summary>
    /// <param name="steering">Normalized conceptual steering wheel position.
    /// Allowed values from -1.0 (steering wheel fully counterclockwise) to
    /// +1.0 (steering wheel fully clockwise).</param>
    /// <param name="milliseconds">Duration in milliseconds.</param>
    /// <exception cref="System.Exception"></exception>
    public void Turn(double steering, uint milliseconds)
    {
      // Validate arguments -- Allowed steering steering values range from
      // -1.0 (hard left) to +1.0 (hard right).

      if (steering < -1.0) throw new System.Exception("Turn() steering is out of range");
      if (steering == 0.0) return;
      if (steering > 1.0) throw new System.Exception("Turn() steering is out of range");

      var SaveVelocity = GoVelocity;

      if ((GoVelocity == IO.Interfaces.Motor.Velocities.Stop) && (steering > 0.0))
      {
        // Spin in place clockwise
        LeftFrontMotor.velocity  = steering;
        LeftRearMotor.velocity   = steering;
        RightFrontMotor.velocity = -steering;
        RightRearMotor.velocity  = -steering;
      }
      else if ((GoVelocity == IO.Interfaces.Motor.Velocities.Stop) && (steering < 0.0))
      {
        // Spin in place counterclockwise
        LeftFrontMotor.velocity  = steering;
        LeftRearMotor.velocity   = steering;
        RightFrontMotor.velocity = -steering;
        RightRearMotor.velocity  = -steering;
      }
      else if (GoVelocity > IO.Interfaces.Motor.Velocities.Stop)
      {
        // Moving forward into turn
        LeftFrontMotor.velocity  =
          System.Math.Max(IO.Interfaces.Motor.Velocities.Minimum,
            SaveVelocity + steering * Sensitivity);

        LeftRearMotor.velocity   =
          System.Math.Max(IO.Interfaces.Motor.Velocities.Minimum,
            SaveVelocity + steering * Sensitivity);

        RightFrontMotor.velocity =
          System.Math.Min(IO.Interfaces.Motor.Velocities.Maximum,
            SaveVelocity - steering * Sensitivity);

        RightRearMotor.velocity  =
          System.Math.Min(IO.Interfaces.Motor.Velocities.Maximum,
            SaveVelocity - steering * Sensitivity);
      }
      else if (GoVelocity < IO.Interfaces.Motor.Velocities.Stop)
      {
        // Moving reverse into turn
        LeftFrontMotor.velocity  =
          System.Math.Max(IO.Interfaces.Motor.Velocities.Minimum,
            SaveVelocity - steering * Sensitivity);

        LeftRearMotor.velocity   =
          System.Math.Max(IO.Interfaces.Motor.Velocities.Minimum,
            SaveVelocity - steering * Sensitivity);

        RightFrontMotor.velocity =
          System.Math.Min(IO.Interfaces.Motor.Velocities.Maximum,
            SaveVelocity + steering * Sensitivity);

        RightRearMotor.velocity  =
          System.Math.Min(IO.Interfaces.Motor.Velocities.Maximum,
            SaveVelocity + steering * Sensitivity);
      }

      System.Threading.Thread.Sleep((int)milliseconds);

      Go(SaveVelocity);
    }
  }
}