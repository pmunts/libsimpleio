{ Raspberry Pi 4 Device Definitions }

{ Copyright (C)2016-2024, Philip Munts dba Munts Technologies.                }
{                                                                             }
{ Redistribution and use in source and binary forms, with or without          }
{ modification, are permitted provided that the following conditions are met: }
{                                                                             }
{ * Redistributions of source code must retain the above copyright notice,    }
{   this list of conditions and the following disclaimer.                     }
{                                                                             }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" }
{ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   }
{ IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  }
{ ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   }
{ LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         }
{ CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        }
{ SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    }
{ INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     }
{ CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     }
{ ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  }
{ POSSIBILITY OF SUCH DAMAGE.                                                 }

UNIT RaspberryPi4;

INTERFACE

  USES
    libsimpleio;

  CONST
    { Raspberry Pi boards don't have a built-in ADC (Analog to Digital    }
    { Converter) subsystem, so the following analog input designators are }
    { placeholders for the first IIO (Industrial I/O) ADC device.         }

    AIN0   : Designator = (chip : 0; chan :  0);
    AIN1   : Designator = (chip : 0; chan :  1);
    AIN2   : Designator = (chip : 0; chan :  1);
    AIN3   : Designator = (chip : 0; chan :  1);
    AIN4   : Designator = (chip : 0; chan :  1);
    AIN5   : Designator = (chip : 0; chan :  1);
    AIN6   : Designator = (chip : 0; chan :  1);
    AIN7   : Designator = (chip : 0; chan :  1);

    GPIO2  : Designator = (chip : 0; chan :  2);  { I2C1 SDA }
    GPIO3  : Designator = (chip : 0; chan :  3);  { I2C1 SCL }
    GPIO4  : Designator = (chip : 0; chan :  4);
    GPIO5  : Designator = (chip : 0; chan :  5);
    GPIO6  : Designator = (chip : 0; chan :  6);
    GPIO7  : Designator = (chip : 0; chan :  7);  { SPI0 SS1 }
    GPIO8  : Designator = (chip : 0; chan :  8);  { SPI0 SS0 }
    GPIO9  : Designator = (chip : 0; chan :  9);  { SPI0 MISO }
    GPIO10 : Designator = (chip : 0; chan : 10);  { SPI0 MOSI }
    GPIO11 : Designator = (chip : 0; chan : 11);  { SPI0 SCLK }
    GPIO12 : Designator = (chip : 0; chan : 12);  { PWM0 }
    GPIO13 : Designator = (chip : 0; chan : 13);  { PWM1 }
    GPIO14 : Designator = (chip : 0; chan : 14);  { UART0 TXD }
    GPIO15 : Designator = (chip : 0; chan : 15);  { UART0 RXD }
    GPIO16 : Designator = (chip : 0; chan : 16);  { SPI1 SS2 }
    GPIO17 : Designator = (chip : 0; chan : 17);  { SPI1 SS1 }
    GPIO18 : Designator = (chip : 0; chan : 18);  { PWM0, SPI1 SS0 }
    GPIO19 : Designator = (chip : 0; chan : 19);  { PWM1, SPI1 MISO }
    GPIO20 : Designator = (chip : 0; chan : 20);  { SPI1 MOSI }
    GPIO21 : Designator = (chip : 0; chan : 21);  { SPI1 SCLK }
    GPIO22 : Designator = (chip : 0; chan : 22);
    GPIO23 : Designator = (chip : 0; chan : 23);
    GPIO24 : Designator = (chip : 0; chan : 24);
    GPIO25 : Designator = (chip : 0; chan : 25);
    GPIO27 : Designator = (chip : 0; chan : 27);
    GPIO26 : Designator = (chip : 0; chan : 26);

    { All of the following subsystems require device tree overlays }

    I2C1   : Designator = (chip : 0; chan :  1);  { GPIO2/GPIO3 }

    { The Raspberry Pi 4 has additional I2C bus controllers, which can be }
    { enabled by device tree overlays i2c3, i2c4, i2c5, or i2c6.          }

    I2C3   : Designator = (chip : 0; chan :  3);  { GPIO2/GPIO3   or GPIO4/GPIO5 }
    I2C4   : Designator = (chip : 0; chan :  4);  { GPIO6/GPIO7   or GPIO8/GPIO9 }
    I2C5   : Designator = (chip : 0; chan :  5);  { GPIO10/GPIO11 or GPIO12/GPIO13 }
    I2C6   : Designator = (chip : 0; chan :  6);  { GPIO0/GPIO1   or GPIO22/GPIO23 }

    PWM0   : Designator = (chip : 0; chan :  0);  { GPIO12 or GPIO18 }
    PWM1   : Designator = (chip : 0; chan :  1);  { GPIO13 or GPIO19 }

    SPI0_0 : Designator = (chip : 0; chan :  0);  { GPIO8,  GPIO9,  GPIO10, and GPIO11 }
    SPI0_1 : Designator = (chip : 0; chan :  1);  { GPIO7,  GPIO9,  GPIO10, and GPIO11 }
    SPI1_0 : Designator = (chip : 1; chan :  0);  { GPIO18, GPIO19, GPIO20, and GPIO21 }
    SPI1_1 : Designator = (chip : 1; chan :  1);  { GPIO17, GPIO19, GPIO20, and GPIO21 }
    SPI1_2 : Designator = (chip : 1; chan :  2);  { GPIO16, GPIO19, GPIO20, and GPIO21 }

IMPLEMENTATION

END.
