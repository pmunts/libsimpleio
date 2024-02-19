{ Copyright (C)2024, Philip Munts dba Munts Technologies.                }
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

{ Motor driver output services using libsimpleio }

namespace IO.Objects.Motor;

interface

  type Output = public class(IO.Interfaces.Motor.OutputInterface)
    public constructor
     (pwmout   : not nullable IO.Interfaces.PWM.OutputInterface;
      dirout   : not nullable IO.Interfaces.GPIO.PinInterface;
      vel      : IO.Interfaces.Motor.Velocity :=
        IO.Interfaces.Motor.STOPPED_VELOCITY);

    public constructor
     (pwmcw    : not nullable IO.Interfaces.PWM.OutputInterface;
      pwmccw   : not nullable IO.Interfaces.PWM.OutputInterface;
      vel      : IO.Interfaces.Motor.Velocity :=
        IO.Interfaces.Motor.STOPPED_VELOCITY);

    private function GetVelocity : IO.Interfaces.Motor.Velocity;

    private procedure SetVelocity(vel : IO.Interfaces.Motor.Velocity);

    public property velocity: IO.Interfaces.Motor.Velocity
      read GetVelocity write SetVelocity;

    private mypwm1 : IO.Interfaces.PWM.OutputInterface;
    private mypwm2 : IO.Interfaces.PWM.OutputInterface;
    private mydir  : IO.Interfaces.GPIO.PinInterface;
    private myvel  : IO.Interfaces.Motor.Velocity;  { normalized }
  end;

implementation

  constructor Output
   (pwmout : not nullable IO.Interfaces.PWM.OutputInterface;
    dirout : not nullable IO.Interfaces.GPIO.PinInterface;
    vel    : IO.Interfaces.Motor.Velocity :=
      IO.Interfaces.Motor.STOPPED_VELOCITY);

  begin
    self.mypwm1   := pwmout;
    self.mypwm2   := NIL;
    self.mydir    := dirout;
    self.velocity := vel;
  end;

  constructor Output
   (pwmcw  : not nullable IO.Interfaces.PWM.OutputInterface;
    pwmccw : not nullable IO.Interfaces.PWM.OutputInterface;
    vel    : IO.Interfaces.Motor.Velocity :=
      IO.Interfaces.Motor.STOPPED_VELOCITY);

  begin
    self.mypwm1   := pwmcw;
    self.mypwm2   := pwmccw;
    self.mydir    := NIL;
    self.velocity := vel;
  end;

  function Output.GetVelocity : IO.Interfaces.Motor.Velocity;

  begin
    GetVelocity := myvel;
  end;

  procedure Output.SetVelocity(vel : IO.Interfaces.Motor.Velocity);

  begin
    if self.mypwm2 = NIL then
      begin
        self.mydir.state      := (vel > 0.0);
        self.mypwm1.dutycycle := Math.Abs(vel)*100.0;
      end
    else if vel > 0.0 then
      begin
        self.mypwm2.dutycycle := 0.0;
        self.mypwm1.dutycycle := Math.Abs(vel)*100.0;
      end
    else if vel < 0.0 then
      begin
        self.mypwm1.dutycycle := 0.0;
        self.mypwm2.dutycycle := Math.Abs(vel)*100.0;
      end
    else
      begin
        self.mypwm1.dutycycle := 0.0;
        self.mypwm2.dutycycle := 0.0;
      end;

    self.myvel := vel;
  end;

end.
