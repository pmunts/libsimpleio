{ PWM Test using libsimpleio }

{ Copyright (C)2019-2024, Philip Munts dba Munts Technologies.                }
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

namespace test_pwm;

  procedure Main(args: array of String);

  begin
    var desg : IO.Objects.SimpleIO.Resources.Designator;
    var freq : Cardinal;
    var outp : IO.Interfaces.PWM.OutputInterface;

    writeLn;
    writeLn('PWM Test using libsimpleio');
    writeLn;

    { Get test parameters from the operator }

    try
      desg := IO.Objects.SimpleIO.Resources.GetDesignator2('Enter PWM');

      write('Enter PWM frequency:      ');
      freq := Cardinal.Parse(readLn);
      writeLn;
    except
      on E : Exception do
        begin
          writeLn('ERROR: Illegal input');
          writeLn(E.Message);
          exit;
        end;
    end;

    { Configure the PWM output }

    try
      outp := new IO.Objects.SimpleIO.PWM.Output(desg, freq);
    except
      on E : Exception do
        begin
          writeLn('ERROR: Cannot configure PWM output');
          writeLn(E.Message);
          exit;
        end;
    end;

    { Sweep PWM output dutycycle back and forth }

    for duty := 0 to 100 do begin
      outp.dutycycle := duty;
      Thread.Sleep(50);  { milliseconds }
    end;

    for duty := 100 downto 0 do begin
      outp.dutycycle := duty;
      Thread.Sleep(50);  { milliseconds }
    end;
  end;

end.
