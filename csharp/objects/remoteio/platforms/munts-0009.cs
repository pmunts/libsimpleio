// Remote I/O resources available from the MUNTS-0009 USB Grove Adapter

// Copyright (C)2023, Philip Munts dba Munts Technologies.
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

namespace IO.Objects.RemoteIO.Platforms
{
    /// <summary>
    /// I/O resources (channel numbers) available on from a
    /// MUNTS-0009 USB Grove Adapter.
    /// </summary>
    public static class MUNTS_0009
    {
        /// <summary>
        /// Analog input channel number for Grove Connector <c>J3</c> pin <c>1</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO1</c>.
        /// </remarks>
        public const int AIN0 = 0;

        /// <summary>
        /// Analog input channel number for Grove Connector <c>J4</c> pin <c>1</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO3</c> and <c>SPI0</c>.
        /// </remarks>
        public const int AIN1 = 1;

        /// <summary>
        /// Analog input channel number for Grove Connector <c>J4</c> pin <c>2</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO4</c> and <c>SPI0</c>.
        /// </remarks>
        public const int AIN2 = 2;

        /// <summary>
        /// Analog input channel number for Grove Connector <c>J6</c> pin <c>1</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO7</c> and <c>I2C0</c> and <c>SPI0</c>.
        /// </remarks>
        public const int AIN3 = 3;

        /// <summary>
        /// Analog input channel number for Grove Connector <c>J6</c> pin <c>2</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>GPIO8</c> and <c>I2C0</c> and <c>SPI0</c>.
        /// </remarks>
        public const int AIN4 = 4;

        /// <summary>
        /// GPIO channel number for the on-board LED.
        /// </summary>
        /// <remarks>
        /// Cannot be configured as an input.
        /// </remarks>
        public const int LED = 0;

        /// <summary>
        /// GPIO channel number for Grove Connector <c>J3</c> pin <c>1</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>AIN0</c>.
        /// </remarks>
        public const int GPIO1 = 1;

        /// <summary>
        /// GPIO channel number for Grove Connector <c>J3</c> pin <c>2</c>.
        /// </summary>
        /// <remarks>
        /// Cannot be configured as an output.
        /// </remarks>
        public const int GPIO2 = 2;

        /// <summary>
        /// GPIO channel number for Grove Connector <c>J4</c> pin <c>1</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>AIN1</c> and <c>SPI0</c>.
        /// </remarks>
        public const int GPIO3 = 3;

        /// <summary>
        /// GPIO channel number for Grove Connector <c>J4</c> pin <c>2</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>AIN02</c> and <c>SPI0</c>.
        /// </remarks>
        public const int GPIO4 = 4;

        /// <summary>
        /// GPIO channel number for Grove Connector <c>J5</c> pin <c>1</c>.
        /// </summary>
        public const int GPIO5 = 5;

        /// <summary>
        /// GPIO channel number for Grove Connector <c>J5</c> pin <c>2</c>.
        /// </summary>
        public const int GPIO6 = 6;

        /// <summary>
        /// GPIO channel number for Grove Connector <c>J6</c> pin <c>1</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>AIN3</c> and <c>I2C0</c> and <c>SPI0</c>.
        /// </remarks>
        public const int GPIO7 = 7;

        /// <summary>
        /// GPIO channel number for Grove Connector <c>J6</c> pin <c>2</c>.
        /// </summary>
        /// <remarks>
        /// Conflicts with <c>AIN4</c> and <c>I2C0</c> and <c>SPI0</c>.
        /// </remarks>
        public const int GPIO8 = 8;

        /// <summary>
        /// I<sup>2</sup>C bus channel number for Grove Connector <c>J6</c>.
        /// </summary>
        public const int I2C0 = 0;

        /// <summary>
        /// SPI slave device channel number for Grove Connectors <c>J4</c>
        /// and <c>J6</c>.
        /// </summary>
        public const int SPI0 = 0;
    }
}
