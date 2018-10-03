{ PCA8574 I2C GPIO Expander GPIO Pin Toggle Test }

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

PROGRAM test_pca8574_gpio;

USES
  GPIO,
  I2C,
  I2C_libsimpleio,
  PCA8574,
  PCA8574_GPIO,
  SysUtils;

VAR
  bus : I2C.Bus;
  dev : PCA8574.Device;
  pin : GPIO.Pin;

BEGIN
  Writeln;
  Writeln('PCA8574 I2C GPIO Expander GPIO Pin Toggle Test');
  Writeln;

  { Validate parameters }

  IF ParamCount <> 2 THEN
    BEGIN
      Writeln('Usage: test_pca8574_device <bus> <address>');
      Writeln;
      Halt(1);
    END;

  { Create objects }

  bus := I2C_libsimpleio.BusSubclass.Create(ParamStr(1));
  dev := PCA8574.Device.Create(bus, StrToInt(ParamStr(2)));
  pin := PCA8574_GPIO.PinSubclass.Create(dev, 0, GPIO.Output);

  { Toggle pin }

  REPEAT
    pin.State := NOT pin.State;
  UNTIL False;
END.
