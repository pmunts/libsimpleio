// AD5593R Analog/Digital I/O Device ADC Input Services

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

namespace IO.Devices.AD5593R.ADC
{
    /// <summary>
    /// Encapsulates AD5593R ADC inputs.
    /// </summary>
    public class Sample : IO.Interfaces.ADC.Sample
    {
        private readonly IO.Devices.AD5593R.Device dev;
        private readonly int chan;

        /// <summary>
        /// Create an AD5593R ADC input.
        /// </summary>
        /// <param name="dev">AD5593R device object.</param>
        /// <param name="channel">AD5593R I/O channel number (0 to 7).</param>
        public Sample(IO.Devices.AD5593R.Device dev, int channel)
        {
            dev.ConfigureChannel(channel, IO.Devices.AD5593R.PinMode.ADC_Input);
            this.dev = dev;
            this.chan = channel;
        }

        /// <summary>
        /// Read-only property returning an integer analog sample value.
        /// </summary>
        public int sample
        {
            get
            {
                return dev.Read_ADC(chan);
            }
        }

        /// <summary>
        /// Read-only property returning the number of bits of resolution.
        /// </summary>
        public int resolution
        {
            get
            {
                return IO.Devices.AD5593R.Device.ADC_Resolution;
            }
        }
    }
}