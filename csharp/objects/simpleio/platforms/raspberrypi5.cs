// Raspberry Pi 5 I/O resource definitions

// Copyright (C)2024, Philip Munts dba Munts Technologies.
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

using IO.Objects.SimpleIO.Device;

namespace IO.Objects.SimpleIO.Platforms
{
    /// <summary>
    /// This class defines identifiers for the devices provided by the
    /// Raspberry Pi 5 hardware platform.
    /// </summary>
    public static class RaspberryPi5
    {
        /// <summary>Analog input designator (0, 0).</summary>
        /// <remarks>Raspberry Pi boards don't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN0 = new Designator(0, 0);

        /// <summary>Analog input designator (0, 1).</summary>
        /// <remarks>Raspberry Pi boards don't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN1 = new Designator(0, 1);

        /// <summary>Analog input designator (0, 2).</summary>
        /// <remarks>Raspberry Pi boards don't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN2 = new Designator(0, 2);

        /// <summary>Analog input designator (0, 3).</summary>
        /// <remarks>Raspberry Pi boards don't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN3 = new Designator(0, 3);

        /// <summary>Analog input designator (0, 4).</summary>
        /// <remarks>Raspberry Pi boards don't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN4 = new Designator(0, 4);

        /// <summary>Analog input designator (0, 5).</summary>
        /// <remarks>Raspberry Pi boards don't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN5 = new Designator(0, 5);

        /// <summary>Analog input designator (0, 6).</summary>
        /// <remarks>Raspberry Pi boards don't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN6 = new Designator(0, 6);

        /// <summary>Analog input designator (0, 7).</summary>
        /// <remarks>Raspberry Pi boards don't have a built-in ADC (Analog to
        /// Digital Converter) subsystem, so this is just a placeholder
        /// for the first IIO (Industrial I/O) ADC device.</remarks>
        public static readonly Designator AIN7 = new Designator(0, 7);

        /// <summary>GPIO pin designator (0, 0).  Conflicts with
        /// <c>I2C0 SDA</c>.</summary>
        public static readonly Designator GPIO0 = new Designator(0, 0);

        /// <summary>GPIO pin designator (0, 1).  Conflicts with
        /// <c>I2C0 SDA</c>.</summary>
        public static readonly Designator GPIO1 = new Designator(0, 1);

        /// <summary>GPIO pin designator (0, 2).  Conflicts with
        /// <c>I2C1 SDA</c>.</summary>
        public static readonly Designator GPIO2 = new Designator(0, 2);

        /// <summary>GPIO pin designator (0, 3).  Conflicts with
        /// <c>I2C1 SCL</c>.</summary>
        public static readonly Designator GPIO3 = new Designator(0, 3);

        /// <summary>GPIO pin designator (0, 4).</summary>
        public static readonly Designator GPIO4 = new Designator(0, 4);

        /// <summary>GPIO pin designator (0, 5).</summary>
        public static readonly Designator GPIO5 = new Designator(0, 5);

        /// <summary>GPIO pin designator (0, 6).</summary>
        public static readonly Designator GPIO6 = new Designator(0, 6);

        /// <summary>GPIO pin designator (0, 7).  Conflicts with
        /// <c>SPI0 SS1</c>.</summary>
        public static readonly Designator GPIO7 = new Designator(0, 7);

        /// <summary>GPIO pin designator (0, 8).  Conflicts with
        /// <c>SPI0 SS0</c>.</summary>
        public static readonly Designator GPIO8 = new Designator(0, 8);

        /// <summary>GPIO pin designator (0, 9).  Conflicts with
        /// <c>SPI0 MISO</c>.</summary>
        public static readonly Designator GPIO9 = new Designator(0, 9);

        /// <summary>GPIO pin designator (0, 10).  Conflicts with
        /// <c>SPI0 MOSI</c>.</summary>
        public static readonly Designator GPIO10 = new Designator(0, 10);

        /// <summary>GPIO pin designator (0, 11).  Conflicts with
        /// <c>SPI0 SCLK</c>.</summary>
        public static readonly Designator GPIO11 = new Designator(0, 11);

        /// <summary>GPIO pin designator (0, 12).</summary>
        public static readonly Designator GPIO12 = new Designator(0, 12);

        /// <summary>GPIO pin designator (0, 13).</summary>
        public static readonly Designator GPIO13 = new Designator(0, 13);

        /// <summary>GPIO pin designator (0, 14).  Conflicts with
        /// <c>UART0 TXD</c>.</summary>
        public static readonly Designator GPIO14 = new Designator(0, 14);

        /// <summary>GPIO pin designator (0, 15).  Conflicts with
        /// <c>UART0 RXD</c>.</summary>
        public static readonly Designator GPIO15 = new Designator(0, 15);

        /// <summary>GPIO pin designator (0, 16).  Conflicts with
        /// <c>SPI1 SS2</c>.</summary>
        public static readonly Designator GPIO16 = new Designator(0, 16);

        /// <summary>GPIO pin designator (0, 17).  Conflicts with
        /// <c>SPI1 SS1</c>.</summary>
        public static readonly Designator GPIO17 = new Designator(0, 17);

        /// <summary>GPIO pin designator (0, 18).  Conflicts with
        /// <c>PWM0</c> or <c>SPI1 SS0</c>.</summary>
        public static readonly Designator GPIO18 = new Designator(0, 18);

