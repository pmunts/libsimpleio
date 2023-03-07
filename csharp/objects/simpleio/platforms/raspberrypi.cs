// Raspberry Pi I/O resource definitions

// Copyright (C)2018-2023, Philip Munts.
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
    /// Raspberry Pi hardware platform.
    /// </summary>
    public static class RaspberryPi
    {
        /// <summary>Analog input designator (0,0).  Requires the
        /// Mikroelektronika Pi 3 Click Shield and the
        /// <c>Pi3ClickShield.dtbo</c> device tree overlay.</summary>
        public static readonly Designator AIN0 = new Designator(0,0);

        /// <summary>Analog input designator (0,1).  Requires the
        /// Mikroelektronika Pi 3 Click Shield and the
        /// <c>Pi3ClickShield.dtbo</c> device tree overlay.</summary>
        public static readonly Designator AIN1 = new Designator(0,1);

        /// <summary>GPIO pin designator (0,2).  Conflicts with
        /// <c>I2C1 SDA</c>.</summary>
        public static readonly Designator GPIO2 = new Designator(0,2);

        /// <summary>GPIO pin designator (0,3).  Conflicts with
        /// <c>I2C1 SCL</c>.</summary>
        public static readonly Designator GPIO3 = new Designator(0,3);

        /// <summary>GPIO pin designator (0,4).</summary>
        public static readonly Designator GPIO4 = new Designator(0,4);

        /// <summary>GPIO pin designator (0,5).  Not available on early boards
        /// with 26 pin expansion headers.</summary>
        public static readonly Designator GPIO5 = new Designator(0, 5);

        /// <summary>GPIO pin designator (0,6).  Not available on early boards
        /// with 26 pin expansion headers.</summary>
        public static readonly Designator GPIO6 = new Designator(0, 6);

        /// <summary>GPIO pin designator (0,7).  Conflicts with
        /// <c>SPI0 SS1</c>.</summary>
        public static readonly Designator GPIO7 = new Designator(0,7);

        /// <summary>GPIO pin designator (0,8).  Conflicts with
        /// <c>SPI0 SS0</c>.</summary>
        public static readonly Designator GPIO8 = new Designator(0,8);

        /// <summary>GPIO pin designator (0,9).  Conflicts with
        /// <c>SPI0 MISO</c>.</summary>
        public static readonly Designator GPIO9 = new Designator(0,9);

        /// <summary>GPIO pin designator (0,10).  Conflicts with
        /// <c>SPI0 MOSI</c>.</summary>
        public static readonly Designator GPIO10 = new Designator(0,10);

        /// <summary>GPIO pin designator (0,11).  Conflicts with
        /// <c>SPI0 SCLK</c>.</summary>
        public static readonly Designator GPIO11 = new Designator(0,11);

        /// <summary>GPIO pin designator (0,12).  Not available on early boards
        /// with 26 pin expansion headers.</summary>
        public static readonly Designator GPIO12 = new Designator(0, 12);

        /// <summary>GPIO pin designator (0,13).  Not available on early boards
        /// with 26 pin expansion headers.</summary>
        public static readonly Designator GPIO13 = new Designator(0, 13);

        /// <summary>GPIO pin designator (0,14).  Conflicts with
        /// <c>UART0 TXD</c>.</summary>
        public static readonly Designator GPIO14 = new Designator(0,14);

        /// <summary>GPIO pin designator (0,15).  Conflicts with
        /// <c>UART0 RXD</c>.</summary>
        public static readonly Designator GPIO15 = new Designator(0,15);

        /// <summary>GPIO pin designator (0,16).  Conflicts with
        /// <c>SPI1 SS2</c>.  Not available on early boards
        /// with 26 pin expansion headers.</summary>
        public static readonly Designator GPIO16 = new Designator(0, 16);

        /// <summary>GPIO pin designator (0,17).  Conflicts with
        /// <c>SPI1 SS1</c>.</summary>
        public static readonly Designator GPIO17 = new Designator(0,17);

        /// <summary>GPIO pin designator (0,18).  Conflicts with
        /// <c>PWM0</c> or <c>SPI1 SS0</c>.</summary>
        public static readonly Designator GPIO18 = new Designator(0,18);

        /// <summary>GPIO pin designator (0,19).  Conflicts with
        /// <c>PWM1</c> or <c>SPI1 MISO</c>.  Not available on early boards
        /// with 26 pin expansion headers.</summary>
        public static readonly Designator GPIO19 = new Designator(0, 19);

        /// <summary>GPIO pin designator (0,20).  Conflicts with
        /// <c>SPI1 MOSI</c>.  Not available on early boards
        /// with 26 pin expansion headers.</summary>
        public static readonly Designator GPIO20 = new Designator(0, 20);

        /// <summary>GPIO pin designator (0,21).  Conflicts with
        /// <c>SPI1 SCLK</c>.  Not available on early boards
        /// with 26 pin expansion headers.</summary>
        public static readonly Designator GPIO21 = new Designator(0, 21);

        /// <summary>GPIO pin designator (0,22).</summary>
        public static readonly Designator GPIO22 = new Designator(0,22);

        /// <summary>GPIO pin designator (0,23).</summary>
        public static readonly Designator GPIO23 = new Designator(0,23);

        /// <summary>GPIO pin designator (0,24).</summary>
        public static readonly Designator GPIO24 = new Designator(0,24);

        /// <summary>GPIO pin designator (0,25).</summary>
        public static readonly Designator GPIO25 = new Designator(0,25);

        /// <summary>GPIO pin designator (0,26).  Not available on early boards
        /// with 26 pin expansion headers.</summary>
        public static readonly Designator GPIO26 = new Designator(0, 26);

        /// <summary>GPIO pin designator (0,27).</summary>
        public static readonly Designator GPIO27 = new Designator(0,27);

        /// <summary>I2C bus designator (0,1).  Conflicts with <c>GPIO2</c>
        /// and <c>GPIO3</c>.</summary>
        public static readonly Designator I2C1 = new Designator(0,1);

        /// <summary>I2C bus designator (0,3).  Only available on a Raspberry
        /// Pi 4, and requires the <c>i2c3.dtbo</c> device tree overlay).
        /// </summary>
        public static readonly Designator I2C3 = new Designator(0,3);

        /// <summary>I2C bus designator (0,4).  Only available on a Raspberry
        /// Pi 4, and requires the <c>i2c4.dtbo</c> device tree overlay).
        /// </summary>
        public static readonly Designator I2C4 = new Designator(0,4);

        /// <summary>I2C bus designator (0,5).  Only available on a Raspberry
        /// Pi 4, and requires the <c>i2c5.dtbo</c> device tree overlay).
        /// </summary>
        public static readonly Designator I2C5 = new Designator(0,5);

        /// <summary>I2C bus designator (0,6).  Only available on a Raspberry
        /// Pi 4, and requires the <c>i2c6.dtbo</c> device tree overlay).
        /// </summary>
        public static readonly Designator I2C6 = new Designator(0,6);

        /// <summary>PWM output designator (0,0).  Conflicts with
        /// <c>GPIO12</c> or <c>GPIO18</c>.  Requires the <c>pwm.dtbo</c>
        /// device tree overlay.</summary>
        public static readonly Designator PWM0_0 = new Designator(0,0);

        /// <summary>PWM output designator (0,1).  Conflicts with
        /// <c>GPIO13</c> or <c>GPIO19</c>.  Requires the <c>pwm.dtbo</c>
        /// device tree overlay.</summary>
        public static readonly Designator PWM0_1 = new Designator(0,1);

        /// <summary>SPI slave designator (0,0).  Conflicts with
        /// <c>GPIO8</c>.</summary>
        public static readonly Designator SPI0_0 = new Designator(0,0);

        /// <summary>SPI slave designator (0,1).  Conflicts with
        /// <c>GPIO7</c>.</summary>
        public static readonly Designator SPI0_1 = new Designator(0,1);

        /// <summary>SPI slave designator (1,0).  Conflicts with
        /// <c>GPIO18</c> or <c>PWM0</c>.  Requires one of the
        /// <c>spi1-1cs.dtbo</c>, <c>spi1-2cs.dtbo</c> or <c>spi1-3cs.dtbo</c>
        /// device tree overlays.</summary>
        public static readonly Designator SPI1_0 = new Designator(1,0);

        /// <summary>SPI slave designator (1,1).  Conflicts with
        /// <c>GPIO17</c>.  Requires one of the <c>spi1-1cs.dtbo</c>,
        /// <c>spi1-2cs.dtbo</c> or <c>spi1-3cs.dtbo</c> device tree
        /// overlays.</summary>
        public static readonly Designator SPI1_1 = new Designator(1,1);

        /// <summary>SPI slave designator (1,2).  Conflicts with
        /// <c>GPIO16</c>.  Requires one of the <c>spi1-1cs.dtbo</c>,
        /// <c>spi1-2cs.dtbo</c> or <c>spi1-3cs.dtbo</c> device tree
        /// overlays.</summary>
        public static readonly Designator SPI1_2 = new Designator(1,2);
    }
}
