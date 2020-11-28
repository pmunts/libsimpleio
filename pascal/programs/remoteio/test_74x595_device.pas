{ Remote I/O 74HC595 Shift Register Device Test }

{ Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.             }
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

PROGRAM test_74x595_device;

USES
  RemoteIO_Client,
  RemoteIO_Client_libusb,
  SPI,
  SPI_Shift_Register,
  SPI_Shift_Register_74HC595;

VAR
  remdev : RemoteIO_Client.Device;
  spidev : SPI.Device;
  regdev : SPI_Shift_Register.Device;

BEGIN
  Writeln;
  Writeln('Remote I/O 74HC595 Shift Register Device Test');
  Writeln;

  { Create objects }

  remdev := RemoteIO_Client_libusb.Create;
  spidev := remdev.SPI(0, SPI_Shift_Register_74HC595.SPI_Clock_Mode, 8,
    SPI_Shift_Register_74HC595.SPI_Clock_Max);
  regdev := SPI_Shift_Register.Device.Create(spidev);

  { Toggle outputs }

  regdev.Write($00);

  REPEAT
    regdev.Write(NOT regdev.Read);
  UNTIL False;
END.
