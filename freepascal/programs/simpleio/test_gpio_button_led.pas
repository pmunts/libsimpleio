{ GPIO Button and LED Test using libsimpleio }

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

PROGRAM test_gpio_button_led;

USES
  GPIO,
  GPIO_libsimpleio;

VAR
  button   : GPIO.Pin;
  LED      : GPIO.Pin;
  oldstate : Boolean;
  newstate : Boolean;

BEGIN
  Writeln('GPIO Button and LED Test using libsimpleio');
  Writeln;

  { Configure the button input and LED output }

  button := GPIO_libsimpleio.PinSubclass.Create(0, 6, GPIO.Input);
  LED := GPIO_libsimpleio.PinSubclass.Create(0, 26, GPIO.Output);

  { Force initial state detection }

  oldstate := NOT button.state;

  { Process state transitions }

  REPEAT
    newstate := button.state;

    IF newstate <> oldstate THEN
      BEGIN
        CASE newstate OF
          True  : Writeln('PRESSED');
          False : Writeln('RELEASED');
        END;

        LED.state := newstate;
        oldstate := newstate;
      END;
  UNTIL False;
END.
