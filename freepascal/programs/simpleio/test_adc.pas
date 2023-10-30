{ Linux Simple I/O Library ADC (Analog to Digital Converter) input test       }

{ Copyright (C)2019-2023, Philip Munts dba Munts Technologies.                }
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

PROGRAM test_adc;

USES
  SysUtils,
  ADC,
  ADC_libsimpleio;

VAR
  chip       : Cardinal;
  channel    : Cardinal;
  resolution : Cardinal;
  ADC0       : ADC.Input;

BEGIN
  Writeln;
  Writeln('ADC Input Test using libsimpleio');
  Writeln;

  Write('Enter ADC chip number:    ');
  Readln(chip);

  Write('Enter ADC channel number: ');
  Readln(channel);

  Write('Enter ADC resolution:     ');
  Readln(resolution);

  Writeln;

  { Create a ADC input object }

  ADC0 := ADC_libsimpleio.InputSubclass.Create(chip, channel, resolution);

  { Sample analog input }

  REPEAT
    Writeln('Sample: ', ADC0.sample);
    Sleep(1000);
  UNTIL False;
END.
