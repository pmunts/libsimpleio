// Digilent Pmod HYGRO Temperature and Humdity Sensor (HDC1080) Services.

// Copyright (C)2020-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Devices.Pmod.HYGRO
{
    /// <summary>
    /// Encapsulate the Digilent Pmod HYGRO Temperature and Humidity
    /// Sensor (HDC1080).
    /// </summary>
    public class Device : IO.Devices.HDC1080.Device
    {
        /// <summary>
        /// Constructor for a Digilent Pmod HYGRO Temperature and
        /// Humidity Sensor (HDC1080).
        /// </summary>
        /// <param name="bus">I<sup>2</sup> bus object.</param>
        public Device(IO.Interfaces.I2C.Bus bus) : base(bus)
        {
        }
    }
}
