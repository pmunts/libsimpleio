{ Mikroelektronika 7Seg Click Test for PocketBeagle }

{ Copyright (C)2018-2023, Philip Munts dba Munts Technologies.                }
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

PROGRAM test_click_7seg;

USES
  Click_7Seg,
  GPIO,
  RemoteIO_Client,
  RemoteIO_Client_hidapi,
  SPI,
  SPI_Shift_Register_74HC595,
  SysUtils;

VAR
  remdev : RemoteIO_Client.Device;
  spidev : SPI.Device;
  pwmpin : GPIO.Pin;
  rstpin : GPIO.Pin;
  disp   : Click_7Seg.Display;
  n      : Cardinal;

BEGIN
  Writeln;
  Writeln('Mikroelektronika 7Seg Click Test for PocketBeagle');
  Writeln;

  { Create objects }

  remdev := RemoteIO_Client_hidapi.Create;

  spidev := remdev.SPI(0, SPI_Shift_Register_74HC595.SPI_Clock_Mode, 8,
    SPI_Shift_Register_74HC595.SPI_Clock_Max);

  pwmpin := remdev.GPIO(13, GPIO.Output, True);

  rstpin := remdev.GPIO(18, GPIO.Output, True);

  disp   := Click_7Seg.Display.Create(spidev, pwmpin, rstpin);

  { Exercise the display }

  FOR n := 0 TO 99 DO
    BEGIN
      disp.Write(n, True, True, False, 100.0);
      sleep(200);
    END;

  sleep(1000);

  FOR n := 99 DOWNTO 0 DO
    BEGIN
      disp.Write(n, False, False, True, 75.0);
      sleep(200);
    END;

  sleep(1000);

  FOR n := 0 TO 255 DO
    BEGIN
      disp.WriteHex(n, True, True, False, 50.0);
      sleep(200);
    END;

  sleep(1000);

  FOR n := 255 DOWNTO 0 DO
    BEGIN
      disp.WriteHex(n, False, False, True, 25.0);
      sleep(200);
    END;

  sleep(1000);

  disp.WriteSegments($00, $00);
END.
