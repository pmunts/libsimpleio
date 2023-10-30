{ TH02 Temperature/Humidity Sensor Test }

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

PROGRAM test_th02;

USES
  TH02,
  I2C,
  I2C_libsimpleio,
  SysUtils;

VAR
  sensor : TH02.Device;

BEGIN
  Writeln;
  Writeln('TH02 Temperature/Humidity Sensor Test');
  Writeln;

  { Validate parameters }

  IF ParamCount <> 1 THEN
    BEGIN
      Writeln('Usage: test_th02 <bus>');
      Writeln;
      Halt(1);
    END;

  { Create sensor object }

  sensor :=
    TH02.Device.Create(I2C_libsimpleio.BusSubclass.Create(ParamStr(1)));

  { Display sensor identification }

  Writeln('Device ID: $', IntToHex(sensor.DeviceID, 2));
  Writeln;

  { Display temperature and humidity }

  REPEAT
    Writeln('Temperature: ', sensor.Temperature : 1 : 1, 'C  Humidity: ',
      sensor.Humidity : 1 : 1, '%');

    Sleep(1000);
  UNTIL False;
END.
