{ DAC (Pulse Width Modulated) output services using libsimpleio               }

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

UNIT DAC_libsimpleio;

INTERFACE

  USES
    libsimpleio,
    DAC;

  TYPE
    Polarities = (ActiveLow, ActiveHigh);

    OutputSubclass = CLASS(TInterfacedObject, DAC.Output)
      CONSTRUCTOR Create
       (desg       : libsimpleio.Designator;
        resolution : Cardinal);

      CONSTRUCTOR Create
       (chip       : Cardinal;
        channel    : Cardinal;
        resolution : Cardinal);

      DESTRUCTOR Destroy; OVERRIDE;

      PROCEDURE Write(sample : Integer);

      PROPERTY sample : Integer WRITE Write;

      FUNCTION resolution : Cardinal;
    PRIVATE
      fd      : Integer;
      numbits : Cardinal;
    END;

IMPLEMENTATION

  USES
    errno,
    libDAC;

  { DAC_libsimpleio.OutputSubclass constructor }

  CONSTRUCTOR OutputSubclass.Create
   (desg       : libsimpleio.Designator;
    resolution : Cardinal);

  VAR
    error  : Integer;

  BEGIN
    libDAC.Open(desg.chip, desg.chan, Self.fd, error);

    IF error <> 0 THEN
      RAISE DAC.Error.Create('ERROR: libDAC.Open() failed, ' +
        errno.strerror(error));
  END;

  CONSTRUCTOR OutputSubclass.Create
   (chip       : Cardinal;
    channel    : Cardinal;
    resolution : Cardinal);

  VAR
    error  : Integer;

  BEGIN
    libDAC.Open(chip, channel, Self.fd, error);

    IF error <> 0 THEN
      RAISE DAC.Error.Create('ERROR: libDAC.Open() failed, ' +
        errno.strerror(error));
  END;

  { DAC_libsimpleio.OutputSubclass destructor }

  DESTRUCTOR OutputSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN
    libDAC.Close(Self.fd, error);
    INHERITED;
  END;

  {  DAC_libsimpleio.OutputSubclass write method }

  PROCEDURE OutputSubclass.Write(sample : Integer);

  VAR
    error  : Integer;

  BEGIN
    libDAC.Write(Self.fd, sample, error);

    IF error <> 0 THEN
      RAISE DAC.Error.Create('ERROR: libDAC.Write() failed, ' +
        errno.strerror(error));
  END;

  { Method implementing DAC.Sample.resolution }

  FUNCTION OutputSubclass.resolution : Cardinal;

  BEGIN
    resolution := Self.numbits;
  END;

END.
