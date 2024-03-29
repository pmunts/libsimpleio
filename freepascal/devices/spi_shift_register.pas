{ SPI driven shift register device services. }

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

UNIT SPI_Shift_Register;

INTERFACE

  USES
    SPI,
    SysUtils;

  TYPE
    Error = CLASS(Exception);

    Device = CLASS
      CONSTRUCTOR Create(dev : SPI.Device; bytes : Cardinal = 1);

      { Single byte methods }

      FUNCTION Read : Byte;

      PROCEDURE Write(data : Byte);

      { Multibyte methods }

      PROCEDURE Read(VAR data : ARRAY OF Byte);

      PROCEDURE Write(data : ARRAY OF Byte);

      { Return the number of 8-bit stages }

      FUNCTION Bytes : Cardinal;
    PRIVATE
      dev : SPI.Device;
      buf : ARRAY OF Byte;
    END;

IMPLEMENTATION

  CONSTRUCTOR Device.Create(dev : SPI.Device; bytes : Cardinal);

  BEGIN
    { Validate parameters }

    IF bytes = 0 THEN
      RAISE Error.Create('ERROR: bytes parameter is invalid');

    Self.dev := dev;
    SetLength(buf, bytes);
  END;

  { Single byte methods }

  FUNCTION Device.Read : Byte;

  BEGIN
    { Validate parameters }

    IF Length(Self.buf) <> 1 THEN
      RAISE Error.Create('ERROR: Data length mismatch');

    Read := Self.buf[0];
  END;

  PROCEDURE Device.Write(data : byte);

  BEGIN
    { Validate parameters }

    IF Length(Self.buf) <> 1 THEN
      RAISE Error.Create('ERROR: Data length mismatch');

    Self.buf[0] := data;
    Self.dev.Write(Self.buf, Length(Self.buf));
  END;

  { Multibyte methods }

  PROCEDURE Device.Read(VAR data : ARRAY OF Byte);

  VAR
    i : Cardinal;

  BEGIN
    { Validate parameters }

    IF Length(data) <> Length(Self.buf) THEN
      RAISE Error.Create('ERROR: Data length mismatch');

    FOR i := 0 TO Length(Self.buf) - 1 DO
      data[i] := Self.buf[i];
  END;

  PROCEDURE Device.Write(data : ARRAY OF Byte);

  VAR
    i : Cardinal;

  BEGIN
    { Validate parameters }

    IF Length(data) <> Length(Self.buf) THEN
      RAISE Error.Create('ERROR: Data length mismatch');

    { Write data to the shift register(s) }

    FOR i := 0 TO Length(Self.buf) - 1 DO
      Self.buf[i] := data[i];

    Self.dev.Write(Self.buf, Length(Self.buf));
  END;

  { Return the number of 8-bit stages }

  FUNCTION Device.Bytes : Cardinal;

  BEGIN
    Bytes := Length(Self.buf);
  END;

END.
