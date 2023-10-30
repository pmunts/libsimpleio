{ LED Toggle Test using PWM Output }

{ Copyright (C)2021-2023, Philip Munts dba Munts Technologies.                }
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
  GPIO,
  GPIO_PWM,
  PWM,
  PWM_libsimpleio;

VAR
  chip    : Cardinal;
  channel : Cardinal;
  freq    : Cardinal;
  duty    : Real;
  pwmout  : PWM.Output;
  LED     : GPIO.Pin;

BEGIN
  Writeln;
  Writeln('LED Toggle Test using PWM Output');
  Writeln;

  Write('Enter PWM chip number:       ');
  Readln(chip);

  Write('Enter PWM channel number:    ');
  Readln(channel);

  Write('Enter PWM pulse frequency:   ');
  Readln(freq);

  Write('Enter PWM output duty cycle: ');
  Readln(duty);

  { Create a PWM output object }

  pwmout := PWM_libsimpleio.OutputSubclass.Create(chip, channel, freq);

  { Create a GPIO pin object }

  LED := GPIO_PWM.PinSubclass.Create(pwmout, false, duty);

  { Flash the LED }

  REPEAT
    LED.state := NOT LED.state;
    Sleep(500);
  UNTIL False;
END.
