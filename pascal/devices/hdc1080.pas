{ HDC1080 Temperature/Humidity Sensor Services }

{ Copyright (C)2018, Philip Munts, President, Munts AM Corp.                  }
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

UNIT HDC1080;

INTERFACE

  USES
    I2C,
    SysUtils;

  TYPE
    Error = CLASS(Exception);
 
    Device = CLASS
      CONSTRUCTOR Create(bus : I2C.Bus);

      FUNCTION Temperature : Real;

      FUNCTION Humidity : Real;

      FUNCTION ManufacturerID : Word;

      FUNCTION DeviceID : Word;
    PRIVATE
      mybus  : I2C.Bus;
      myaddr : I2C.Address;

      FUNCTION Read(reg : Byte) : Word;

      PROCEDURE Write(reg : Byte; data : Word);
    END;

IMPLEMENTATION

  CONST
    RegTemperature        = $00;
    RegHumidity           = $01;
    RegConfiguration      = $02;
    RegSerialNumberFirst  = $FB;
    RegSerialNumberMiddle = $FC;
    RegSerialNumberLast   = $FD;
    RegManufacturerID     = $FE;
    RegDeviceID           = $FF;
    
  CONSTRUCTOR Device.Create(bus : I2C.Bus);

  BEGIN
    Self.mybus  := bus;
    Self.myaddr := $40;

    { Issue software reset }

    Self.Write(RegConfiguration, $8000);
    Sleep(100);
    
    { Heater off, acquire temp or humidity, 14 bit resolutions }

    Self.Write(RegConfiguration, $0000);
  END;

  FUNCTION Device.Read(reg : Byte) : Word;

  VAR
    delayus : Cardinal;
    cmd     : ARRAY [0 .. 0] OF Byte;
    resp    : ARRAY [0 .. 1] OF Byte;

  BEGIN
    IF (reg > RegConfiguration) AND (reg < RegSerialNumberFirst) THEN
      RAISE Error.Create('ERROR: Invalid register address');

    IF (reg = RegTemperature) OR (reg = RegHumidity) THEN
      delayus := 10000
    ELSE
      delayus := 0;

    cmd[0] := reg;
    Self.mybus.Transaction(Self.myaddr, cmd, Length(cmd), resp, Length(resp),
      delayus);

    Read := (resp[0] SHL 8) + resp[1];
  END;

  PROCEDURE Device.Write(reg : Byte; data : Word);

  VAR
    cmd : ARRAY [0 .. 2] OF Byte;

  BEGIN
    IF (reg > RegConfiguration) AND (reg < RegSerialNumberFirst) THEN
      RAISE Error.Create('ERROR: Invalid register address');

    cmd[0] := reg;
    cmd[1] := data DIV 256;
    cmd[2] := data MOD 256;

    Self.mybus.Write(Self.myaddr, cmd, Length(cmd));
  END;

  FUNCTION Device.Temperature : Real;

  BEGIN
    Temperature := Real(Self.Read(RegTemperature))/65536.0*165.0 - 40.0;
  END;

  FUNCTION Device.Humidity : Real;

  BEGIN
    Humidity := Real(Self.Read(RegHumidity))/65536.0*100.0;
  END;

  FUNCTION Device.ManufacturerID : Word;

  BEGIN
    ManufacturerID := Self.Read(RegManufacturerID);
  END;

  FUNCTION Device.DeviceID : Word;

  BEGIN
    DeviceID := Self.Read(RegDeviceID);
  END;

END.
