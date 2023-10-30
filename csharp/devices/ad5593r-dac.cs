// AD5593R Analog/Digital I/O Device DAC Output Services

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

namespace IO.Devices.AD5593R.DAC
{
    /// <summary>
    /// Encapsulates AD5593R DAC outputs.
    /// </summary>
    public class Sample : IO.Interfaces.DAC.Sample
    {
        private readonly IO.Devices.AD5593R.Device dev;
        private readonly int chan;

        /// <summary>
        /// Create an AD5593R DAC output.
        /// </summary>
        /// <param name="dev">AD5593R device object.</param>
        /// <param name="channel">AD5593R I/O channel number (0 to 7).</param>
        /// <param name="sample">Initial DAC output sample.</param>
        public Sample(IO.Devices.AD5593R.Device dev, int channel, int sample = 0)
        {
            dev.ConfigureChannel(channel, IO.Devices.AD5593R.PinMode.DAC_Output);
            this.dev = dev;
            this.chan = channel;
            this.sample = sample;
        }

        /// <summary>
        /// Write-only property for writing an integer analog sample to a DAC
        /// output.
        /// </summary>
        public int sample
        {
            set
            {
                dev.Write_DAC(chan, value);
            }
        }

        /// <summary>
        /// Read-only property returning the number of bits of resolution.
        /// </summary>
        public int resolution
        {
            get
            {
                return IO.Devices.AD5593R.Device.DAC_Resolution;
            }
        }
    }
}