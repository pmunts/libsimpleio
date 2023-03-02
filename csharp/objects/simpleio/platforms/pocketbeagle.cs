// PocketBeagle device definitions

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
    /// PocketBeagle hardware platform.
    /// </summary>
    public static class PocketBeagle
    {
        /// <summary>ADC input designator (0,0) for P1.19 (1.8V)</summary>
        /// <remarks>Requires the <c>PB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN0 = new Designator(0, 0);

        /// <summary>ADC input designator (0,1) for P1.21 (1.8V)</summary>
        /// <remarks>Requires the <c>PB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN1 = new Designator(0, 1);

        /// <summary>ADC input designator (0,2) for P1.23 (1.8V)</summary>
        /// <remarks>Requires the <c>PB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN2 = new Designator(0, 2);

        /// <summary>ADC input designator (0,3) for P1.25 (1.8V)</summary>
        /// <remarks>Requires the <c>PB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN3 = new Designator(0, 3);

        /// <summary>ADC input designator (0,4) for P1.27 (1.8V)</summary>
        /// <remarks>Requires the <c>PB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN4 = new Designator(0, 4);

        /// <summary>ADC input designator (0,5) for P2.35 (3.6V)</summary>
        /// <remarks>Requires the <c>PB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN5 = new Designator(0, 5);

        /// <summary>ADC input designator (0,6) for P1.2 (3.6V)</summary>
        /// <remarks>Requires the <c>PB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN6 = new Designator(0, 6);

        /// <summary>ADC input designator (0,7) for P2.36 (1.8V)</summary>
        /// <remarks>Requires the <c>PB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN7 = new Designator(0, 7);

        /// <summary>GPIO pin designator (0,2) for P1.8 aka <c>SPI0 SCLK</c></summary>
        public static readonly Designator GPIO2 = new Designator(0, 2);

        /// <summary>GPIO pin designator (0,3) for P1.10 aka <c>SPI0 MISO</c></summary>
        public static readonly Designator GPIO3 = new Designator(0, 3);

        /// <summary>GPIO pin designator (0,4) for P1.12 aka <c>SPI0 MOSI</c></summary>
        public static readonly Designator GPIO4 = new Designator(0, 4);

        /// <summary>GPIO pin designator (0,5) for P1.6 aka <c>SPI0 CS0</c></summary>
        public static readonly Designator GPIO5 = new Designator(0, 5);

        /// <summary>GPIO pin designator (0,7) for P2.29 aka <c>SPI1 SCLK</c></summary>
        public static readonly Designator GPIO7 = new Designator(0, 7);

        /// <summary>GPIO pin designator (0,12) for P1.26 aka <c>I2C2 SDA</c></summary>
        public static readonly Designator GPIO12 = new Designator(0, 12);

        /// <summary>GPIO pin designator (0,13) for P1.28 aka <c>I2C2 SCL</c></summary>
        public static readonly Designator GPIO13 = new Designator(0, 13);

        /// <summary>GPIO pin designator (0,14) for P2.11 aka <c>I2C1 SDA</c></summary>
        public static readonly Designator GPIO14 = new Designator(0, 14);

        /// <summary>GPIO pin designator (0,15) for P2.9 aka <c>I2C1 SCL</c></summary>
        public static readonly Designator GPIO15 = new Designator(0, 15);

        /// <summary>GPIO pin designator (0,19) for P2.31 aka <c>SPI1 CS1</c></summary>
        public static readonly Designator GPIO19 = new Designator(0, 19);

        /// <summary>GPIO pin designator (0,20) for P1.20</summary>
        public static readonly Designator GPIO20 = new Designator(0, 20);

        /// <summary>GPIO pin designator (0,23) for P2.3</summary>
        public static readonly Designator GPIO23 = new Designator(0, 23);

        /// <summary>GPIO pin designator (0,26) for P1.34</summary>
        public static readonly Designator GPIO26 = new Designator(0, 26);

        /// <summary>GPIO pin designator (0,27) for P2.19</summary>
        public static readonly Designator GPIO27 = new Designator(0, 27);

        /// <summary>GPIO pin designator (0,30) for P2.5 aka <c>RXD4</c></summary>
        public static readonly Designator GPIO30 = new Designator(0, 30);

        /// <summary>GPIO pin designator (0,31) for P2.7 aka <c>TXD4</c></summary>
        public static readonly Designator GPIO31 = new Designator(0, 31);

        /// <summary>GPIO pin designator (1,8) for P2.27 aka <c>SPI1 MISO</c></summary>
        public static readonly Designator GPIO40 = new Designator(1, 8);

        /// <summary>GPIO pin designator (1,9) for P2.25 aka <c>SPI1 MOSI</c></summary>
        public static readonly Designator GPIO41 = new Designator(1, 9);

        /// <summary>GPIO pin designator (1,10) for P1.32 aka <c>RXD0</c></summary>
        public static readonly Designator GPIO42 = new Designator(1, 10);

        /// <summary>GPIO pin designator (1,11) for P1.30 aka <c>TXD0</c></summary>
        public static readonly Designator GPIO43 = new Designator(1, 11);

        /// <summary>GPIO pin designator (1,12) for P2.24</summary>
        public static readonly Designator GPIO44 = new Designator(1, 12);

        /// <summary>GPIO pin designator (1,13) for P2.33</summary>
        public static readonly Designator GPIO45 = new Designator(1, 13);

        /// <summary>GPIO pin designator (1,14) for P2.22</summary>
        public static readonly Designator GPIO46 = new Designator(1, 14);

        /// <summary>GPIO pin designator (1,15) for P2.18</summary>
        public static readonly Designator GPIO47 = new Designator(1, 15);

        /// <summary>GPIO pin designator (1,18) for P2.1</summary>
        public static readonly Designator GPIO50 = new Designator(1, 18);

        /// <summary>GPIO pin designator (1,20) for P2.10</summary>
        public static readonly Designator GPIO52 = new Designator(1, 20);

        /// <summary>GPIO pin designator (1,25) for P2.6</summary>
        public static readonly Designator GPIO57 = new Designator(1, 25);

        /// <summary>GPIO pin designator (1,26) for P2.4</summary>
        public static readonly Designator GPIO58 = new Designator(1, 26);

        /// <summary>GPIO pin designator (1,27) for P2.2</summary>
        public static readonly Designator GPIO59 = new Designator(1, 27);

        /// <summary>GPIO pin designator (1,28) for P2.8</summary>
        public static readonly Designator GPIO60 = new Designator(1, 28);

        /// <summary>GPIO pin designator (2,0) for P2.20</summary>
        public static readonly Designator GPIO64 = new Designator(2, 0);

        /// <summary>GPIO pin designator (2,1) for P2.17</summary>
        public static readonly Designator GPIO65 = new Designator(2, 1);

        /// <summary>GPIO pin designator (2,22) for P2.35 aka <c>AIN5</c></summary>
        public static readonly Designator GPIO86 = new Designator(2, 22);

        /// <summary>GPIO pin designator (2,23) for P1.2 aka <c>AIN6</c></summary>
        public static readonly Designator GPIO87 = new Designator(2, 23);

        /// <summary>GPIO pin designator (2,24) for P1.35</summary>
        public static readonly Designator GPIO88 = new Designator(2, 24);

        /// <summary>GPIO pin designator (2,25) for P1.4</summary>
        public static readonly Designator GPIO89 = new Designator(2, 25);

        /// <summary>GPIO pin designator (3,14) for P1.36</summary>
        public static readonly Designator GPIO110 = new Designator(3, 14);

        /// <summary>GPIO pin designator (3,15) for P1.33</summary>
        public static readonly Designator GPIO111 = new Designator(3, 15);

        /// <summary>GPIO pin designator (3,16) for P2.32</summary>
        public static readonly Designator GPIO112 = new Designator(3, 16);

        /// <summary>GPIO pin designator (3,17) for P2.30</summary>
        public static readonly Designator GPIO113 = new Designator(3, 17);

        /// <summary>GPIO pin designator (3,18) for P1.31</summary>
        public static readonly Designator GPIO114 = new Designator(3, 18);

        /// <summary>GPIO pin designator (3,19) for P2.34</summary>
        public static readonly Designator GPIO115 = new Designator(3, 19);

        /// <summary>GPIO pin designator (3,20) for P2.28</summary>
        public static readonly Designator GPIO116 = new Designator(3, 20);

        /// <summary>GPIO pin designator (3,21) for P1.29</summary>
        public static readonly Designator GPIO117 = new Designator(3, 21);

        /// <summary>I2C bus designator (0,1) for P2.9 and P2.11 aka <c>GPIO15</c> and <c>GPIO14</c></summary>
        public static readonly Designator I2C1 = new Designator(0, 1);

        /// <summary>I2C bus designator (0,2) for P1.26 and P1.28 aka <c>GPIO12</c> and <c>GPIO13</c></summary>
        public static readonly Designator I2C2 = new Designator(0, 2);

        /// <summary>PWM output designator (0,0) for P1.36 aka <c>GPIO110</c></summary>
        public static readonly Designator PWM0_0 = new Designator(0, 0);

        /// <summary>PWM output designator (2,0) for P2.1 aka <c>GPIO50</c></summary>
        public static readonly Designator PWM2_0 = new Designator(2, 0);

        /// <summary>SPI slave designator (0,0) for P1.6 aka <c>GPIO5</c></summary>
        public static readonly Designator SPI0_0 = new Designator(0, 0);

        /// <summary>SPI slave designator (1,1) for P2.31 aka <c>GPIO19</c></summary>
        public static readonly Designator SPI1_1 = new Designator(1, 1);
    }
}
