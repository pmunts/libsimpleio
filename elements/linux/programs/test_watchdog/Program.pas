{ Watchdog timer device (using libsimpleio) test }

{ Copyright (C)2020, Philip Munts, President, Munts AM Corp.                  }
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

namespace test_watchdog;

  procedure Main(args: array of String);

  begin
    writeLn;
    writeLn('Watchdog Timer Test using libsimpleio');
    writeLn;

    { Create watchdog timer device instance }

    var wd : IO.Interfaces.Watchdog.Timer :=
      new IO.Objects.libsimpleio.Watchdog.Timer;

    { Display the default watchdog timeout period }

    writeLn('Default timeout: ' + wd.GetTimeout.ToString);

    { Change the watchdog timeout period }

    wd.SetTimeout(5);

    writeLn('New timeout:     ' + wd.GetTimeout.ToString);
    writeLn;

    { Kick the dog for 5 seconds }

    var i  : Cardinal;

    for i := 1 to 5 do
      begin
        writeLn('Kick the dog...');
        wd.Kick;
        rtl.Sleep(1);
      end;

    writeLn;

    { Stop kicking the dog }

    for i := 1 to 10 do
      begin
        writeLn('Don''t kick the dog...');
        rtl.Sleep(1);
      end;
  end;

end.
