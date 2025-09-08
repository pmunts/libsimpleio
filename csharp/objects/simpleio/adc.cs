// ADC input services using IO.Objects.SimpleIO

// Copyright (C)2017-2025, Philip Munts dba Munts Technologies.
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
    internal static class Common
    {
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

        public static double reference(int chip)
        {
            if (chip < 0)
            {
                throw new Exception("Invalid chip number");
            }

            IO.Bindings.libsimpleio.ADC_get_reference(chip, out double vref,
                out int error);

            if (error != 0)
            {
                throw new Exception("ADC_get_reference() failed, " +
                    errno.strerror(error));
            }

            return vref;
        }
    }

    /// <summary>
    /// Encapsulates Linux Industrial I/O Subsystem ADC integer sampled data
    /// inputs using <c>libsimpleio</c>.
    /// </summary>
    /// <remarks>
    /// This class requires <i>a priori</i> knowledge of the ADC device
    /// resolution.  Use <c>IO.Objects.SimpleIO.ADC.Voltage</c> instead if
    /// the ADC device implements scaling.
    /// </remarks>
    public class Sample : IO.Interfaces.ADC.Sample
    {
        private readonly int mychip;
        private readonly int myfd;
        private readonly int nbits;

        /// <summary>
        /// Constructor for a single ADC integer sampled data input.
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

            this.mychip = (int)desg.chip;
            this.nbits = resolution;
        }

        /// <summary>
        /// Read-only property returning an integer analog sample from this ADC
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
        /// Read-only property returning the device name for this ADC input.
        /// </summary>
        public string name
        {
            get
            {
                return Common.name(this.mychip);
            }
        }

        /// <summary>
        /// Read-only property returning the reference voltage for this ADC
        /// input.
        /// </summary>
        /// <remarks>
        /// Not all ADC devices have a queryable voltage reference.
        /// </remarks>
        public double reference
        {
            get
            {
                return Common.reference(this.mychip);
            }
        }

        /// <summary>
        /// Read-only property returning the number of bits of resolution for
        /// this ADC input.
        /// </summary>
        public int resolution
        {
            get
            {
                return this.nbits;
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for this ADC
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

    /// <summary>
    /// Encapsulates Linux Industrial I/O Subsystem ADC floating point
    /// voltage inputs using <c>libsimpleio</c>.
    /// </summary>
    /// <remarks>
    /// This class requires the ADC device to implement scaling, which may
    /// require a special device tree overlay that configures a
    /// voltage reference with the <c>vref-supply</c> property.  The
    /// <c>vref-supply</c> property may requre a ficticious voltage regulator.
    /// See
    /// <a href="https://github.com/pmunts/muntsos/blob/master/boot/RaspberryPi/overlays/MUNTS-0018.dts">MUNTS-0018.dts</a>
    /// for an example.
    /// </remarks>
    public class Voltage : IO.Interfaces.ADC.Voltage
    {
        private readonly int mychip;
        private readonly int myfd;
        private readonly double myscale;

        /// <summary>
        /// Constructor for a single ADC floating point scaled voltage input.
        /// </summary>
        /// <param name="desg">ADC input designator.</param>
        public Voltage(IO.Objects.SimpleIO.Device.Designator desg)
        {
            // Validate the ADC input designator

            if ((desg.chip == IO.Objects.SimpleIO.Device.Designator.Unavailable.chip) ||
                (desg.chan == IO.Objects.SimpleIO.Device.Designator.Unavailable.chan))
            {
                throw new Exception("Invalid designator");
            }

            IO.Bindings.libsimpleio.ADC_get_scale((int)desg.chip, (int)desg.chan,
                out this.myscale, out int error);

            if (error != 0)
            {
                throw new Exception("ADC_get_scale() failed, " +
                    errno.strerror(error));
            }

            IO.Bindings.libsimpleio.ADC_open((int)desg.chip, (int)desg.chan,
                out this.myfd, out error);

            if (error != 0)
            {
                throw new Exception("ADC_open() failed, " +
                    errno.strerror(error));
            }

            this.mychip = (int)desg.chip;
        }

        /// <summary>
        /// Read-only property returning a voltage measurement from an ADC
        /// input.
        /// </summary>
        public double voltage
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

                return rawdata * this.myscale;
            }
        }

        /// <summary>
        /// Read-only property returning the device name for this ADC input.
        /// </summary>
        public string name
        {
            get
            {
                return Common.name(this.mychip);
            }
        }

        /// <summary>
        /// Read-only property returning the reference voltage for this ADC
        /// input.
        /// </summary>
        /// <remarks>
        /// Not all ADC devices have a queryable voltage reference.
        /// </remarks>

        public double reference
        {
            get
            {
                return Common.reference(this.mychip);
            }
        }

        /// <summary>
        /// Read-only property returning the scale factor for this ADC input.
        /// </summary>
        public double scale
        {
            get
            {
                return this.myscale;
            }
        }

        /// <summary>
        /// Read-only property returning the Linux file descriptor for this ADC
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
