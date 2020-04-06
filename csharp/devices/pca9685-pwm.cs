// Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

namespace IO.Devices.PCA9685.PWM
{
  /// <summary>
  /// Encapsulates PCA9685 PWM outputs.
  /// </summary>
  public class Output : IO.Interfaces.PWM.Output
  {
    private readonly Device dev;
    private readonly byte channel;
    private byte[] data;

    /// <summary>
    /// Constructor for a single PWM output.
    /// </summary>
    /// <param name="dev">PCA9685 device object.</param>
    /// <param name="channel">Output channel number.</param>
    /// <param name="dutycycle">Initial PWM output duty cycle.</param>
    public Output(Device dev, int channel,
      double dutycycle = IO.Interfaces.PWM.DutyCycles.Minimum)
    {
      // Validate parameters

      if ((channel < Device.MIN_CHANNEL) || (channel > Device.MAX_CHANNEL))
        throw new System.Exception("Invalid channel number");

      if ((dutycycle < IO.Interfaces.PWM.DutyCycles.Minimum) ||
          (dutycycle > IO.Interfaces.PWM.DutyCycles.Maximum))
        throw new System.Exception("Invalid duty cycle");

      this.dev = dev;
      this.channel = System.Convert.ToByte(channel);
      this.data = new byte[4];
      this.dutycycle = dutycycle;
    }

    /// <summary>
    /// Write-only property for setting the PWM output duty cycle.
    /// Allowed values are 0.0 to 100.0 percent.
    /// </summary>
    public double dutycycle
    {
      set
      {
        // Validate parameters

        if ((value < IO.Interfaces.PWM.DutyCycles.Minimum) ||
            (value > IO.Interfaces.PWM.DutyCycles.Maximum))
          throw new System.Exception("Invalid duty cycle");

        System.UInt16 offtime = System.Convert.ToUInt16(value*40.95);

        data[0] = 0;
        data[1] = 0;
        data[2] = System.Convert.ToByte(offtime % 256);
        data[3] = System.Convert.ToByte(offtime / 256);

        dev.WriteChannel(channel, data);
      }
    }
  }
}
