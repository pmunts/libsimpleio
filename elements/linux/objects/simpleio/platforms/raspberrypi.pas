{ Raspberry Pi Peripheral Subsystem Designator Definitions }

{ Copyright (C)2024, Philip Munts dba Munts Technologies.                     }
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

{$HIDE H7}  { Suppress "...is assigned to but never read messages" }

namespace IO.Objects.SimpleIO.Platforms;

  type RaspberryPi = public static class

    { The following analog inputs are just placeholders, as Raspberry Pi boards }
    { do not contain A/D converters.                                            }

    public const AIN0 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 0);
    public const AIN1 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 1);
    public const AIN2 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 2);
    public const AIN3 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 3);
    public const AIN4 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 4);
    public const AIN5 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 5);
    public const AIN6 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 6);
    public const AIN7 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 7);

    { The following GPIO pins are available on all Raspberry Pi Models. }

    public const GPIO2  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  2);  { aka I2C1 SDA }
    public const GPIO3  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  3);  { aka I2C1 SCL }
    public const GPIO4  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  4);
    public const GPIO7  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  7);  { aka SPI0 SS1 }
    public const GPIO8  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  8);  { aka SPI0 SS0 }
    public const GPIO9  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  9);  { aka SPI0 MISO }
    public const GPIO10 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 10);  { aka SPI0 MOSI }
    public const GPIO11 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 11);  { aka SPI0 SCLK }
    public const GPIO14 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 14);  { aka UART0 TXD }
    public const GPIO15 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 15);  { aka UART0 RXD }
    public const GPIO17 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 17);  { aka SPI1 SS1 }
    public const GPIO18 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 18);  { aka PWMchip : 0; SPI1 SS0  }
    public const GPIO22 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 22);
    public const GPIO23 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 23);
    public const GPIO24 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 24);
    public const GPIO25 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 25);
    public const GPIO27 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 27);

    { The following GPIO pins are only available on Raspberry Pi Model }
    { B+ and later, with 40-pin expansion headers.                     }

    public const GPIO5  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  5);
    public const GPIO6  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  6);
    public const GPIO12 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 12);  { aka PWM0 }
    public const GPIO13 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 13);  { aka PWM1 }
    public const GPIO16 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 16);  { aka SPI1 SS2 }
    public const GPIO19 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 19);  { aka SPI1 MISO, PWM1 }
    public const GPIO20 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 20);  { aka SPI1 MOSI }
    public const GPIO21 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 21);  { aka SPI1 SCLK }
    public const GPIO26 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 26);

    { All of the following subsystems require the proper device tree overlays }

    public const I2C1   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  1);  { on GPIO2 and GPIO3 }

    public const PWM0   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  0);  { on GPIO12 or GPIO18 }
    public const PWM1   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  1);  { on GPIO13 or GPIO19 }

    public const SPI0_0 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  0);  { on GPIO8, GPIO9, GPIO1chip : 0; and GPIO11 }
    public const SPI0_1 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  1);  { on GPIO7, GPIO9, GPIO1chip : 0; and GPIO11 }

    public const SPI1_0 : IO.Objects.SimpleIO.Resources.Designator = (chip : 1; channel :  0);  { on GPIO18, GPIO19, GPIO2chip : 0; and GPIO21 }
    public const SPI1_1 : IO.Objects.SimpleIO.Resources.Designator = (chip : 1; channel :  1);  { on GPIO17, GPIO19, GPIO2chip : 0; and GPIO21 }
    public const SPI1_2 : IO.Objects.SimpleIO.Resources.Designator = (chip : 1; channel :  2);  { on GPIO16, GPIO19, GPIO2chip : 0; and GPIO21 }
  end;

end.
