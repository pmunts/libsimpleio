// Raspberry Pi I/O resource definitions

// Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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
    /// I/O resources (channel numbers) available on a Raspberry Pi Remote I/O
    /// Protocol Server
    /// </summary>
    public static class RaspberryPi
    {
        /// <summary>
        /// Analog input channel number for the remote Raspberry Pi analog
        /// input <c>AIN0</c>.
        /// </summary>
        /// <remarks>
        /// This analog input is only available if a
        /// <a href="https://www.mikroe.com/pi-3-click-shield">Mikroelektronika
        /// Pi 3 Click Shield (MIKROE-2756)</a> is installed and the following
        /// device tree overlay command added to config.txt:
        /// <code>
        /// dtoverlay=Pi3ClickShield
        /// </code>
        /// </remarks>
        public const int AIN0 = 0;
        /// <summary>
        /// Analog input channel number for the remote Raspberry Pi analog
        /// input <c>AIN1</c>.
        /// </summary>
        /// <remarks>
        /// This analog input is only available if a
        /// <a href="https://www.mikroe.com/pi-3-click-shield">Mikroelektronika
        /// Pi 3 Click Shield (MIKROE-2756)</a> is installed and the following
        /// device tree overlay command added to config.txt:
        /// <code>
        /// dtoverlay=Pi3ClickShield
        /// </code>
        /// </remarks>
        public const int AIN1 = 1;

        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi user LED.
        /// </summary>
        /// <remarks>
        /// This GPIO pin cannot be configured as an input.
        /// </remarks>
        public const int USERLED = 0;

        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO2</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is normally unusable because <c>GPIO2</c> is
        /// mapped to I<sup>2</sup>C signal <c>SDA1</c>.
        /// </remarks>
        public const int GPIO2 = 2;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO3</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is normally unusable because <c>GPIO3</c> is
        /// mapped to to I<sup>2</sup>C signal <c>SCL1</c>.
        /// </remarks>
        public const int GPIO3 = 3;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO4</c>.
        /// </summary>
        public const int GPIO4 = 4;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO7</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is normally unusable because <c>GPIO7</c> is
        /// mapped to SPI signal <c>SPI0_CE1</c>.
        /// </remarks>
        public const int GPIO7 = 7;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO8</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is normally unusable because <c>GPIO8</c> is
        /// mapped to SPI signal <c>SPI0_CE0</c>.
        /// </remarks>
        public const int GPIO8 = 8;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO9</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is normally unusable because <c>GPIO9</c> is
        /// mapped to SPI signal <c>SPI0_MISO</c>.
        /// </remarks>
        public const int GPIO9 = 9;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO10</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is normally unusable because <c>GPIO10</c> is
        /// mapped to SPI signal <c>SPI0_MOSI</c>.
        /// </remarks>
        public const int GPIO10 = 10;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO11</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is normally unusable because <c>GPIO11</c> is
        /// mapped to SPI signal <c>SPI0_SCLK</c>.
        /// </remarks>
        public const int GPIO11 = 11;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO14</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is normally unusable because <c>GPIO14</c> is
        /// mapped to UART signal <c>UART0_TXD</c>.
        /// </remarks>
        public const int GPIO14 = 14;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO15</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is normally unusable because <c>GPIO15</c> is
        /// mapped to UART signal <c>UART0_RXD</c>.
        /// </remarks>
        public const int GPIO15 = 15;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO17</c>.
        /// </summary>
        public const int GPIO17 = 17;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO18</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is normally unusable because <c>GPIO18</c> is
        /// mapped to PWM output <c>PWM0</c>.
        /// </remarks>
        public const int GPIO18 = 18;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO22</c>.
        /// </summary>
        public const int GPIO22 = 22;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO23</c>.
        /// </summary>
        public const int GPIO23 = 23;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO24</c>.
        /// </summary>
        public const int GPIO24 = 24;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO25</c>.
        /// </summary>
        public const int GPIO25 = 25;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO27</c>.
        /// </summary>
        public const int GPIO27 = 27;

        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO5</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is not usable when the Remote I/O server
        /// is running on an original Raspberry Pi 1 Model A or B with a 26-pin
        /// expansion header.
        /// </remarks>
        public const int GPIO5 = 5;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO6</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is not usable when the Remote I/O server
        /// is running on an original Raspberry Pi 1 Model A or B with a 26-pin
        /// expansion header.
        /// </remarks>
        public const int GPIO6 = 6;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO12</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is not usable when the Remote I/O server
        /// is running on an original Raspberry Pi 1 Model A or B with a 26-pin
        /// expansion header.
        /// </remarks>
        public const int GPIO12 = 12;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO13</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is not usable when the Remote I/O server
        /// is running on an original Raspberry Pi 1 Model A or B with a 26-pin
        /// expansion header.
        /// </remarks>
        public const int GPIO13 = 13;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO16</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is not usable when the Remote I/O server
        /// is running on an original Raspberry Pi 1 Model A or B with a 26-pin
        /// expansion header.
        /// </remarks>
        public const int GPIO16 = 16;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO19</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is not usable when the Remote I/O server
        /// is running on an original Raspberry Pi 1 Model A or B with a 26-pin
        /// expansion header.
        /// </remarks>
        public const int GPIO19 = 19;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO20</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is not usable when the Remote I/O server
        /// is running on an original Raspberry Pi 1 Model A or B with a 26-pin
        /// expansion header.
        /// </remarks>
        public const int GPIO20 = 20;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO21</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is not usable when the Remote I/O server
        /// is running on an original Raspberry Pi 1 Model A or B with a 26-pin
        /// expansion header.
        /// </remarks>
        public const int GPIO21 = 21;
        /// <summary>
        /// GPIO channel number for the remote Raspberry Pi GPIO pin <c>GPIO26</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO channel is not usable when the Remote I/O server
        /// is running on an original Raspberry Pi 1 Model A or B with a 26-pin
        /// expansion header.
        /// </remarks>
        public const int GPIO26 = 26;

        /// <summary>
        /// I<sup>2</sup>C bus channel number for the remote Raspberry Pi
        /// I<sup>2</sup>C bus controller <c>I2C1</c>.
        /// </summary>
        /// <remarks>
        /// The following device tree overlay command must be added to
        /// <c>config.txt</c> on the Raspberry Pi Remote I/O server to enable
        /// I<sup>2</sup>C bus controller <c>I2C1</c>:
        /// <code>
        /// dtparam=i2c=on
        /// </code>
        /// </remarks>
        public const int I2C1 = 0;

        /// <summary>
        /// PWM output channel number for the remote Raspberry Pi PWM output
        /// <c>PWM0</c>.
        /// </summary>
        /// <remarks>
        /// The following device tree overlay command must be added to
        /// <c>config.txt</c> on the Raspberry Pi Remote I/O server to enable
        /// PWM output <c>PWM0</c>:
        /// <code>
        /// dtoverlay=pwm
        /// </code>
        /// </remarks>
        public const int PWM0 = 0;
        /// <summary>
        /// PWM output channel number for the remote Raspberry Pi PWM output
        /// <c>PWM1</c>.
        /// </summary>
        /// <remarks>
        /// <c>PWM1</c> is not normally enabled. You can enable it with one
        /// of the device tree overlay command variationss described in
        /// <a href="https://github.com/raspberrypi/firmware/blob/master/boot/overlays/README">
        /// https://github.com/raspberrypi/firmware/blob/master/boot/overlays/README</a>.
        /// </remarks>
        public const int PWM1 = 1;

        /// <summary>
        /// SPI slave device channel number for the remote Raspberry Pi SPI
        /// slave device <c>/dev/spidev0.0</c>.
        /// </summary>
        /// <remarks>
        /// <c>/dev/spidev0.0</c> uses <c>GPIO8</c> for slave select.
        /// The following device tree overlay command must be added to
        /// <c>config.txt</c> on the Raspberry Pi Remote I/O server to enable
        /// SPI bus controller <c>SPI0</c>:
        /// <code>
        /// dtparam=spi=on
        /// </code>
        /// </remarks>
        public const int SPI0 = 0;
        /// <summary>
        /// SPI slave device channel number for the remote Raspberry Pi SPI
        /// slave device <c>/dev/spidev0.1</c>.
        /// </summary>
        /// <remarks>
        /// <c>/dev/spidev0.1</c> uses <c>GPIO7</c> for slave select.
        /// The following device tree overlay command must be added to
        /// <c>config.txt</c> on the Raspberry Pi Remote I/O server to enable
        /// SPI bus controller <c>SPI0</c>:
        /// <code>
        /// dtparam=spi=on
        /// </code>
        /// </remarks>
        public const int SPI1 = 1;
    }
}
