// BeagleBone device definitions

// Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

using IO.Objects.libsimpleio.GPIO;

namespace IO.Objects
{
    /// <summary>
    /// This class defines identifiers for the devices provided by the
    /// BeagleBone hardware platform.
    /// </summary>
    public static class BeagleBone
    {
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO2 = new Designator(0, 2);     // P9.22  UART2 RXD
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO3 = new Designator(0, 3);     // P9.21  UART2 TXD
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO4 = new Designator(0, 4);     // P9.18
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO5 = new Designator(0, 5);     // P9.17
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO7 = new Designator(0, 7);     // P9.42  SPI1 SS1
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO8 = new Designator(0, 8);     // P8.35
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO9 = new Designator(0, 9);     // P8.33
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO10 = new Designator(0, 10);   // P8.31
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO11 = new Designator(0, 11);   // P8.32
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO12 = new Designator(0, 12);   // P9.20  I2C2 SDA
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO13 = new Designator(0, 13);   // P9.19  I2C2 SCL
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO14 = new Designator(0, 14);   // P9.26  UART1 RXD
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO15 = new Designator(0, 15);   // P9.24  UART1 TXD
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO20 = new Designator(0, 20);   // P9.41
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO22 = new Designator(0, 22);   // P8.19
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO23 = new Designator(0, 23);   // P8.13
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO26 = new Designator(0, 26);   // P8.14
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO27 = new Designator(0, 27);   // P8.17
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO30 = new Designator(0, 30);   // P9.11  UART4 RXD
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO31 = new Designator(0, 31);   // P9.13  UART4 TXD
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO32 = new Designator(1, 0);    // P8.25  MMC1 DAT0
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO33 = new Designator(1, 1);    // P8.24  MMC1 DAT1
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO34 = new Designator(1, 2);    // P8.5   MMC1 DAT2
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO35 = new Designator(1, 3);    // P8.6   MMC1 DAT3
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO36 = new Designator(1, 4);    // P8.23  MMC1 DAT4
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO37 = new Designator(1, 5);    // P8.22  MMC1 DAT5
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO38 = new Designator(1, 6);    // P8.3   MMC1 DAT6
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO39 = new Designator(1, 7);    // P8.4   MMC1 DAT7
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO44 = new Designator(1, 12);   // P8.12
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO45 = new Designator(1, 13);   // P8.11
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO46 = new Designator(1, 14);   // P8.16
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO47 = new Designator(1, 15);   // P8.15
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO48 = new Designator(1, 16);   // P9.15
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO49 = new Designator(1, 17);   // P9.23
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO50 = new Designator(1, 18);   // P9.14
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO51 = new Designator(1, 19);   // P9.16
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO60 = new Designator(1, 28);   // P9.12
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO61 = new Designator(1, 29);   // P8.26
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO62 = new Designator(1, 30);   // P8.21  MMC1 CLK
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO63 = new Designator(1, 31);   // P8.20  MMC1 CMD
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO65 = new Designator(2, 1);    // P8.18
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO66 = new Designator(2, 2);    // P8.7
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO67 = new Designator(2, 3);    // P8.8
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO68 = new Designator(2, 4);    // P8.10
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO69 = new Designator(2, 5);    // P8.9
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO70 = new Designator(2, 6);    // P8.45
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO71 = new Designator(2, 7);    // P8.46
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO72 = new Designator(2, 8);    // P8.43
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO73 = new Designator(2, 9);    // P8.44
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO74 = new Designator(2, 10);   // P8.41
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO75 = new Designator(2, 11);   // P8.42
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO76 = new Designator(2, 12);   // P8.39
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO77 = new Designator(2, 13);   // P8.40
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO78 = new Designator(2, 14);   // P8.37  UART5 TXD
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO79 = new Designator(2, 15);   // P8.38  UART5 RXD
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO80 = new Designator(2, 16);   // P8.36
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO81 = new Designator(2, 17);   // P8.34
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO86 = new Designator(2, 22);   // P8.27
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO87 = new Designator(2, 23);   // P8.29
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO88 = new Designator(2, 24);   // P8.28
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO89 = new Designator(2, 25);   // P8.30
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO110 = new Designator(3, 14);  // P9.31  SPI1 SCLK
           /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO111 = new Designator(3, 15);  // P9.29  SPI1 MISO
           /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO112 = new Designator(3, 16);  // P9.30  SPI1 MOSI
           /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO113 = new Designator(3, 17);  // P9.28  SPI1 SS0
           /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO115 = new Designator(3, 19);  // P9.27
           /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO117 = new Designator(3, 21);  // P9.25
    }
}
