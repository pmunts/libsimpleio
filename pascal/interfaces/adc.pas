{ Abstract interface for ADC (Analog to Digital Converter) inputs             }

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

UNIT ADC;

INTERFACE

  USES
    SysUtils;

  TYPE
    Error = CLASS(Exception);

    { Abstract interfaces }

    Sample = INTERFACE
      FUNCTION sample : Integer;

      FUNCTION resolution : Cardinal;
    END;

    Voltage = INTERFACE
      FUNCTION voltage : Real;
    END;

    { Classes }

    Input = CLASS(TInterfacedObject, Voltage)
      CONSTRUCTOR Create(input : Sample; reference : Real; gain : Real = 1.0);

      DESTRUCTOR Destroy; OVERRIDE;

      FUNCTION voltage : Real;

    PRIVATE
      input    : Sample;
      stepsize : Real;
    END;

IMPLEMENTATION

  USES
    Math;

  CONSTRUCTOR Input.Create(input : Sample; reference : Real; gain : Real);

  BEGIN
    IF reference = 0.0 THEN
      RAISE Error.Create('ERROR: reference voltage cannot be zero');

    IF gain = 0.0 THEN
      RAISE Error.Create('ERROR: gain cannot be zero');

    Self.input    := input;
    Self.stepsize := reference/intpower(2, input.resolution)/gain;
  END;

  DESTRUCTOR Input.Destroy;

  BEGIN
    FreeAndNil(Self.input);

    INHERITED;
  END;

  FUNCTION Input.Voltage : Real;

  BEGIN
    Voltage := Self.input.sample*Self.stepsize;
  END;

END.
