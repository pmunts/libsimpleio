{ Raspberry Pi Device Definitions }

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

UNIT RaspberryPi;

INTERFACE

  USES
    GPIO_libsimpleio;

  { The following GPIO pins are available on all Raspberry Pi Models }

  CONST
    GPIO2  : Designator = (chip : 0; line :  2);  { I2C1 SDA }
    GPIO3  : Designator = (chip : 0; line :  3);  { I2C1 SCL }
    GPIO4  : Designator = (chip : 0; line :  4);
    GPIO7  : Designator = (chip : 0; line :  7);  { SPI0 SS1 }
    GPIO8  : Designator = (chip : 0; line :  8);  { SPI0 SS0 }
    GPIO9  : Designator = (chip : 0; line :  9);  { SPI0 MISO }
    GPIO10 : Designator = (chip : 0; line : 10);  { SPI0 MOSI }
    GPIO11 : Designator = (chip : 0; line : 11);  { SPI0 SCLK }
    GPIO14 : Designator = (chip : 0; line : 14);  { UART0 TXD }
    GPIO15 : Designator = (chip : 0; line : 15);  { UART0 RXD }
    GPIO17 : Designator = (chip : 0; line : 17);
    GPIO18 : Designator = (chip : 0; line : 18);  { PWM0 }
    GPIO22 : Designator = (chip : 0; line : 22);
    GPIO23 : Designator = (chip : 0; line : 23);
    GPIO24 : Designator = (chip : 0; line : 24);
    GPIO25 : Designator = (chip : 0; line : 25);
    GPIO27 : Designator = (chip : 0; line : 27);

  { The following GPIO pins are only available on Raspberry Pi Model }
  { B+ and later, line : with 40-pin expansion headers                      }

    GPIO5  : Designator = (chip : 0; line :  5);
    GPIO6  : Designator = (chip : 0; line :  6);
    GPIO12 : Designator = (chip : 0; line : 12);
    GPIO13 : Designator = (chip : 0; line : 13);
    GPIO16 : Designator = (chip : 0; line : 16);  { SPI1 SS0 }
    GPIO19 : Designator = (chip : 0; line : 19);  { SPI1 MISO, PWM1 }
    GPIO20 : Designator = (chip : 0; line : 20);  { SPI1 MOSI }
    GPIO21 : Designator = (chip : 0; line : 21);  { SPI1 SCLK }
    GPIO26 : Designator = (chip : 0; line : 26);

IMPLEMENTATION

END.
