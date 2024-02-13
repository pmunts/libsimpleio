{ Raspberry Pi 1 to 3 Peripheral Subsystem Designator Definitions }

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

namespace IO.Objects.SimpleIO.Platforms.RaspberryPi;

  { Raspberry Pi boards don't have a built-in ADC (Analog to Digital    }
  { Converter) subsystem, so the following analog input designators are }
  { placeholders for the first IIO (Industrial I/O) ADC device.         }

  const AIN0   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  0);
  const AIN1   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  1);
  const AIN2   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  2);
  const AIN3   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  3);
  const AIN4   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  4);
  const AIN5   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  5);
  const AIN6   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  6);
  const AIN7   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  7);

  const GPIO2  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  2);  { I2C1 SDA }
  const GPIO3  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  3);  { I2C1 SCL }
  const GPIO4  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  4);
  const GPIO5  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  5);
  const GPIO6  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  6);
  const GPIO7  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  7);  { SPI0 SS1 }
  const GPIO8  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  8);  { SPI0 SS0 }
  const GPIO9  : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  9);  { SPI0 MISO }
  const GPIO10 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 10);  { SPI0 MOSI }
  const GPIO11 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 11);  { SPI0 SCLK }
  const GPIO12 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 12);  { PWM0 }
  const GPIO13 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 13);  { PWM1 }
  const GPIO14 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 14);  { UART0 TXD }
  const GPIO15 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 15);  { UART0 RXD }
  const GPIO16 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 16);  { SPI1 SS2 }
  const GPIO17 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 17);  { SPI1 SS1 }
  const GPIO18 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 18);  { PWM0, SPI1 SS0  }
  const GPIO19 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 19);  { PWM1, SPI1 MISO }
  const GPIO20 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 20);  { SPI1 MOSI }
  const GPIO21 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 21);  { SPI1 SCLK }
  const GPIO22 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 22);
  const GPIO23 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 23);
  const GPIO24 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 24);
  const GPIO25 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 25);
  const GPIO26 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 26);
  const GPIO27 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel : 27);

  { All of the following subsystems require device tree overlays }

  const I2C1   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  1);  { GPIO2/GPIO3 }

  const PWM0   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  0);  { GPIO12 or GPIO18 }
  const PWM1   : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  1);  { GPIO13 or GPIO19 }

  const SPI0_0 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  0);  { GPIO8,  GPIO9,  GPIO10; and GPIO11 }
  const SPI0_1 : IO.Objects.SimpleIO.Resources.Designator = (chip : 0; channel :  1);  { GPIO7,  GPIO9,  GPIO10; and GPIO11 }
  const SPI1_0 : IO.Objects.SimpleIO.Resources.Designator = (chip : 1; channel :  0);  { GPIO18, GPIO19, GPIO20; and GPIO21 }
  const SPI1_1 : IO.Objects.SimpleIO.Resources.Designator = (chip : 1; channel :  1);  { GPIO17, GPIO19, GPIO20; and GPIO21 }
  const SPI1_2 : IO.Objects.SimpleIO.Resources.Designator = (chip : 1; channel :  2);  { GPIO16, GPIO19, GPIO20; and GPIO21 }

end.
