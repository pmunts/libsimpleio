// Raspberry Pi device definitions

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

namespace IO.Devices
{
  /// <summary>
  /// </summary>
  public static class RaspberryPi
  {
    public static readonly string I2C1  = "/dev/i2c-1";
    public static readonly string SPI00 = "/dev/spidev0.0";
    public static readonly string SPI01 = "/dev/spidev0.1";
    public static readonly string SPI10 = "/dev/spidev1.0";  // Requires a special device tree overlay
    public static readonly string UART0 = "/dev/ttyAMA0";

    // The following GPIO pins are available on all Raspberry Pi Models

    public static readonly Designator GPIO2  = new Designator(0, 2);   // I2C1 SDA
    public static readonly Designator GPIO3  = new Designator(0, 3);   // I2C1 SCL
    public static readonly Designator GPIO4  = new Designator(0, 4);
    public static readonly Designator GPIO7  = new Designator(0, 7);   // SPI0 SS1
    public static readonly Designator GPIO8  = new Designator(0, 8);   // SPI0 SS0
    public static readonly Designator GPIO9  = new Designator(0, 9);   // SPI0 MISO
    public static readonly Designator GPIO10 = new Designator(0, 10);  // SPI0 MOSI
    public static readonly Designator GPIO11 = new Designator(0, 11);  // SPI0 SCLK
    public static readonly Designator GPIO14 = new Designator(0, 14);  // UART0 TXD
    public static readonly Designator GPIO15 = new Designator(0, 15);  // UART0 RXD
    public static readonly Designator GPIO17 = new Designator(0, 17);
    public static readonly Designator GPIO18 = new Designator(0, 18);  // PWM0
    public static readonly Designator GPIO22 = new Designator(0, 22);
    public static readonly Designator GPIO23 = new Designator(0, 23);
    public static readonly Designator GPIO24 = new Designator(0, 24);
    public static readonly Designator GPIO25 = new Designator(0, 25);
    public static readonly Designator GPIO27 = new Designator(0, 27);

    // The following GPIO pins are only available on Raspberry Pi Model
    // B+ and later, with 40-pin expansion header

    public static readonly Designator GPIO5  = new Designator(0, 5);
    public static readonly Designator GPIO6  = new Designator(0, 6);
    public static readonly Designator GPIO12 = new Designator(0, 12);
    public static readonly Designator GPIO13 = new Designator(0, 13);
    public static readonly Designator GPIO16 = new Designator(0, 16);  // SPI1 SS0
    public static readonly Designator GPIO19 = new Designator(0, 19);  // SPI1 MISO, PWM1
    public static readonly Designator GPIO20 = new Designator(0, 20);  // SPI1 MOSI
    public static readonly Designator GPIO21 = new Designator(0, 21);  // SPI1 SCLK
    public static readonly Designator GPIO26 = new Designator(0, 26);
  }
}
