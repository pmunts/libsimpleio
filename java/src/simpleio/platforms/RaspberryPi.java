// Copyright (C)2026, Philip Munts dba Munts Technologies.
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

package com.munts.libsimpleio.platforms;

import com.munts.libsimpleio.objects.Designator;

public final class RaspberryPi
{
  private RaspberryPi()
  {
  }

  // Raspberry Pi boards don't have a built-in ADC (Analog to Digital
  // Converter) subsystem, so the following analog input designators are
  // placeholders for the first IIO (Industrial I/O) ADC device, which is
  // often on a HAT like the Pi 3 Click Shield or an expansion board like
  // the MUNTS-0018 Raspberry Pi Tutorial I/O Board.

  public static final Designator AIN0   = new Designator(0,  0);
  public static final Designator AIN1   = new Designator(0,  1);
  public static final Designator AIN2   = new Designator(0,  2);
  public static final Designator AIN3   = new Designator(0,  3);
  public static final Designator AIN4   = new Designator(0,  4);
  public static final Designator AIN5   = new Designator(0,  5);
  public static final Designator AIN6   = new Designator(0,  6);
  public static final Designator AIN7   = new Designator(0,  7);

  public static final Designator GPIO2  = new Designator(0,  2);  // Pin 3  I2C1 SDA
  public static final Designator GPIO3  = new Designator(0,  3);  // Pin 5  I2C1 SCL
  public static final Designator GPIO4  = new Designator(0,  4);  // Pin 7
  public static final Designator GPIO5  = new Designator(0,  5);  // Pin 29
  public static final Designator GPIO6  = new Designator(0,  6);  // Pin 30
  public static final Designator GPIO7  = new Designator(0,  7);  // Pin 26 SPI0 SS1
  public static final Designator GPIO8  = new Designator(0,  8);  // Pin 24 SPI0 SS0
  public static final Designator GPIO9  = new Designator(0,  9);  // Pin 21 SPI0 MISO
  public static final Designator GPIO10 = new Designator(0, 10);  // Pin 19 SPI0 MOSI
  public static final Designator GPIO11 = new Designator(0, 11);  // Pin 23 SPI0 SCLK
  public static final Designator GPIO12 = new Designator(0, 12);  // Pin 32 PWM0
  public static final Designator GPIO13 = new Designator(0, 13);  // Pin 33 PWM1
  public static final Designator GPIO14 = new Designator(0, 14);  // Pin 8  UART0 TXD
  public static final Designator GPIO15 = new Designator(0, 15);  // Pin 10 UART0 RXD
  public static final Designator GPIO16 = new Designator(0, 16);  // Pin 36 SPI1 SS2
  public static final Designator GPIO17 = new Designator(0, 17);  // Pin 11 SPI1 SS1
  public static final Designator GPIO18 = new Designator(0, 18);  // Pin 12 PWM0 SPI1 SS0
  public static final Designator GPIO19 = new Designator(0, 19);  // Pin 35 PWM1 SPI1 MISO
  public static final Designator GPIO20 = new Designator(0, 20);  // Pin 38 SPI1 MOSI
  public static final Designator GPIO21 = new Designator(0, 21);  // Pin 40 SPI1 SCLK
  public static final Designator GPIO22 = new Designator(0, 22);  // Pin 15
  public static final Designator GPIO23 = new Designator(0, 23);  // Pin 16
  public static final Designator GPIO24 = new Designator(0, 24);  // Pin 18
  public static final Designator GPIO25 = new Designator(0, 25);  // Pin 22
  public static final Designator GPIO26 = new Designator(0, 26);  // Pin 37
  public static final Designator GPIO27 = new Designator(0, 27);  // Pin 13

  public static final Designator PWM0   = new Designator(0,  0);  // Pin 12 or pin 32
  public static final Designator PWM1   = new Designator(0,  1);  // Pin 33 or pin 35
}
