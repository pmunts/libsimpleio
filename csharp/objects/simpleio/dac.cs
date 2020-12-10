// PWM output services using IO.Objects.libsimpleio

// Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.
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

using System;

namespace IO.Objects.libsimpleio.DAC
{
    /// <summary>
    /// Encapsulates Linux Industrial I/O Subsystem DAC outputs using
    /// <c>libsimpleio</c>.
    /// </summary>
    public class Sample: IO.Interfaces.DAC.Sample
    {
        private readonly int myfd;
        private readonly int nbits;

        /// <summary>
        /// Retrieve the subsystem name string for a Linux Industrial
        /// I/O Subsystem DAC device.
        /// </summary>
        /// <param name="chip">DAC chip number.</param>
        /// <returns>Subsystem name.</returns>
        public static string name(int chip)
        {
            System.Text.StringBuilder name =
                new System.Text.StringBuilder(256);
            int error;

            if (chip < 0)
            {
                throw new Exception("Invalid chip number");
            }

            IO.Bindings.libsimpleio.DAC_get_name(chip, name,
                name.Capacity, out error);

            return name.ToString();
        }

        /// <summary>
        /// Constructor for a single DAC output.
        /// </summary>
        /// <param name="desg">DAC output designator.</param>
        /// <param name="resolution">Bits of resolution.</param>
        /// <param name="sample">Initial DAC output sample.</param>
        public Sample(IO.Objects.libsimpleio.Device.Designator desg,
            int resolution, int sample = 0)
        {
            int error;

            // Validate the DAC output designator

            if ((desg.chip == IO.Objects.libsimpleio.Device.Designator.Unavailable.chip) ||
                (desg.chan == IO.Objects.libsimpleio.Device.Designator.Unavailable.chan))
            {
                throw new Exception("Invalid designator");
            }

            IO.Bindings.libsimpleio.DAC_open((int)desg.chip, (int)desg.chan,
                out this.myfd, out error);

            if (error != 0)
            {
                throw new Exception("DAC_open() failed, " +
                    errno.strerror(error));
            }

            this.nbits = resolution;
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
                int error;

                IO.Bindings.libsimpleio.DAC_write(this.myfd,
                    value, out error);

                if (error != 0)
                {
                    throw new Exception("DAC_write() failed" +
                        errno.strerror(error));
                }
            }
        }

        /// <summary>
        /// Read-only property returning the number of bits of resolution.
        /// </summary>
        public int resolution
        {
            get
            {
                return this.nbits;
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for the DAC
        /// output.
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
