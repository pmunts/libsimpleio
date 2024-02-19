{ Motor Test using libsimpleio }

{ Copyright (C)2024, Philip Munts dba Munts Technologies.                     }
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

namespace test_motor1;

  procedure Main(args: array of String);

  begin
    var pwm_desg  : IO.Objects.SimpleIO.Resources.Designator;
    var dir_desg  : IO.Objects.SimpleIO.Resources.Designator;
    var freq      : Cardinal;
    var pwm_out   : IO.Interfaces.PWM.OutputInterface;
    var dir_out   : IO.Interfaces.GPIO.PinInterface;
    var outp      : IO.Interfaces.Motor.OutputInterface;
    writeLn;
    writeLn('Motor Test using libsimpleio');
    writeLn;

    { Get test parameters from the operator }

    try
      pwm_desg  := IO.Objects.SimpleIO.Resources.GetDesignator2('Enter PWM ');

      write('Enter PWM  frequency:      ');
      freq := Cardinal.Parse(readLn);

      dir_desg := IO.Objects.SimpleIO.Resources.GetDesignator2('Enter GPIO');
      writeLn;
    except
      on E : Exception do
        begin
          writeLn('ERROR: Illegal input');
          writeLn(E.Message);
          exit;
        end;
    end;

    { Configure the motor speed PWM output }

    try
      pwm_out := new IO.Objects.SimpleIO.PWM.Output(pwm_desg, freq);
    except
      on E : Exception do
        begin
          writeLn('ERROR: Cannot configure speed PWM output');
          writeLn(E.Message);
          exit;
        end;
    end;

    { Configure the motor direction GPIO output }

    try
      dir_out := new IO.Objects.SimpleIO.GPIO.Pin(dir_desg,
        IO.Interfaces.GPIO.Direction.Output);
    except
      on E : Exception do
        begin
          writeLn('ERROR: Cannot configure direction GPIO output');
          writeLn(E.Message);
          exit;
        end;
    end;

    { Create motor driver object instance }

    outp := new IO.Objects.Motor.Output(pwm_out, dir_out);

    { Sweep the motor speed up and down }

    for vel := 0 to 100 do begin
      outp.velocity := vel/100.0;
      Thread.Sleep(50);  { milliseconds }
    end;

    for vel := 100 downto 0 do begin
      outp.velocity := vel/100.0;
      Thread.Sleep(50);  { milliseconds }
    end;
  
    for vel := 0 downto -100 do begin
      outp.velocity := vel/100.0;
      Thread.Sleep(50);  { milliseconds }
    end;

    for vel := -100 to 0 do begin
      outp.velocity := vel/100.0;
      Thread.Sleep(50);  { milliseconds }
    end;
  end;

end.
