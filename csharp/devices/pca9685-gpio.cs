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

namespace IO.Devices.PCA9685.GPIO
{
  /// <summary>
  /// Encapsulates PCA9685 GPIO outputs.
  /// </summary>
  public class Pin : IO.Interfaces.GPIO.Pin
  {
    private readonly static byte[] ON = { 0x00, 0x10, 0x00, 0x00 };
    private readonly static byte[] OFF = { 0x00, 0x00, 0x00, 0x10 };
    private readonly Device dev;
    private readonly byte channel;
    private byte[] data;

    private bool Compare(byte[] x, byte[] y)
    {
      if (x[0] != y[0]) return false;
      if (x[1] != y[1]) return false;
      if (x[2] != y[2]) return false;
      if (x[3] != y[3]) return false;
      return true;
    }

    /// <summary>
    /// Constructor for a single GPIO output pin.
    /// </summary>
    /// <param name="dev">PCA9685 device object.</param>
    /// <param name="channel">Output channel number.</param>
    /// <param name="state">Initial GPIO output state.</param>
    public Pin(Device dev, int channel, bool state = false)
    {
      // Validate parameters

      if ((channel < Device.MIN_CHANNEL) || (channel > Device.MAX_CHANNEL))
        throw new System.Exception("Invalid channel number");

      this.dev = dev;
      this.channel = System.Convert.ToByte(channel);
      this.data = new byte[4];
      this.state = state;
    }

    /// <summary>
    /// Read/Write GPIO output state property.
    /// </summary>
    public bool state
    {
      get
      {
        dev.ReadChannel(channel, ref data);

        if (Compare(data, ON))
          return true;
        else if (Compare(data, OFF))
          return false;
        else
          throw new System.Exception("Unexpected channel data");
      }

      set
      {
        dev.WriteChannel(channel, value ? ON : OFF);
      }
    }
  }
}
