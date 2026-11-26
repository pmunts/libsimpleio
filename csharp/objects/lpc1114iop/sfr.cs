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

using System.Data;
using static IO.Bindings.libspiagent;

namespace IO.Objects.LPC1114IOP.SFR
{
  /// <summary>
  /// This static class encapsulates reading and writing LPC1114 microcontroller
  /// special function registers.
  /// </summary>
  /// <remarks>
  /// Use only with great care!
  /// </remarks>
  public static class Register
  {
    /// <summary>
    /// Devie ID Register address.
    /// </summary>
    public const uint LPC1114_DEVICEID = 0x400483F4;

    /// <summary>
    /// UART0 Scratch Pad Register address.
    /// </summary>
    public const uint LPC1114_U0SCR = 0x4000801C;

    /// <summary>
    /// Read from an LPC1114 Special Function Register
    /// </summary>
    /// <param name="address">SFR address.</param>
    /// <returns>SFR data.</returns>
    public static uint Get(uint address)
    {
      uint data;
      int error;

      spiagent_sfr_get(address, out data, out error);

      if (error != 0)
        throw new System.Exception("spiagent_sfr_get() failed, error=" +
          error.ToString());

      return data;
    }

    /// <summary>
    /// Write to an LPC1114 Special Function Register
    /// </summary>
    /// <param name="address">SFR address.</param>
    /// <param name="data">SFR data.</param>
    /// <exception cref="System.Exception"></exception>
    public static void Put(uint address, uint data)
    {
      int error;

      spiagent_sfr_put(address, data, out error);

      if (error != 0)
        throw new System.Exception("spiagent_sfr_put() failed, error=" +
          error.ToString());
    }
  }
}
