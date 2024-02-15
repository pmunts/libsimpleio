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

{ Implement PWM output services using libsimpleio }

namespace IO.Objects.SimpleIO.PWM;

interface

  type Polarities = (ActiveLow, ActiveHigh);

  type Output = public class(IO.Interfaces.PWM.OutputInterface)
    public constructor
     (desg     : IO.Objects.SimpleIO.Resources.Designator;
      freq     : Cardinal;
      duty     : IO.Interfaces.PWM.DutyCycle := IO.Interfaces.PWM.MINIMUM_DUTYCYCLE;
      polarity : Polarities := Polarities.ActiveHigh);

    private function GetDutyCycle : IO.Interfaces.PWM.DutyCycle;

    private procedure SetDutyCycle(duty : IO.Interfaces.PWM.DutyCycle);

    public property dutycycle : IO.Interfaces.PWM.DutyCycle read GetDutyCycle write SetDutyCycle;

    private function GetFrequency : Cardinal;

    public property frequency: Cardinal read GetFrequency;

    private function Getfd : Int32;

    public property fd : Int32 read Getfd;

    { Private internal state }

    private myfd         : Int32;
    private myfrequency  : Cardinal;  { Hertz }
    private myperiod     : Cardinal;  { nanoseconds }
    private mydutycycle  : IO.Interfaces.PWM.DutyCycle;  { Percent }
  end;

implementation

  constructor Output
     (desg     : IO.Objects.SimpleIO.Resources.Designator;
      freq     : Cardinal;
      duty     : IO.Interfaces.PWM.DutyCycle := IO.Interfaces.PWM.MINIMUM_DUTYCYCLE;
      polarity : Polarities := Polarities.ActiveHigh);

  begin
    var period : Int32 := 1000000000/freq;  { nanoseconds }
    var error  : Int32;

    IO.Bindings.libsimpleio.PWM_configure(desg.chip, desg.channel, period, 0,
      ord(polarity), @error);

    if error <> 0 then
      raise new Exception('PWM_configure() failed, ' + errno.strerror(error));

    IO.Bindings.libsimpleio.PWM_open(desg.chip, desg.channel, @self.myfd, @error);

    if error <> 0 then
      raise new Exception('PWM_open() failed, ' + errno.strerror(error));

    self.myfrequency := freq;    { Hertz }
    self.myperiod    := period;  { nanoseconds }
    self.dutycycle   := duty;    { percent }
  end;

  procedure Output.SetDutyCycle(duty: IO.Interfaces.PWM.DutyCycle);

  begin
    var ontime : Int32 := Int32(duty/IO.Interfaces.PWM.MAXIMUM_DUTYCYCLE*self.myperiod);
    var error  : Int32;

    IO.Bindings.libsimpleio.PWM_write(self.myfd, ontime, @error);

    if error <> 0 then
      raise new Exception('PWM_open() failed, ' + errno.strerror(error));

    self.mydutycycle := duty;
  end;

  function Output.GetDutyCycle: IO.Interfaces.PWM.DutyCycle;

  begin
    GetDutyCycle := self.mydutycycle;
  end;

  function Output.GetFrequency: Cardinal;

  begin
    GetFrequency := self.myfrequency;
  end;

  function Output.Getfd: Int32;

  begin
    Getfd := self.myfd;
  end;

end.
