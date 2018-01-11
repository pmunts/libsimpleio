// PWM output services using libsimpleio

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

using libsimpleio.Exceptions;

namespace libsimpleio.ADC
{
    /// <summary>
    /// Encapsulates Linux Industrial I/O Subsystem ADC inputs usingi
    /// <c>libsimpleio</c>.
    /// </summary>
    public class Sample: IO.Interfaces.ADC.Sample
    {
        private int myfd;

        /// <summary>
        /// Retrieve the subsystem name string for a Linux Industrial
        /// I/O Subsystem ADC device.
        /// </summary>
        /// <param name="chip">ADC chip number.</param>
        /// <returns>Subsystem name.</returns>
        public static string name(int chip)
        {
            System.Text.StringBuilder name = new System.Text.StringBuilder(256);
            int error;

            if (chip < 0)
            {
                throw new Exception("Invalid chip number");
            }

            libsimpleio.libADC.ADC_get_name(chip, name, name.Length, out error);

            return name.ToString();
        }

        /// <summary>
        /// Constructor for a single ADC input.
        /// </summary>
        /// <param name="chip">ADC chip number.</param>
        /// <param name="channel">ADC channel number.</param>
        public Sample(int chip, int channel)
        {
            int error;

            if (chip < 0)
            {
                throw new Exception("Invalid chip number");
            }

            if (channel < 0)
            {
                throw new Exception("Invalid channel number");
            }

            libsimpleio.libADC.ADC_open(chip, channel, out this.myfd, out error);

            if (error != 0)
            {
                throw new Exception("ADC_open() failed", error);
            }
        }

        /// <summary>
        /// Read-only property returning an integer analog sample from an ADC input.
        /// </summary>
        public int sample
        {
            get
            {
                int rawdata;
                int error;

                libsimpleio.libADC.ADC_read(this.myfd, out rawdata, out error);

                if (error != 0)
                {
                    throw new Exception("ADC_read() failed", error);
                }

                return rawdata;
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for the ADC input.
        /// </summary>
        public int fd
        {
            get
            {
                return this.myfd;
            }
        }
    }
}
