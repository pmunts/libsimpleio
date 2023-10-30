{ Linux Simple I/O Library servo output test                                  }

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

PROGRAM test_servo_pwm;

USES
  PWM,
  PWM_libsimpleio,
  SysUtils,
  Servo,
  Servo_PWM;

VAR
  chip     : Cardinal;
  channel  : Cardinal;
  pwmout   : PWM.Output;
  servoout : Servo.Output;
  n        : Integer;

BEGIN
  Writeln;
  Writeln('Servo Output Test using libsimpleio');
  Writeln;

  Write('Enter PWM chip number:    ');
  Readln(chip);

  Write('Enter PWM channel number: ');
  Readln(channel);

  { Create a PWM output object }

  pwmout := PWM_libsimpleio.OutputSubclass.Create(chip, channel, 50);

  { Create a servo output object }

  servoout := Servo_PWM.OutputSubclass.Create(pwmout);

  { Sweep the pulse width back and forth }

  FOR n := -100 TO 100 DO
    BEGIN
      servoout.position := n/100.0;
      Sleep(50);
    END;

  FOR n := 100 DOWNTO -100 DO
    BEGIN
      servoout.position := n/100.0;
      Sleep(50);
    END;
END.
