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

using IO.Objects.SimpleIO.Device;
using System.Collections.Generic;

namespace IO.Objects.SimpleIO.Platforms
{
  /// <summary>
  /// This class provides motor driver services for the MUNTS-0021 River
  /// Tech Motor Driver board.
  /// </summary>
  public static class MUNTS_0021
  {
    private static readonly List<Designator> DirPins =
        new List<Designator>(new[] { RaspberryPi.GPIO19, RaspberryPi.GPIO6 });

    private static readonly List<Designator> PWMOutputs =
      new List<Designator>(new[] { RaspberryPi.PWM1, RaspberryPi.PWM0 });

    /// <summary>
    /// Motor driver output channel A selector.
    /// </summary>
    public const uint MotorA = 0;

    /// <summary>
    /// Motor driver output channel B selector.
    /// </summary>
    public const uint MotorB = 1;

    /// <summary>
    /// MUNTS-0021 Motor driver output factory function.
    /// </summary>
    /// <param name="motor">Motor driver output selector.</param>
    /// <param name="frequency">PWM output pulse frequency.</param>
    /// <param name="velocity">Initial motor speed.</param>
    /// <returns>Motor driver output object instance.</returns>
    public static IO.Interfaces.Motor.Output MotorFactory(uint motor,
        int frequency = 1000, double velocity = 0.0)
    {
      if (motor > MotorB) 
        throw new System.Exception("Invalid motor driver output selector.");

      return new IO.Objects.Motor.PWM.Output(
          new IO.Objects.SimpleIO.GPIO.Pin(DirPins[(int)motor],
              IO.Interfaces.GPIO.Direction.Output),
          new IO.Objects.SimpleIO.PWM.Output(PWMOutputs[(int)motor],
              frequency),
          velocity);
    }
  }
}
