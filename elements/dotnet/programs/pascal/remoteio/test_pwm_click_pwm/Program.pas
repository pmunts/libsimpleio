{ Mikroelektronika PWM Click PWM Output Test                                  }

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

namespace test_pwm_click_pwm;

  procedure Main(args: array of String);

  begin
    writeLn;
    writeLn('Mikroelektronika PWM Click PWM Output Test');
    writeLn;

    write('Socket number?       ');
    var socket := Integer.Parse(readLn());

    write('Channel number?      ');
    var channel := Integer.Parse(readLn());

    write('PWM pulse frequency? ');
    var freq := Integer.Parse(readLn());

    var board := new IO.Devices.ClickBoards.RemoteIO.PWM.Board(socket, freq);
    var outp := board.PWM(channel);

    loop begin
      for d : Integer := 0 to 2000 do
        outp.dutycycle := d/20.0;

      for d : Integer := 2000 downto 0 do
        outp.dutycycle := d/20.0;
    end;
  end;

end.
