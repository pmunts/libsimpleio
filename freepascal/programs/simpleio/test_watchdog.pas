{ Watchdog timer device (using libsimpleio) test                              }

{ Copyright (C)2017-2023, Philip Munts dba Munts Technologies.                }
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

PROGRAM test_watchdog;

USES
  SysUtils,
  Watchdog,
  Watchdog_libsimpleio;

VAR
  wd : Watchdog.Timer;
  i  : Integer;

BEGIN
  Writeln;
  Writeln('Watchdog Timer Test using libsimpleio');
  Writeln;

  { Create watchdog timer device instance }

  wd := Watchdog_libsimpleio.TimerSubclass.Create;

  { Display the default watchdog timeout period }

  Writeln('Default timeout: ', wd.GetTimeout);

  { Change the watchdog timeout period }

  wd.SetTimeout(5);

  Writeln('New timeout:     ', wd.GetTimeout);
  Writeln;

  { Kick the dog for 5 seconds }

  FOR i := 1 TO 5 DO
    BEGIN
      Writeln('Kick the dog...');
      wd.Kick;
      Sleep(1000);
    END;

  Writeln;

  { Stop kicking the dog }

  FOR i := 1 TO 10 DO
    BEGIN
      Writeln('Don''t kick the dog...');
      Sleep(1000);
    END;
END.
