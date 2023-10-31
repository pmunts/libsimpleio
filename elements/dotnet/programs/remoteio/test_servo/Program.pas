{ Servo Output Test using libremoteio }

{ Copyright (C)2020-2023, Philip Munts dba Munts Technologies.                }
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
    writeLn('Servo Output Test using libremoteio');
    writeLn;

    // Create PWM output object

    write('PWM channel number?  ');
    var num := Integer.Parse(readLn());
    var remdev := new IO.Objects.RemoteIO.Device();
    var outp := new IO.Objects.Servo.PWM.Output(remdev.PWM_Create(num, 50), 50);

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
