{ PCA9534 I2C GPIO Expander Device Toggle Test }

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

PROGRAM test_pca9534_device;

USES
  I2C,
  I2C_libsimpleio,
  PCA9534,
  SysUtils;

VAR
  bus : I2C.Bus;
  dev : PCA9534.Device;

BEGIN
  Writeln;
  Writeln('PCA9534 I2C GPIO Expander Device Toggle Test');
  Writeln;

  { Validate parameters }

  IF ParamCount <> 2 THEN
    BEGIN
      Writeln('Usage: test_pca9534_device <bus> <address>');
      Writeln;
      Halt(1);
    END;

  { Create objects }

  bus := I2C_libsimpleio.BusSubclass.Create(ParamStr(1));
  dev := PCA9534.Device.Create(bus, StrToInt(ParamStr(2)));

  { Configure all pins as outputs }

  dev.Write(ConfigurationReg, AllOutputs);
  dev.Write(OutputPortReg, AllOff);

  { Toggle pins }

  REPEAT
    dev.Write(NOT dev.Read);
  UNTIL False;
END.
