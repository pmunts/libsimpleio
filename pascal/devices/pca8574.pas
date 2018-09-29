{ MAX7328/MAX7329/PCA8574/PCA9670/PCA9672/PCA9674/PCF8574 Device Services }

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

UNIT PCA8574;

INTERFACE

  USES
    I2C;

  TYPE
    Device = CLASS
      CONSTRUCTOR Create(bus : I2C.Bus; addr : I2C.Address);

      FUNCTION Read : Byte;

      PROCEDURE Write(b : Byte);

      FUNCTION Latch : Byte;

    PRIVATE
      mybus   : I2C.Bus;
      myaddr  : I2C.Address;
      mylatch : Byte;
    END;

IMPLEMENTATION

  CONSTRUCTOR Device.Create(bus : I2C.Bus; addr : I2C.Address);

  BEGIN
    Self.mybus  := bus;
    Self.myaddr := addr;
    Self.Write($FF);
  END;

  { Read from PCA8574 }

  FUNCTION Device.Read : Byte;

  VAR
    buf : ARRAY [0 .. 0] OF Byte;

  BEGIN
    Self.mybus.Read(Self.myaddr, buf, 1);
    Read := buf[0];
  END;

  { Write to PCA8574 }

  PROCEDURE Device.Write(b : Byte);

  VAR
    buf : ARRAY [0 .. 0] OF Byte;

  BEGIN
    buf[0] := b;
    Self.mybus.Write(Self.myaddr, buf, 1);
    Self.mylatch := b;
  END;

  { Fetch last written value }

  FUNCTION Device.Latch : Byte;

  BEGIN
    Latch := Self.mylatch;
  END;

END.
