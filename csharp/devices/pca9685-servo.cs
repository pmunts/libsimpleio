// Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Devices.PCA9685.Servo
{
  /// <summary>
  /// Encapsulates PCA9685 servo outputs.
  /// </summary>
  public class Output : IO.Interfaces.Servo.Output
  {
    private readonly Device dev;
    private readonly byte channel;
    private readonly double freq;
    private byte[] data;

    /// <summary>
    /// Constructor for a single servo output.
    /// </summary>
    /// <param name="dev">PCA9685 device object.</param>
    /// <param name="channel">Output channel number.</param>
    /// <param name="position">Initial servo position.</param>
    public Output(Device dev, int channel,
      double position = IO.Interfaces.Servo.Positions.Neutral)
    {
      // Validate parameters

      if ((channel < Device.MIN_CHANNEL) || (channel > Device.MAX_CHANNEL))
        throw new System.Exception("Invalid channel number");

      if ((position < IO.Interfaces.Servo.Positions.Minimum) ||
          (position > IO.Interfaces.Servo.Positions.Maximum))
        throw new System.Exception("Invalid servo position");

      if ((dev.Frequency < 50) || (dev.Frequency > 400))
        throw new System.Exception("Invalid PWM pulse frequency for servos");

      this.dev = dev;
      this.channel = System.Convert.ToByte(channel);
      this.freq = this.dev.Frequency;
      this.data = new byte[4];
      this.position = position;
    }

    /// <summary>
    /// Write-only property for setting the normalized servo position.
    /// Allowed values are -0.0 to+1.0.
    /// </summary>
    public double position
    {
      set
      {
        // Validate parameters

        if ((value < IO.Interfaces.Servo.Positions.Minimum) ||
            (value > IO.Interfaces.Servo.Positions.Maximum))
          throw new System.Exception("Invalid servo position");

        System.UInt16 offtime = System.Convert.ToUInt16((2.0475*value + 6.1425)*freq);

        data[0] = 0;
        data[1] = 0;
        data[2] = System.Convert.ToByte(offtime % 256);
        data[3] = System.Convert.ToByte(offtime / 256);

        dev.WriteChannel(channel, data);
      }
    }
  }
}