        /// <summary>GPIO pin designator (0, 19).  Conflicts with
        /// <c>PWM1</c> or <c>SPI1 MISO</c>.</summary>
        public static readonly Designator GPIO19 = new Designator(0, 19);

        /// <summary>GPIO pin designator (0, 20).  Conflicts with
        /// <c>SPI1 MOSI</c>.</summary>
        public static readonly Designator GPIO20 = new Designator(0, 20);

        /// <summary>GPIO pin designator (0, 21).  Conflicts with
        /// <c>SPI1 SCLK</c>.</summary>
        public static readonly Designator GPIO21 = new Designator(0, 21);

        /// <summary>GPIO pin designator (0, 22).</summary>
        public static readonly Designator GPIO22 = new Designator(0, 22);

        /// <summary>GPIO pin designator (0, 23).</summary>
        public static readonly Designator GPIO23 = new Designator(0, 23);

        /// <summary>GPIO pin designator (0, 24).</summary>
        public static readonly Designator GPIO24 = new Designator(0, 24);

        /// <summary>GPIO pin designator (0, 25).</summary>
        public static readonly Designator GPIO25 = new Designator(0, 25);

        /// <summary>GPIO pin designator (0, 26).</summary>
        public static readonly Designator GPIO26 = new Designator(0, 26);

        /// <summary>GPIO pin designator (0, 27).</summary>
        public static readonly Designator GPIO27 = new Designator(0, 27);

        /// <summary>I2C bus designator (0, 0).  Conflicts with <c>GPIO0</c>
        /// and <c>GPIO1</c> or <c>GPIO8</c> and <c>GPIO9</c>.
        /// Requires the <c>i2c0.dtbo</c> device tree overlay).
        /// </summary>
        public static readonly Designator I2C0 = new Designator(0, 0);

        /// <summary>I2C bus designator (0, 1).  Conflicts with <c>GPIO2</c>
        /// and <c>GPIO3</c>.</summary>
        public static readonly Designator I2C1 = new Designator(0, 1);

        /// <summary>I2C bus designator (0, 2).  Conflicts with <c>GPIO4</c>
        /// and <c>GPIO5</c> or <c>GPIO12</c> and <c>GPIO13</c>.
        /// Requires the <c>i2c2.dtbo</c> device tree overlay).
        /// </summary>
        public static readonly Designator I2C2 = new Designator(0, 2);

        /// <summary>I2C bus designator (0, 3).  Conflicts with <c>GPIO6</c>
        /// and <c>GPIO7</c> or <c>GPIO14</c> and <c>GPIO15</c>.
        /// Requires the <c>i2c3.dtbo</c> device tree overlay).
        /// </summary>
        public static readonly Designator I2C3 = new Designator(0, 3);

        /// <summary>PWM output designator (2, 0).  Conflicts with
        /// <c>GPIO12</c>.  Requires the <c>pwmchip.dtbo</c>
        /// device tree overlay.</summary>
        public static readonly Designator PWM0 = new Designator(2, 0);

        /// <summary>PWM output designator (2, 1).  Conflicts with
        /// <c>GPIO13</c>.  Requires the <c>pwmchip.dtbo</c>
        /// device tree overlay.</summary>
        public static readonly Designator PWM1 = new Designator(2, 1);

        /// <summary>PWM output designator (2, 2).  Conflicts with
        /// <c>GPIO14</c> or <c>GPIO18</c>.  Requires the <c>pwmchip.dtbo</c>
        /// device tree overlay.</summary>
        public static readonly Designator PWM2 = new Designator(2, 2);

        /// <summary>PWM output designator (2, 3).  Conflicts with
        /// <c>GPIO15</c> or <c>GPIO19</c>.  Requires the <c>pwmchip.dtbo</c>
        /// device tree overlay.</summary>
        public static readonly Designator PWM3 = new Designator(2, 3);

        /// <summary>SPI slave designator (0, 0).  Conflicts with
        /// <c>GPIO8</c>.</summary>
        public static readonly Designator SPI0_0 = new Designator(0, 0);

        /// <summary>SPI slave designator (0, 1).  Conflicts with
        /// <c>GPIO7</c>.</summary>
        public static readonly Designator SPI0_1 = new Designator(0, 1);

        /// <summary>SPI slave designator (1, 0).  Conflicts with
        /// <c>GPIO18</c> or <c>PWM0</c>.  Requires one of the
        /// <c>spi1-1cs.dtbo</c>, <c>spi1-2cs.dtbo</c> or <c>spi1-3cs.dtbo</c>
        /// device tree overlays.</summary>
        public static readonly Designator SPI1_0 = new Designator(1, 0);

        /// <summary>SPI slave designator (1, 1).  Conflicts with
        /// <c>GPIO17</c>.  Requires one of the <c>spi1-1cs.dtbo</c>,
        /// <c>spi1-2cs.dtbo</c> or <c>spi1-3cs.dtbo</c> device tree
        /// overlays.</summary>
        public static readonly Designator SPI1_1 = new Designator(1, 1);

        /// <summary>SPI slave designator (1, 2).  Conflicts with
        /// <c>GPIO16</c>.  Requires one of the <c>spi1-1cs.dtbo</c>,
        /// <c>spi1-2cs.dtbo</c> or <c>spi1-3cs.dtbo</c> device tree
        /// overlays.</summary>
        public static readonly Designator SPI1_2 = new Designator(1, 2);
    }
}
