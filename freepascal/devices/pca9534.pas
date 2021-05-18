{ PCA9534 I2C GPIO Expander device services                                   }

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

UNIT PCA9534;

INTERFACE

  USES
    I2C,
    SysUtils;

  TYPE
    Error = CLASS(Exception);

    RegisterAddress = 0 .. 3;

    Device = CLASS
      CONSTRUCTOR Create
       (bus    : I2C.Bus;
        adr    : I2C.Address;
        config : Byte = $FF;
        states : Byte = $00);

      { Read from a PCA9534 register }

      FUNCTION Read
       (reg  : RegisterAddress) : Byte;

      { Write to a PCA9534 register }

      PROCEDURE Write
       (reg  : RegisterAddress;
        data : Byte);

      { Read from PCA9534 input register }

      FUNCTION Read : Byte;

      { Write to PCA9534 output register }

      PROCEDURE Write
       (data : Byte);

      { Fetch last value written to the configuration register }

      FUNCTION Config : Byte;

      { Fetch last value written to the output port register }

      FUNCTION Latch : Byte;

    PRIVATE
      mybus : I2C.Bus;
      myadr : I2C.Address;
      mycfg : Byte;
      mylat : Byte;
    END;

  CONST
    InputPortReg     : RegisterAddress = 0;
    OutputPortReg    : RegisterAddress = 1;
    InputPolarityReg : RegisterAddress = 2;
    ConfigurationReg : RegisterAddress = 3;

    AllInputs        : Byte = $FF;
    AllOutputs       : Byte = $00;
    AllNormal        : Byte = $00;  { Normal input polarity }
    AllOff           : Byte = $00;  { All outputs low }

IMPLEMENTATION

  CONSTRUCTOR Device.Create
   (bus    : I2C.Bus;
    adr    : I2C.Address;
    config : Byte;
    states : Byte);

  BEGIN
    Self.mybus := bus;
    Self.myadr := adr;
    Self.Write(ConfigurationReg, config);
    Self.Write(InputPolarityReg, AllNormal);
    Self.Write(OutputPortReg, states);
  END;

  { Read from a PCA9534 register }

  FUNCTION Device.Read
   (reg  : RegisterAddress) : Byte;

  VAR
    cmd  : ARRAY [0 .. 0] OF Byte;
    resp : ARRAY [0 .. 0] OF Byte;

  BEGIN
    cmd[0] := reg;
    Self.mybus.Transaction(Self.myadr, cmd, Length(cmd), resp, Length(resp));
    Read := resp[0];
  END;

  { Write to a PCA9534 register }

  PROCEDURE Device.Write
   (reg  : RegisterAddress;
    data : Byte);

  VAR
    cmd : ARRAY [0 .. 1] OF Byte;

  BEGIN
    IF reg = InputPortReg THEN
      RAISE Error.Create('ERROR: Cannot write to input port register');

    cmd[0] := reg;
    cmd[1] := data;
    Self.mybus.Write(Self.myadr, cmd, Length(cmd));

    IF reg = ConfigurationReg THEN
      Self.mycfg := data
    ELSE IF reg = OutputPortReg THEN
      Self.mylat := data;
  END;

  { Read from PCA9534 input register }

  FUNCTION Device.Read : Byte;

  BEGIN
    Read := Self.Read(InputPortReg);
  END;

  { Write to PCA9534 output register }

  PROCEDURE Device.Write(data : Byte);

  BEGIN
    Self.Write(OutputPortReg, data);
  END;

  { Fetch last value written to the configuration register }


  FUNCTION Device.Config : Byte;

  BEGIN
    Config := Self.mycfg;
  END;

  { Fetch last value written to the output port register }

  FUNCTION Device.Latch : Byte;

  BEGIN
    Latch := Self.mylat;
  END;

END.
