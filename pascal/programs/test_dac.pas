{ Linux Simple I/O Library DAC (Digital to Analog Converter) output test      }

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

PROGRAM test_dac;

USES
  SysUtils,
  DAC,
  DAC_libsimpleio;

VAR
  chip       : Cardinal;
  channel    : Cardinal;
  resolution : Cardinal;
  DAC0       : DAC.Output;
  n          : Integer;

BEGIN
  Writeln;
  Writeln('DAC Output Test using libsimpleio');
  Writeln;

  Write('Enter DAC chip number:    ');
  Readln(chip);

  Write('Enter DAC channel number: ');
  Readln(channel);

  Write('Enter DAC resolution:     ');
  Readln(resolution);

  { Create a DAC output object }

  DAC0 := DAC_libsimpleio.OutputSubclass.Create(chip, channel, resolution);

  { Generate sawtooth pattern }

  REPEAT
    FOR n := 0 TO 4095 DO
      DAC0.sample := n;
  UNTIL False;
END.
