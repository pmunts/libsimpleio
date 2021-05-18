{ SPI driven shift register GPIO pin services. }

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

UNIT SPI_Shift_Register_GPIO;

INTERFACE

  USES
    GPIO,
    SPI_Shift_Register;

  TYPE
    PinSubclass = CLASS(TInterfacedObject, GPIO.Pin)
      CONSTRUCTOR Create
       (dev   : SPI_Shift_Register.Device;
        num   : Cardinal;
        state : Boolean = False);

      FUNCTION Read : Boolean;

      PROCEDURE Write(state : Boolean);

      PROPERTY state : Boolean READ Read WRITE Write;
    PRIVATE
      mydev  : SPI_Shift_Register.Device;
      mybyte : Cardinal;
      mymask : Byte;
      mybuf  : ARRAY OF Byte;
    END;

IMPLEMENTATION

      CONSTRUCTOR PinSubclass.Create
       (dev   : SPI_Shift_Register.Device;
        num   : Cardinal;
        state : Boolean = False);

      BEGIN
        Self.mydev  := dev;
        Self.mybyte := num DIV 8;
        Self.mymask := 1 SHL (num MOD 8);
        SetLength(Self.mybuf, dev.Bytes);

        Self.Write(state);
      END;

      FUNCTION PinSubclass.Read : Boolean;

      BEGIN
        Self.mydev.Read(Self.mybuf);
        Read := (Self.mybuf[Self.mybyte] AND Self.mymask) <> 0;
      END;

      PROCEDURE PinSubclass.Write(state : Boolean);

      BEGIN
        Self.mydev.Read(Self.mybuf);

        IF state THEN
          Self.mybuf[Self.mybyte] := Self.mybuf[Self.mybyte] OR Self.mymask
        ELSE
          Self.mybuf[Self.mybyte] := Self.mybuf[Self.mybyte] AND NOT Self.mymask;

        Self.mydev.Write(Self.mybuf);
      END;

END.
