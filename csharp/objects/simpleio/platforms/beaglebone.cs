// BeagleBone device definitions

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
    /// <summary>This class defines identifiers for the devices provided by the
    /// BeagleBone hardware platform.</summary>
    public static class BeagleBone
    {
        /// <summary>ADC input designator (0,0) for P9.39 (1.8V).</summary>
        /// <remarks>Requires the <c>BB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN0 = new Designator(0, 0);

        /// <summary>ADC input designator (0,1) for P9.40 (1.8V).</summary>
        /// <remarks>Requires the <c>BB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN1 = new Designator(0, 1);

        /// <summary>ADC input designator (0,2) for P9.37 (1.8V).</summary>
        /// <remarks>Requires the <c>BB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN2 = new Designator(0, 2);

        /// <summary>ADC input designator (0,3) for P9.38 (1.8V).</summary>
        /// <remarks>Requires the <c>BB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN3 = new Designator(0, 3);

        /// <summary>ADC input designator (0,4) for P9.33 (1.8V).</summary>
        /// <remarks>Requires the <c>BB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN4 = new Designator(0, 4);

        /// <summary>ADC input designator (0,5) for P9.36 (1.8V).</summary>
        /// <remarks>Requires the <c>BB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN5 = new Designator(0, 5);

        /// <summary>ADC input designator (0,6) for P9.35 (1.8V).</summary>
        /// <remarks>Requires the <c>BB-ADC</c> device tree overlay.</remarks>
        public static readonly Designator AIN6 = new Designator(0, 6);

        /// <summary>GPIO pin designator (0,2) for P9.22.  Conflicts with
        /// <c>SPI0 SCK</c>, <c>UART 2RXD</c> or <c>EHRPWM0A</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO2 = new Designator(0, 2);

        /// <summary>GPIO pin designator (0,3) for P9.21.  Conflicts with
        /// <c>SPI0 MISO</c> or <c>UART2 TXD</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO3 = new Designator(0, 3);

        /// <summary>GPIO pin designator (0,4) for P9.18.  Conflicts with
        /// <c>SPI0 MOSI</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO4 = new Designator(0, 4);

        /// <summary>GPIO pin designator (0,5) for P9.17.  Conflicts with
        /// <c>SPI0 SS0</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO5 = new Designator(0, 5);

        /// <summary>GPIO pin designator (0,7) for P9.42.  Conflicts with
        /// <c>SPI1 SS1</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO7 = new Designator(0, 7);

        /// <summary>GPIO pin designator (0,8) for P8.35.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO8 = new Designator(0, 8);

        /// <summary>GPIO pin designator (0,9) for P8.33.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO9 = new Designator(0, 9);

        /// <summary>GPIO pin designator (0,10) for P8.31.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO10 = new Designator(0, 10);

        /// <summary>GPIO pin designator (0,11) for P8.32.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO11 = new Designator(0, 11);

        /// <summary>GPIO pin designator (0,12) for P9.20.  Conflicts with
        /// <c>I2C2 SDA</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO12 = new Designator(0, 12);

        /// <summary>GPIO pin designator (0,13) for P9.19.  Conflicts with
        /// <c>I2C2 SCL</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO13 = new Designator(0, 13);

        /// <summary>GPIO pin designator (0,14) for P9.26.  Conflicts with
        /// <c>UART1 RXD</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO14 = new Designator(0, 14);

        /// <summary>GPIO pin designator (0,15) for P9.24.  Conflicts with
        /// <c>UART1 TXD</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO15 = new Designator(0, 15);

        /// <summary>GPIO pin designator (0,20) for P9.41.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO20 = new Designator(0, 20);

        /// <summary>GPIO pin designator (0,22) for P8.19.  Conflicts with
        /// <c>EHRPWM2A</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO22 = new Designator(0, 22);

        /// <summary>GPIO pin designator (0,23) for P8.13.  Conflicts with
        /// <c>EHRPWM2B</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO23 = new Designator(0, 23);

        /// <summary>GPIO pin designator (0,26) for P8.14.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO26 = new Designator(0, 26);

        /// <summary>GPIO pin designator (0,27) for P8.17.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO27 = new Designator(0, 27);

        /// <summary>GPIO pin designator (0,30) for P9.11.  Conflicts with
        /// <c>UART4 RXD</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO30 = new Designator(0, 30);

        /// <summary>GPIO pin designator (0,31) for P9.13.  Conflicts with
        /// <c>UART4 TXD</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO31 = new Designator(0, 31);

        /// <summary>GPIO pin designator (1,0) for P8.25.  Conflicts with
        /// <c>MMC DAT0</c>.</summary>
        /// <remarks>Requires the BeagleBone White and the <c>BB-NOEMMC</c>
        /// device tree overlay.</remarks>
        public static readonly Designator GPIO32 = new Designator(1, 0);

        /// <summary>GPIO pin designator (1,1) for P8.24.  Conflicts with
        /// <c>MMC1 DAT1</c>.</summary>
        /// <remarks>Requires the BeagleBone White and the <c>BB-NOEMMC</c>
        /// device tree overlay.</remarks>
        public static readonly Designator GPIO33 = new Designator(1, 1);

        /// <summary>GPIO pin designator (1,2) for P8.5.  Conflicts with
        /// <c>MMC1 DAT2</c>.</summary>
        /// <remarks>Requires the BeagleBone White and the <c>BB-NOEMMC</c>
        /// device tree overlay.</remarks>
        public static readonly Designator GPIO34 = new Designator(1, 2);

        /// <summary>GPIO pin designator (1,3) for P8.6.  Conflicts with
        /// <c>MMC1 DAT3</c>.</summary>
        /// <remarks>Requires the BeagleBone White and the <c>BB-NOEMMC</c>
        /// device tree overlay.</remarks>
        public static readonly Designator GPIO35 = new Designator(1, 3);

        /// <summary>GPIO pin designator (1,4) for P8.23.  Conflicts with
        /// <c>MMC DAT4</c>.</summary>
        /// <remarks>Requires the BeagleBone White and the <c>BB-NOEMMC</c>
        /// device tree overlay.</remarks>
        public static readonly Designator GPIO36 = new Designator(1, 4);

        /// <summary>GPIO pin designator (1,5) for P8.22.  Conflicts with
        /// <c>MMC1 DAT5</c>.</summary>
        /// <remarks>Requires the BeagleBone White and the <c>BB-NOEMMC</c>
        /// device tree overlay.</remarks>
        public static readonly Designator GPIO37 = new Designator(1, 5);

        /// <summary>GPIO pin designator (1,6) for P8.3.  Conflicts with
        /// <c>MMC1 DAT6</c>.</summary>
        /// <remarks>Requires the BeagleBone White and the <c>BB-NOEMMC</c>
        /// device tree overlay.</remarks>
        public static readonly Designator GPIO38 = new Designator(1, 6);

        /// <summary>GPIO pin designator (1,7) for P8.4.  Conflicts with
        /// <c>MMC1 DAT7</c>.</summary>
        /// <remarks>Requires the BeagleBone White and the <c>BB-NOEMMC</c>
        /// device tree overlay.</remarks>
        public static readonly Designator GPIO39 = new Designator(1, 7);

        /// <summary>GPIO pin designator (1,12) for P8.12.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO44 = new Designator(1, 12);

        /// <summary>GPIO pin designator (1,13) for P8.11.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO45 = new Designator(1, 13);

        /// <summary>GPIO pin designator (1,14) for P8.16.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO46 = new Designator(1, 14);

        /// <summary>GPIO pin designator (1,15) for P8.15.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO47 = new Designator(1, 15);

        /// <summary>GPIO pin designator (1,16) for P9.15.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO48 = new Designator(1, 16);

        /// <summary>GPIO pin designator (1,17) for P9.23.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO49 = new Designator(1, 17);

        /// <summary>GPIO pin designator (1,18) for P9.14.  Conflicts with
        /// <c>EHRPWM1A</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO50 = new Designator(1, 18);

        /// <summary>GPIO pin designator (1,19) for P9.16.  Conflicts with
        /// <c>EHRPWM1B</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO51 = new Designator(1, 19);

        /// <summary>GPIO pin designator (1,28) for P9.12.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO60 = new Designator(1, 28);

        /// <summary>GPIO pin designator (1,29) for P8.26.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO61 = new Designator(1, 29);

        /// <summary>GPIO pin designator (1,30) for P8.21.  Conflicts with
        /// <c>MMC1 CLK</c>.</summary>
        /// <remarks>Requires the BeagleBone White and the <c>BB-NOEMMC</c>
        /// device tree overlay.</remarks>
        public static readonly Designator GPIO62 = new Designator(1, 30);

        /// <summary>GPIO pin designator (1,31) for P8.20.  Conflicts with
        /// <c>MMC1 CMD</c>.</summary>
        /// <remarks>Requires the BeagleBone White and the <c>BB-NOEMMC</c>
        /// device tree overlay.</remarks>
        public static readonly Designator GPIO63 = new Designator(1, 31);

        /// <summary>GPIO pin designator (2,1) for P8.18.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO65 = new Designator(2, 1);

        /// <summary>GPIO pin designator (2,2) for P8.7.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO66 = new Designator(2, 2);

        /// <summary>GPIO pin designator (2,3) for P8.8.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO67 = new Designator(2, 3);

        /// <summary>GPIO pin designator (2,4) for P8.10.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO68 = new Designator(2, 4);

        /// <summary>GPIO pin designator (2,5) for P8.9.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO69 = new Designator(2, 5);

        /// <summary>GPIO pin designator (2,6) for P8.45.  Conflicts with
        /// <c>EHRPWM2A</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO70 = new Designator(2, 6);

        /// <summary>GPIO pin designator (2,7) for P8.46.  Conflicts with
        /// <c>EHRPWM2B</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO71 = new Designator(2, 7);

        /// <summary>GPIO pin designator (2,8) for P8.43.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO72 = new Designator(2, 8);

        /// <summary>GPIO pin designator (2,9) for P8.44.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO73 = new Designator(2, 9);

        /// <summary>GPIO pin designator (2,10) for P8.41.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO74 = new Designator(2, 10);

        /// <summary>GPIO pin designator (2,11) for P8.42.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO75 = new Designator(2, 11);

        /// <summary>GPIO pin designator (2,12) for P8.39.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO76 = new Designator(2, 12);

        /// <summary>GPIO pin designator (2,13) for P8.40.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO77 = new Designator(2, 13);

        /// <summary>GPIO pin designator (2,14) for P8.37.  Conflicts with
        /// <c>UART5 TXD</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO78 = new Designator(2, 14);

        /// <summary>GPIO pin designator (2,15) for P8.38.  Conflicts with
        /// <c>UART5 RXD</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO79 = new Designator(2, 15);

        /// <summary>GPIO pin designator (2,16) for P8.36.  Conflicts with
        /// <c>EHRPWM1A</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO80 = new Designator(2, 16);

        /// <summary>GPIO pin designator (2,17) for P8.34.  Conflicts with
        /// <c>EHRPWM1B</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO81 = new Designator(2, 17);

        /// <summary>GPIO pin designator (2,22) for P8.27.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO86 = new Designator(2, 22);

        /// <summary>GPIO pin designator (2,23) for P8.29.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO87 = new Designator(2, 23);

        /// <summary>GPIO pin designator (2,24) for P8.28.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO88 = new Designator(2, 24);

        /// <summary>GPIO pin designator (2,25) for P8.30.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO89 = new Designator(2, 25);

        /// <summary>GPIO pin designator (3,14) for P9.31.  Conflicts with
        /// <c>SPI1 SCLK</c> or <c>EHRPWM0A</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO110 = new Designator(3, 14);

        /// <summary>GPIO pin designator (3,15) for P9.29.  Conflicts with
        /// <c>SPI1 MISO</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO111 = new Designator(3, 15);

        /// <summary>GPIO pin designator (3,16) for P9.30.  Conflicts with
        /// <c>SPI1 MOSI</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        /// <remarks>This pin is also <c>SPI1 MOSI</c>.</remarks>
        public static readonly Designator GPIO112 = new Designator(3, 16);

        /// <summary>GPIO pin designator (3,17) for P9.28.  Conflicts with
        /// <c>SPI1 SS0</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO113 = new Designator(3, 17);

        /// <summary>GPIO pin designator (3,19) for P9.27.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO115 = new Designator(3, 19);

        /// <summary>GPIO pin designator (3,21) for P9.25.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator GPIO117 = new Designator(3, 21);

        /// <summary>I2C bus designator for P9.19 and P9.20.  Conflicts with
        /// <c>GPIO13</c> or <c>GPIO12</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator I2C2 = new Designator(0, 2);

        /// <summary>PWM output designator (1,0) for P9.22 or P9.31.  Conflicts
        /// with <c>GPIO2</c> or <c>GPIO110</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator EHRPWM0A = new Designator(1, 0);

        /// <summary>PWM output designator (1,1) for P9.21 or P9.29.  Conflicts
        /// with <c>GPIO3</c> or <c>GPIO111</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator EHRPWM0B = new Designator(1, 1);

        /// <summary>PWM output designator (3,0) for P8.36 or P9.14.  Conflicts
        /// with <c>GPIO80</c> or <c>GPIO50</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator EHRPWM1A = new Designator(3, 0);

        /// <summary>PWM output designator (3,1) for P8.34 or P9.16.  Conflicts
        /// with <c>GPIO81</c> or <c>GPIO51</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator EHRPWM1B = new Designator(3, 1);

        /// <summary>PWM output designator (6,0) for P8.19 or P8.45.  Conflicts
        /// with <c>GPIO22</c> or <c>GPIO70</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator EHRPWM2A = new Designator(6, 0);

        /// <summary>PWM output designator (6,1) for P8.13 or P8.46.  Conflicts
        /// with <c>GPIO23</c> or <c>GPIO71</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator EHRPWM2B = new Designator(6, 1);

        /// <summary>SPI slave designator (0,0) for P9.17.  Conflicts with
        /// <c>SPI0 SS0</c> or <c>GPIO5</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator SPI0_0 = new Designator(0, 0);

        /// <summary>SPI slave designator (1,0) for P9.28.  Conflicts with
        /// <c>SP1 SS0</c> or <c>GPIO113</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator SPI1_0 = new Designator(1, 0);

        /// <summary>SPI slave designator (1,1) for P9.42.  Conflicts with
        /// <c>SPI1 SS1</c> or <c>GPIO7</c>.</summary>
        /// <remarks>Requires the <c>BB-GPIO</c> device tree overlay.</remarks>
        public static readonly Designator SPI1_1 = new Designator(1, 1);
    }
}
