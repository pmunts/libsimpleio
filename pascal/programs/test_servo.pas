{ Linux Simple I/O Library servo output test                                  }

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

PROGRAM test_servo;

USES
  SysUtils,
  Servo,
  Servo_libsimpleio;

VAR
  chip    : Cardinal;
  channel : Cardinal;
  S       : Servo.Output;
  n       : Integer;

BEGIN
  writeln;
  writeln('Servo Output Test using libsimpleio');
  writeln;

  write('Enter chip number:    ');
  readln(chip);

  write('Enter channel number: ');
  readln(channel);

  { Create some servo output objects }

  S := Servo_libsimpleio.OutputSubclass.Create(chip, channel, 50);

  { Sweep the pulse width back and forth }

  FOR n := -100 TO 100 DO
    BEGIN
      S.position := n/100.0;
      Sleep(50);
    END;

  FOR n := 100 DOWNTO -100 DO
    BEGIN
      S.position := n/100.0;
      Sleep(50);
    END;
END.
