// PocketBeagle device definitions

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

using IO.Objects.libsimpleio.Device;

namespace IO.Objects.Platforms
{
    /// <summary>
    /// This class defines identifiers for the devices provided by the
    /// PocketBeagle hardware platform.
    /// </summary>
    public static class PocketBeagle
    {
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO2 = new Designator(0, 2);     // P1.8   SPI0 SCLK
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO3 = new Designator(0, 3);     // P1.10  SPI0 MISO
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO4 = new Designator(0, 4);     // P1.12  SPI0 MOSI
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO5 = new Designator(0, 5);     // P1.6   SPI0 CS
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO7 = new Designator(0, 7);     // P2.29  SPI1 SCLK
        /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO12 = new Designator(0, 12);   // P1.26  I2C2 SDA
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO13 = new Designator(0, 13);   // P1.28  I2C2 SCL
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO14 = new Designator(0, 14);   // P2.11  I2C1 SDA
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO15 = new Designator(0, 15);   // P2.9   I2C1 SCL
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO19 = new Designator(0, 19);   // P2.31  SPI1 CS
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO20 = new Designator(0, 20);   // P1.20
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO23 = new Designator(0, 23);   // P2.3
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO26 = new Designator(0, 26);   // P1.34
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO27 = new Designator(0, 27);   // P2.19
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO30 = new Designator(0, 30);   // P2.5   RXD4
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO31 = new Designator(0, 31);   // P2.7   TXD4
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO40 = new Designator(1, 8);    // P2.27  SPI1 MISO
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO41 = new Designator(1, 9);    // P2.25  SPI1 MOSI
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO42 = new Designator(1, 10);   // P1.32  RXD0
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO43 = new Designator(1, 11);   // P1.30  TXD0
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO44 = new Designator(1, 12);   // P2.24
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO45 = new Designator(1, 13);   // P2.33
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO46 = new Designator(1, 14);   // P2.22
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO47 = new Designator(1, 15);   // P2.18
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO50 = new Designator(1, 18);   // P2.1
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO52 = new Designator(1, 20);   // P2.10
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO57 = new Designator(1, 25);   // P2.6
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO58 = new Designator(1, 26);   // P2.4
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO59 = new Designator(1, 27);   // P2.2
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO60 = new Designator(1, 28);   // P2.8
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO64 = new Designator(2, 0);    // P2.20
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO65 = new Designator(2, 1);    // P2.17
         /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO86 = new Designator(2, 22);   // P2.35  AIN5 3.3V
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO87 = new Designator(2, 23);   // P1.2   AIN6 3.3V
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO88 = new Designator(2, 24);   // P1.35
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO89 = new Designator(2, 25);   // P1.4
          /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO110 = new Designator(3, 14);  // P1.36
           /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO111 = new Designator(3, 15);  // P1.33
           /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO112 = new Designator(3, 16);  // P2.32
           /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO113 = new Designator(3, 17);  // P2.30
           /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO114 = new Designator(3, 18);  // P1.31
           /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO115 = new Designator(3, 19);  // P2.34
           /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO116 = new Designator(3, 20);  // P2.28
           /// <summary>Legacy GPIO pin designator</summary>
        public static readonly Designator GPIO117 = new Designator(3, 21);  // P1.29
    }
}
