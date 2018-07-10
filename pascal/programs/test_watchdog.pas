{ Watchdog timer device (using libsimpleio) test                              }

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

PROGRAM test_watchdog(input, output);

USES
  sysutils,
  Watchdog,
  Watchdog_libsimpleio;

VAR
  wd : Watchdog.Timer;
  i  : Integer;

BEGIN
  writeln;
  writeln('Watchdog Timer Test using libsimpleio');
  writeln;

  { Create watchdog timer device instance }

  wd := Watchdog_libsimpleio.TimerSubclass.Create;

  { Display the default watchdog timeout period }

  writeln('Default timeout: ', wd.GetTimeout);

  { Change the watchdog timeout period }

  wd.SetTimeout(5);

  writeln('New timeout:     ', wd.GetTimeout);
  writeln;

  { Kick the dog for 5 seconds }

  FOR i := 1 TO 5 DO
    BEGIN
      writeln('Kick the dog...');
      wd.Kick;
      Sleep(1000);
    END;

  writeln;

  { Stop kicking the dog }

  FOR i := 1 TO 10 DO
    BEGIN
      writeln('Don''t kick the dog...');
      Sleep(1000);
    END;
END.
