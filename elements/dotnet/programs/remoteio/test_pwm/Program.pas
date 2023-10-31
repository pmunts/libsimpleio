{ PWM Output Test using libremoteio }

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

namespace test_pwm;

  procedure Main(args: array of String);

  begin
    writeLn;
    writeLn('PWM Output Test using libremoteio');
    writeLn;

    // Create PWM output object

    write('PWM channel number?  ');
    var num := Integer.Parse(readLn());

    write('PWM pulse frequency? ');
    var freq := Integer.Parse(readLn());

    var remdev := new IO.Objects.RemoteIO.Device();
    var outp := remdev.PWM_Create(num, freq);

    { Sweep the PWM output duty cycle }

    loop begin
      for duty : Integer := 0 to 100 do
        begin
          outp.dutycycle := duty;
          RemObjects.Elements.RTL.Thread.Sleep(50);
        end;

      for duty : Integer := 100 downto 0 do
        begin
          outp.dutycycle := duty;
          RemObjects.Elements.RTL.Thread.Sleep(50);
        end;
    end;
  end;
end.
