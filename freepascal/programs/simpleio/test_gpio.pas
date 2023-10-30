{ GPIO Toggle Test using libsimpleio }

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

PROGRAM test_gpio;

USES
  GPIO,
  GPIO_libsimpleio;

VAR
  chip  : Integer;
  chan  : Integer;
  GPIO0 : GPIO.Pin;

BEGIN
  Writeln;
  Writeln('GPIO Toggle Test using libsimpleio');
  Writeln;

  write('Enter GPIO chip number:    ');
  readln(chip);

  write('Enter GPIO channel number: ');
  readln(chan);

  { Configure GPIO output object }

  GPIO0 := GPIO_libsimpleio.PinSubclass.Create(chip, chan, GPIO.Output);

  { Toogle the GPIO output }

  REPEAT
    GPIO0.state := NOT GPIO0.state;
  UNTIL False;
END.
