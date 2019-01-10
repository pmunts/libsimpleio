{ Analog voltage services (both input and output)                             }

{ Copyright (C)2019, Philip Munts, President, Munts AM Corp.                  }
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

UNIT Voltage;

INTERFACE

  USES
    ADC,
    DAC;

  TYPE
    Input = INTERFACE
      FUNCTION voltage : Real;
    END;

    InputClass = CLASS(TInterfacedObject, Input)
      CONSTRUCTOR Create(inp : ADC.Input; Vref : Real; gain : Real = 1.0);

      FUNCTION voltage : Real;
    PRIVATE
      inp : ADC.Input;
      stepsize : Real;
    END;

IMPLEMENTATION

  USES
    Math;

  CONSTRUCTOR InputClass.Create(inp : ADC.Input; Vref : Real; gain : Real);

  BEGIN
    Self.inp      := inp;
    Self.stepsize := Vref/intpower(2, inp.resolution)/gain;
  END;

  FUNCTION InputClass.Voltage : Real;

  BEGIN
    Voltage := Self.inp.sample*Self.stepsize;
  END;

END.
