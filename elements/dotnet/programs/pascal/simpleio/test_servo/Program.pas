{ Servo Output Test using libsimpleio }

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

namespace test_servo;

  procedure Main(args: array of String);

  begin
    writeLn;
    writeLn('Servo Output Test using libsimpleio');
    writeLn;

    { Create a servo output object }

    var desg : IO.Objects.SimpleIO.Device.Designator;

    write('PWM chip number?     ');
    desg.chip := Integer.Parse(readLn());

    write('PWM channel number?  ');
    desg.chan := Integer.Parse(readLn());

    var outp := new IO.Objects.SimpleIO.Servo.Output(desg, 50);

    { Sweep the servo position }

    loop begin
      for position : Integer := -100 to 100 do
        begin
          outp.position := position/100.0;
          RemObjects.Elements.RTL.Thread.Sleep(25);
        end;

      for position : Integer := 100 downto -100 do
        begin
          outp.position := position/100.0;
          RemObjects.Elements.RTL.Thread.Sleep(25);
        end;
    end;
  end;

end.
