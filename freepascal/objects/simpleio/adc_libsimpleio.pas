{ Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.             }
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

UNIT ADC_libsimpleio;

INTERFACE

  USES
    libsimpleio,
    ADC;

  TYPE
    InputSubclass = CLASS(TInterfacedObject, ADC.Input)
      CONSTRUCTOR Create
       (desg       : libsimpleio.Designator;
        resolution : Cardinal);

      CONSTRUCTOR Create
       (chip       : Cardinal;
        channel    : Cardinal;
        resolution : Cardinal);

      DESTRUCTOR Destroy; OVERRIDE;

      FUNCTION sample : Integer;

      FUNCTION resolution : Cardinal;
    PRIVATE
      fd       : Integer;
      numbits  : Cardinal;
    END;

IMPLEMENTATION

  USES
    Errors,
    libADC;

  CONSTRUCTOR InputSubclass.Create
   (desg       : libsimpleio.Designator;
    resolution : Cardinal);

  VAR
    error : Integer;

  BEGIN
    libADC.Open(desg.chip, desg.chan, Self.fd, error);

    IF error <> 0 THEN
      RAISE ADC.Error.Create('ERROR: libADC.Open() failed, ' +
        StrError(error));

    Self.numbits := resolution;
  END;

  CONSTRUCTOR InputSubclass.Create
   (chip       : Cardinal;
    channel    : Cardinal;
    resolution : Cardinal);

  VAR
    error : Integer;

  BEGIN
    libADC.Open(chip, channel, Self.fd, error);

    IF error <> 0 THEN
      RAISE ADC.Error.Create('ERROR: libADC.Open() failed, ' +
        StrError(error));

    Self.numbits := resolution;
  END;

  DESTRUCTOR InputSubclass.Destroy;

  VAR
    error : Integer;

  BEGIN
    libADC.Close(Self.fd, error);
    INHERITED;
  END;

  { Method implementing ADC.Input.sample }

  FUNCTION InputSubclass.sample : Integer;

  VAR
    data   : Integer;
    error  : Integer;

  BEGIN
    libADC.Read(Self.fd, data, error);

    IF error <> 0 THEN
      RAISE ADC.Error.Create('ERROR: libADC.Read() failed, ' +
        StrError(error));

    sample := data;
  END;

  { Method implementing ADC.Input.resolution }

  FUNCTION InputSubclass.resolution : Cardinal;

  BEGIN
    resolution := Self.numbits;
  END;

END.
