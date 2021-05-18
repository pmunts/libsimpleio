{ TH02 Temperature/Humidity Sensor Services }

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

UNIT TH02;

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

      FUNCTION DeviceID : Byte;
    PRIVATE
      mybus  : I2C.Bus;
      myaddr : I2C.Address;

      FUNCTION Read(reg : Byte) : Byte;

      PROCEDURE Write(reg : Byte; data : Byte);

      FUNCTION Sample(what : Byte) : Word;
    END;

IMPLEMENTATION

  CONST

    { TH02 register addresses }

    RegStatus  = $00;
    RegDataH   = $01;
    RegDataL   = $02;
    RegConfig  = $03;
    RegID      = $11;

    { TH02 commands }

    cmdInit    = $00;  { Turn heater off }
    cmdTemp    = $11;
    cmdHumid   = $01;

    { TH02 status masks }

    mskBusy    = $01;

    { TH02 humidity correction coefficients (from the TH02 datasheet) }

    A0 = -4.7844;
    A1 = 0.4008;
    A2 = -0.00393;

    Q0 = 0.1973;
    Q1 = 0.00237;

  CONSTRUCTOR Device.Create(bus : I2C.Bus);

  BEGIN
    Self.mybus  := bus;
    Self.myaddr := $40;

    Self.Write(RegConfig, cmdInit);
  END;

  FUNCTION Device.Read(reg : Byte) : Byte;

  VAR
    cmd  : ARRAY [0 .. 0] OF Byte;
    resp : ARRAY [0 .. 0] OF Byte;

  BEGIN
    IF (reg > RegID) THEN
      RAISE Error.Create('ERROR: Invalid register address');

    IF (reg > RegConfig) AND (reg < RegID) THEN
      RAISE Error.Create('ERROR: Invalid register address');

    cmd[0] := reg;
    Self.mybus.Transaction(Self.myaddr, cmd, Length(cmd), resp, Length(resp));

    Read := resp[0];
  END;

  PROCEDURE Device.Write(reg : Byte; data : Byte);

  VAR
    cmd : ARRAY [0 .. 1] OF Byte;

  BEGIN
    IF (reg > RegID) THEN
      RAISE Error.Create('ERROR: Invalid register address');

    IF (reg > RegConfig) AND (reg < RegID) THEN
      RAISE Error.Create('ERROR: Invalid register address');

    cmd[0] := reg;
    cmd[1] := data;
    Self.mybus.Write(Self.myaddr, cmd, Length(cmd));
  END;

  FUNCTION Device.Sample(what : Byte) : Word;

  VAR
    cmd  : ARRAY [0 .. 0] OF Byte;
    resp : ARRAY [0 .. 1] OF Byte;

  BEGIN
    { Start conversion }

    Self.Write(regConfig, what);

    { Wait for completion }

    REPEAT
    UNTIL (Self.Read(regStatus) AND mskBusy) = 0;

    { Fetch result }

    cmd[0] := regDataH;
    Self.mybus.Transaction(Self.myaddr, cmd, Length(cmd), resp, Length(resp));

    Sample := resp[0]*256 + resp[1];
  END;

  FUNCTION Device.Temperature : Real;

  BEGIN
    Temperature := (Self.Sample(cmdTemp) SHR 2)/32.0 - 50.0;

  END;

  FUNCTION Device.Humidity : Real;

  VAR
    RHvalue  : Real;
    RHlinear : Real;

  BEGIN
    { Get humidity sample }

    RHvalue := (Self.Sample(cmdHumid) SHR 4)/16.0 - 24.0;

    { Perform linearization }

    RHlinear := RHvalue - (RHvalue*RHvalue*A2 + RHvalue*A1 + A0);

    { Perform temperature compensation }

    Humidity := RHlinear + (Self.Temperature - 30.0)*(RHlinear*Q1 + Q0);
  END;

  FUNCTION Device.DeviceID : Byte;

  BEGIN
    DeviceID := Self.Read(RegID);
  END;

END.
