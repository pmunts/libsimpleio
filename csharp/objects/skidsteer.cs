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
    private double Sensitivity = 0.2;
    private double GoVelocity  = IO.Interfaces.Motor.Velocities.Stop;

    /// <summary>
    /// Skid Steering 2WD vehicle object constructor.
    /// </summary>
    /// <param name="left">Left motor driver output object instance.
    /// instance.</param>
    /// <param name="right">Right motor driver output object instance.
    /// instance.</param>
    /// <param name="sensitivity">Steering sensitivity scale factor.
    /// Allowed values range from 0.0 (exclusive) to 1.0 (inclusive).</param>
    public Vehicle2WD(IO.Interfaces.Motor.Output left,
      IO.Interfaces.Motor.Output right, double sensitivity = 0.2)
    {
      if ((sensitivity <= 0.0) || (sensitivity > 1.0))
        throw new System.Exception("Vehicle2WD() sensitivity is out of range.");

      LeftMotor   = left;
      RightMotor  = right;
      Sensitivity = sensitivity;
      GoVelocity  = IO.Interfaces.Motor.Velocities.Stop;
    }

    /// <summary>
    /// Initiate forward or reverse motion.
    /// </summary>
    /// <param name="newvelocity">New motor velocity.  Value values range
    /// from -1.0 for full speed astern to +1.0 for full speed ahead.</param>
    /// <param name="milliseconds">Duration in milliseconds</param>
    public void Go(double newvelocity, uint milliseconds = 0)
    {
      if (System.Math.Abs(newvelocity) > IO.Interfaces.Motor.Velocities.Maximum)
        throw new System.Exception("Go() velocity is out of range");

      LeftMotor.velocity  = newvelocity;
      RightMotor.velocity = newvelocity;
      GoVelocity          = newvelocity;
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
    public void Turn(double steering, uint milliseconds)
    {
      if ((steering < -1.0) || (steering > +1.0))
        throw new System.Exception("Turn() steering is out of range");
      
      if (steering == 0.0)
        // No turn, so just keep moving
        return;
      else if (GoVelocity > IO.Interfaces.Motor.Velocities.Stop)
      {
        // Moving forward
        LeftMotor.velocity  = GoVelocity*(1.0 - Sensitivity) +
          steering*Sensitivity;

        RightMotor.velocity = GoVelocity*(1.0 - Sensitivity) -
          steering*Sensitivity;
      }
      else if (GoVelocity < IO.Interfaces.Motor.Velocities.Stop)
      {
        // Moving reverse
        LeftMotor.velocity  = GoVelocity*(1.0 - Sensitivity) -
          steering*Sensitivity;

        RightMotor.velocity = GoVelocity*(1.0 - Sensitivity) +
          steering*Sensitivity;
      }
      else
      {
        // Stopped, so just spin in place
        LeftMotor.velocity  = steering;
        RightMotor.velocity = -steering;
      }

      System.Threading.Thread.Sleep((int)milliseconds);

      // Resume forward or reverse motion
      Go(GoVelocity);
    }
  }
}
