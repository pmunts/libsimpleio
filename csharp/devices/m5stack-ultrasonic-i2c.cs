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

using System.Runtime.CompilerServices;

namespace IO.Devices.M5Stack_Ultrasonic_I2C
{
  /// <summary>
  /// Encapsulates the M5 Stack Ultrasonic-I2C SONAR distance sensor module.
  /// </summary>
  public class Sensor : IO.Interfaces.Distance.Sensor
  {
    private readonly IO.Interfaces.I2C.Device dev;
    private readonly byte[] cmdbuf = { 1 };
    private byte[] respbuf = { 0, 0, 0 };

    /// <summary>
    /// Constructor for an M5 Stack Ultrasonic-I2C SONAR distance sensor object.
    /// </summary>
    /// <param name="bus">I<sup>2</sup>C bus controller.</param>
    /// <param name="addr">I<sup>2</sup>C slave address.</param>
    public Sensor(IO.Interfaces.I2C.Bus bus, int addr = 0x57)
    {
      dev = new IO.Interfaces.I2C.Device(bus, addr);
    }

    /// <summary>
    /// Read-only property returning the distance in meters.
    /// </summary>
    public double meters
    {
      get
      {
        dev.Transaction(cmdbuf, cmdbuf.Length, respbuf, respbuf.Length, 5000);
        float rawdist = respbuf[0] * 65536 + respbuf[1] * 256 + respbuf[2];
        return rawdist / 1.0E6;
      }
    }

    /// <summary>
    /// Read-only property returning the distance in centimeters.
    /// </summary>
    public double centimeters
    {
      get
      {
        return IO.Interfaces.Distance.Conversions.MetersToCentimeters(meters);
      }
    }

    /// <summary>
    /// Read-only property returning the distance in inches.
    /// </summary>
    public double inches
    {
      get
      {
        return IO.Interfaces.Distance.Conversions.MetersToInches(meters);
      }
    }
  }
}
