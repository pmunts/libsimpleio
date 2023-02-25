{ GPIO Pin Toggle Test using libsimpleio }

{ Copyright (C)2019-2020, Philip Munts, President, Munts AM Corp.             }
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

namespace test_gpio;

  procedure Main(args : array of String);

  begin
    writeLn;
    writeLn('GPIO Pin Toggle Test using libsimpleio');
    writeLn;

    write('GPIO chip number?    ');
    var chip : Int32 := Int32.Parse(readLn());

    write('GPIO channel number? ');
    var chan : Int32 := Int32.Parse(readLn());

    var outp : IO.Interfaces.GPIO.Pin;

    try
      outp := new IO.Objects.SimpleIO.GPIO.Pin(chip, chan,
        IO.Interfaces.GPIO.Direction.Output, False);

    except
      on E : Exception do
        begin
          writeLn('ERROR: Cannot configure GPIO pin');
          writeLn(E.Message);
          exit;
        end;
    end;

    repeat
      try
        outp.state := not outp.state;
      except
        on E : Exception do
          begin
            writeLn('ERROR: Cannot write to GPIO pin');
            writeLn(E.Message);
            exit;
          end;
      end;
    until false;
  end;

end.
