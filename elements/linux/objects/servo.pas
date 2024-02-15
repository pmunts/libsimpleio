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

namespace IO.Objects.Servo;

interface

  { Define a generic servo output class }

  type Output = public class(IO.Interfaces.Servo.OutputInterface)
    public constructor
     (pwmout   : not nullable IO.Interfaces.PWM.OutputInterface;
      pos      : IO.Interfaces.Servo.Position :=
        IO.Interfaces.Servo.NEUTRAL_POSITION;
      minpulse : Double := 1.0;   { Conventional RC servos require a pulse }
      maxpulse : Double := 2.0);  { width between 1.0 and 2.0 milliseconds }

    private function GetPosition : IO.Interfaces.Servo.Position;

    private procedure SetPosition(pos : IO.Interfaces.Servo.Position);

    public property position: IO.Interfaces.Servo.Position
      read GetPosition write SetPosition;

    private mypwmout   : IO.Interfaces.PWM.OutputInterface;
    private myswing    : Double;  { milliseconds }
    private mymidpoint : Double;  { milliseconds }
    private myposition : IO.Interfaces.Servo.Position;  { normalized }
  end;

implementation

  constructor Output
   (pwmout   : not nullable IO.Interfaces.PWM.OutputInterface;
    pos      : IO.Interfaces.Servo.Position :=
      IO.Interfaces.Servo.NEUTRAL_POSITION;
    minpulse : Double := 1.0;   { Conventional RC servos require a pulse }
    maxpulse : Double := 2.0);  { width between 1.0 and 2.0 milliseconds }

  begin;
    { Validate parameters }

    if maxpulse > 1E3/pwmout.frequency then
      raise new Exception('PWM pulse frequency is too high.');

    if (pos < IO.Interfaces.Servo.MINIMUM_POSITION) or
       (pos > IO.Interfaces.Servo.MAXIMUM_POSITION) then
      raise new Exception('Position parameter is out of range.');

    self.mypwmout   := pwmout;
    self.myswing    := pwmout.frequency/10.0*(maxpulse - minpulse)/2.0;
    self.mymidpoint := pwmout.frequency/10.0*minpulse + self.myswing;
    self.position   := pos;
  end;

  function Output.GetPosition : IO.Interfaces.Servo.Position;

  begin
    GetPosition := myposition;
  end;

  procedure Output.SetPosition(pos: IO.Interfaces.Servo.Position);

  begin
    { Validate parameters }

    if (pos < IO.Interfaces.Servo.MINIMUM_POSITION) or
       (pos > IO.Interfaces.Servo.MAXIMUM_POSITION) then
      raise new Exception('Position parameter is out of range.');

    self.mypwmout.dutycycle := self.mymidpoint + self.myswing*pos;
    self.myposition         := pos;
  end;

end.
