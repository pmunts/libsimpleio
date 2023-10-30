{ Linux Simple I/O Library PWM (Pulse Width Modulated) output test            }

{ Copyright (C)2016-2023, Philip Munts dba Munts Technologies.                }
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

PROGRAM test_pwm;

USES
  SysUtils,
  PWM,
  PWM_libsimpleio;

VAR
  chip    : Cardinal;
  channel : Cardinal;
  freq    : Cardinal;
  output  : PWM.Output;
  n       : Integer;

BEGIN
  Writeln;
  Writeln('PWM Output Test using libsimpleio');
  Writeln;

  Write('Enter PWM chip number:     ');
  Readln(chip);

  Write('Enter PWM channel number:  ');
  Readln(channel);

  Write('Enter PWM pulse frequency: ');
  Readln(freq);

  { Create a PWM output object }

  output := PWM_libsimpleio.OutputSubclass.Create(chip, channel, freq);

  { Sweep the pulse width back and forth }

  FOR n := 0 TO 100 DO
    BEGIN
      output.dutycycle := n;
      Sleep(50);
    END;

  FOR n := 100 DOWNTO 0 DO
    BEGIN
      output.dutycycle := n;
      Sleep(50);
    END;
END.
