// PWM output services using IO.Objects.SimpleIO

// Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Objects.SimpleIO.ADC
{
    /// <summary>
    /// Encapsulates Linux Industrial I/O Subsystem ADC inputs usingi
    /// <c>libsimpleio</c>.
    /// </summary>
    public class Sample : IO.Interfaces.ADC.Sample
    {
        private readonly int myfd;
        private readonly int nbits;

        /// <summary>
        /// Retrieve the subsystem name string for a Linux Industrial
        /// I/O Subsystem ADC device.
        /// </summary>
        /// <param name="chip">ADC chip number.</param>
        /// <returns>Subsystem name.</returns>
        public static string name(int chip)
        {
            System.Text.StringBuilder name =
                new System.Text.StringBuilder(256);

            if (chip < 0)
            {
                throw new Exception("Invalid chip number");
            }

            IO.Bindings.libsimpleio.ADC_get_name(chip, name,
                name.Capacity, out int error);

            if (error != 0)
            {
                throw new Exception("ADC_get_name() failed, " +
                    errno.strerror(error));
            }

            return name.ToString();
        }

        /// <summary>
        /// Constructor for a single ADC input.
        /// </summary>
        /// <param name="desg">ADC input designator.</param>
        /// <param name="resolution">Bits of resolution.</param>
        public Sample(IO.Objects.SimpleIO.Device.Designator desg,
            int resolution)
        {
            // Validate the ADC input designator

            if ((desg.chip == IO.Objects.SimpleIO.Device.Designator.Unavailable.chip) ||
                (desg.chan == IO.Objects.SimpleIO.Device.Designator.Unavailable.chan))
            {
                throw new Exception("Invalid designator");
            }

            IO.Bindings.libsimpleio.ADC_open((int)desg.chip, (int)desg.chan,
                out this.myfd, out int error);

            if (error != 0)
            {
                throw new Exception("ADC_open() failed, " +
                    errno.strerror(error));
            }

            this.nbits = resolution;
        }

        /// <summary>
        /// Read-only property returning an integer analog sample from an ADC
        /// input.
        /// </summary>
        public int sample
        {
            get
            {
                IO.Bindings.libsimpleio.ADC_read(this.myfd,
                    out int rawdata, out int error);

                if (error != 0)
                {
                    throw new Exception("ADC_read() failed, " +
                        errno.strerror(error));
                }

                return rawdata;
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
        /// Read-only property returning the Linux file descriptor for the ADC
        /// input.
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
