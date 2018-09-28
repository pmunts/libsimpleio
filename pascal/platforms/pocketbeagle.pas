{ PocketBeagle Device Definitions }

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

UNIT PocketBeagle;

INTERFACE

  USES
    GPIO_libsimpleio;

  CONST
    GPIO2   : Designator = (chip : 0; line :  2);  { P1.8   SPI0 SCLK }
    GPIO3   : Designator = (chip : 0; line :  3);  { P1.10  SPI0 MISO }
    GPIO4   : Designator = (chip : 0; line :  4);  { P1.12  SPI0 MOSI }
    GPIO5   : Designator = (chip : 0; line :  5);  { P1.6   SPI0 CS   }
    GPIO7   : Designator = (chip : 0; line :  7);  { P2.29  SPI1 SCLK }
    GPIO12  : Designator = (chip : 0; line : 12);  { P1.26  I2C2 SDA  }
    GPIO13  : Designator = (chip : 0; line : 13);  { P1.28  I2C2 SCL  }
    GPIO14  : Designator = (chip : 0; line : 14);  { P2.11  I2C1 SDA  }
    GPIO15  : Designator = (chip : 0; line : 15);  { P2.9   I2C1 SCL  }
    GPIO19  : Designator = (chip : 0; line : 19);  { P2.31  SPI1 CS   }
    GPIO20  : Designator = (chip : 0; line : 20);  { P1.20 }
    GPIO23  : Designator = (chip : 0; line : 23);  { P2.3  }
    GPIO26  : Designator = (chip : 0; line : 26);  { P1.34 }
    GPIO27  : Designator = (chip : 0; line : 27);  { P2.19 }
    GPIO30  : Designator = (chip : 0; line : 30);  { P2.5   RXD4 }
    GPIO31  : Designator = (chip : 0; line : 31);  { P2.7   TXD4 }
    GPIO40  : Designator = (chip : 1; line :  8);  { P2.27  SPI1 MISO }
    GPIO41  : Designator = (chip : 1; line :  9);  { P2.25  SPI1 MOSI }
    GPIO42  : Designator = (chip : 1; line : 10);  { P1.32  RXD0 }
    GPIO43  : Designator = (chip : 1; line : 11);  { P1.30  TXD0 }
    GPIO44  : Designator = (chip : 1; line : 12);  { P2.24 }
    GPIO45  : Designator = (chip : 1; line : 13);  { P2.33 }
    GPIO46  : Designator = (chip : 1; line : 14);  { P2.22 }
    GPIO47  : Designator = (chip : 1; line : 15);  { P2.18 }
    GPIO50  : Designator = (chip : 1; line : 18);  { P2.1  }
    GPIO52  : Designator = (chip : 1; line : 20);  { P2.10 }
    GPIO57  : Designator = (chip : 1; line : 25);  { P2.6  }
    GPIO58  : Designator = (chip : 1; line : 26);  { P2.4  }
    GPIO59  : Designator = (chip : 1; line : 27);  { P2.2  }
    GPIO60  : Designator = (chip : 1; line : 28);  { P2.8  }
    GPIO64  : Designator = (chip : 2; line :  0);  { P2.20 }
    GPIO65  : Designator = (chip : 2; line :  1);  { P2.17 }
    GPIO86  : Designator = (chip : 2; line : 22);  { P2.35  AIN5 3.3V }
    GPIO87  : Designator = (chip : 2; line : 23);  { P1.2   AIN6 3.3V }
    GPIO88  : Designator = (chip : 2; line : 24);  { P1.35 }
    GPIO89  : Designator = (chip : 2; line : 25);  { P1.4  }
    GPIO110 : Designator = (chip : 3; line : 14);  { P1.36 }
    GPIO111 : Designator = (chip : 3; line : 15);  { P1.33 }
    GPIO112 : Designator = (chip : 3; line : 16);  { P2.32 }
    GPIO113 : Designator = (chip : 3; line : 17);  { P2.30 }
    GPIO114 : Designator = (chip : 3; line : 18);  { P1.31 }
    GPIO115 : Designator = (chip : 3; line : 19);  { P2.34 }
    GPIO116 : Designator = (chip : 3; line : 20);  { P2.28 }
    GPIO117 : Designator = (chip : 3; line : 21);  { P1.29 }

IMPLEMENTATION

END.
