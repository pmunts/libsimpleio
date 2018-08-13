{ BeagleBone Device Definitions }

{ Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.             }
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

UNIT BeagleBone;

INTERFACE

  USES
    GPIO_libsimpleio;

  CONST
    GPIO2   : Designator = (chip : 0; line :  2);  { P9.22  UART2 RXD }
    GPIO3   : Designator = (chip : 0; line :  3);  { P9.21  UART2 TXD }
    GPIO4   : Designator = (chip : 0; line :  4);  { P9.18 }
    GPIO5   : Designator = (chip : 0; line :  5);  { P9.17 }
    GPIO7   : Designator = (chip : 0; line :  7);  { P9.42  SPI1 SS1  }
    GPIO8   : Designator = (chip : 0; line :  8);  { P8.35 }
    GPIO9   : Designator = (chip : 0; line :  9);  { P8.33 }
    GPIO10  : Designator = (chip : 0; line : 10);  { P8.31 }
    GPIO11  : Designator = (chip : 0; line : 11);  { P8.32 }
    GPIO12  : Designator = (chip : 0; line : 12);  { P9.20  I2C2 SDA  }
    GPIO13  : Designator = (chip : 0; line : 13);  { P9.19  I2C2 SCL  }
    GPIO14  : Designator = (chip : 0; line : 14);  { P9.26  UART1 RXD }
    GPIO15  : Designator = (chip : 0; line : 15);  { P9.24  UART1 TXD }
    GPIO20  : Designator = (chip : 0; line : 20);  { P9.41 }
    GPIO22  : Designator = (chip : 0; line : 22);  { P8.19 }
    GPIO23  : Designator = (chip : 0; line : 23);  { P8.13 }
    GPIO26  : Designator = (chip : 0; line : 26);  { P8.14 }
    GPIO27  : Designator = (chip : 0; line : 27);  { P8.17 }
    GPIO30  : Designator = (chip : 0; line : 30);  { P9.11  UART4 RXD }
    GPIO31  : Designator = (chip : 0; line : 31);  { P9.13  UART4 TXD }
    GPIO32  : Designator = (chip : 1; line :  0);  { P8.25  MMC1 DAT0 }
    GPIO33  : Designator = (chip : 1; line :  1);  { P8.24  MMC1 DAT1 }
    GPIO34  : Designator = (chip : 1; line :  2);  { P8.5   MMC1 DAT2 }
    GPIO35  : Designator = (chip : 1; line :  3);  { P8.6   MMC1 DAT3 }
    GPIO36  : Designator = (chip : 1; line :  4);  { P8.23  MMC1 DAT4 }
    GPIO37  : Designator = (chip : 1; line :  5);  { P8.22  MMC1 DAT5 }
    GPIO38  : Designator = (chip : 1; line :  6);  { P8.3   MMC1 DAT6 }
    GPIO39  : Designator = (chip : 1; line :  7);  { P8.4   MMC1 DAT7 }
    GPIO44  : Designator = (chip : 1; line : 12);  { P8.12 }
    GPIO45  : Designator = (chip : 1; line : 13);  { P8.11 }
    GPIO46  : Designator = (chip : 1; line : 14);  { P8.16 }
    GPIO47  : Designator = (chip : 1; line : 15);  { P8.15 }
    GPIO48  : Designator = (chip : 1; line : 16);  { P9.15 }
    GPIO49  : Designator = (chip : 1; line : 17);  { P9.23 }
    GPIO50  : Designator = (chip : 1; line : 18);  { P9.14 }
    GPIO51  : Designator = (chip : 1; line : 19);  { P9.16 }
    GPIO60  : Designator = (chip : 1; line : 28);  { P9.12 }
    GPIO61  : Designator = (chip : 1; line : 29);  { P8.26 }
    GPIO62  : Designator = (chip : 1; line : 30);  { P8.21  MMC1 CLK  }
    GPIO63  : Designator = (chip : 1; line : 31);  { P8.20  MMC1 CMD  }
    GPIO65  : Designator = (chip : 2; line :  1);  { P8.18 }
    GPIO66  : Designator = (chip : 2; line :  2);  { P8.7  }
    GPIO67  : Designator = (chip : 2; line :  3);  { P8.8  }
    GPIO68  : Designator = (chip : 2; line :  4);  { P8.10 }
    GPIO69  : Designator = (chip : 2; line :  5);  { P8.9  }
    GPIO70  : Designator = (chip : 2; line :  6);  { P8.45 }
    GPIO71  : Designator = (chip : 2; line :  7);  { P8.46 }
    GPIO72  : Designator = (chip : 2; line :  8);  { P8.43 }
    GPIO73  : Designator = (chip : 2; line :  9);  { P8.44 }
    GPIO74  : Designator = (chip : 2; line : 10);  { P8.41 }
    GPIO75  : Designator = (chip : 2; line : 11);  { P8.42 }
    GPIO76  : Designator = (chip : 2; line : 12);  { P8.39 }
    GPIO77  : Designator = (chip : 2; line : 13);  { P8.40 }
    GPIO78  : Designator = (chip : 2; line : 14);  { P8.37  UART5 TXD }
    GPIO79  : Designator = (chip : 2; line : 15);  { P8.38  UART5 RXD }
    GPIO80  : Designator = (chip : 2; line : 16);  { P8.36 }
    GPIO81  : Designator = (chip : 2; line : 17);  { P8.34 }
    GPIO86  : Designator = (chip : 2; line : 22);  { P8.27 }
    GPIO87  : Designator = (chip : 2; line : 23);  { P8.29 }
    GPIO88  : Designator = (chip : 2; line : 24);  { P8.28 }
    GPIO89  : Designator = (chip : 2; line : 25);  { P8.30 }
    GPIO110 : Designator = (chip : 3; line : 14);  { P9.31  SPI1 SCLK }
    GPIO111 : Designator = (chip : 3; line : 15);  { P9.29  SPI1 MISO }
    GPIO112 : Designator = (chip : 3; line : 16);  { P9.30  SPI1 MOSI }
    GPIO113 : Designator = (chip : 3; line : 17);  { P9.28  SPI1 SS0 }
    GPIO115 : Designator = (chip : 3; line : 19);  { P9.27 }
    GPIO117 : Designator = (chip : 3; line : 21);  { P9.25 }

IMPLEMENTATION

END.
