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

{ Implement GPIO pin services using libsimpleio }

namespace IO.Objects.SimpleIO.GPIO;

interface

  type Drivers = public (PushPull, OpenDrain, OpenSource);

  type Polarities = public (ActiveLow, ActiveHigh);

  type Edges = public (None, Rising, Falling, Both);

  type Pin = public class(Object, IO.Interfaces.GPIO.Pin)
    public constructor
     (desg     : IO.Objects.SimpleIO.Resources.Designator;
      dir      : IO.Interfaces.GPIO.Direction;
      newstate : Boolean    := False;
      driver   : Drivers    := Drivers.PushPull;
      polarity : Polarities := Polarities.ActiveHigh;
      edge     : Edges      := Edges.None);

    finalizer;

    public method GetState : Boolean;

    public method PutState(newstate : Boolean);

    property state : Boolean read GetState write PutState;

  { Private internal state }

    private fd          : Int32;
    private IsInput     : Boolean; readonly;
    private IsInterrupt : Boolean; readonly;
  end;

implementation

  constructor Pin
   (desg     : IO.Objects.SimpleIO.Resources.Designator;
    dir      : IO.Interfaces.GPIO.Direction;
    newstate : Boolean;
    driver   : Drivers;
    polarity : Polarities;
    edge     : Edges);

  begin
    var flags  : Int32 := 0;
    var events : Int32 := 0;
    var error  : Int32;

    self.fd := -1;
    self.IsInput := false;
    self.IsInterrupt := false;

    case dir of
      IO.Interfaces.GPIO.Direction.Input  : flags  := flags or IO.Bindings.libsimpleio.LINE_REQUEST_INPUT;
      IO.Interfaces.GPIO.Direction.Output : flags  := flags or IO.Bindings.libsimpleio.LINE_REQUEST_OUTPUT;
    end;

    case driver of
      Drivers.PushPull      : flags  := flags or IO.Bindings.libsimpleio.LINE_REQUEST_PUSH_PULL;
      Drivers.OpenDrain     : flags  := flags or IO.Bindings.libsimpleio.LINE_REQUEST_OPEN_DRAIN;
      Drivers.OpenSource    : flags  := flags or IO.Bindings.libsimpleio.LINE_REQUEST_OPEN_SOURCE;
    end;

    case polarity of
      Polarities.ActiveLow  : flags  := flags or IO.Bindings.libsimpleio.LINE_REQUEST_ACTIVE_LOW;
      Polarities.ActiveHigh : flags  := flags or IO.Bindings.libsimpleio.LINE_REQUEST_ACTIVE_HIGH;
    end;

    case edge of
      Edges.None            : events := IO.Bindings.libsimpleio.EVENT_REQUEST_NONE;
      Edges.Rising          : events := IO.Bindings.libsimpleio.EVENT_REQUEST_RISING;
      Edges.Falling         : events := IO.Bindings.libsimpleio.EVENT_REQUEST_FALLING;
      Edges.Both            : events := IO.Bindings.libsimpleio.EVENT_REQUEST_BOTH;
    end;

    IO.Bindings.libsimpleio.GPIO_line_open(desg.chip, desg.channel, flags, events,
      ord(newstate), @self.fd, @error);

    if error <> 0 then
      raise new IO.Interfaces.GPIO.Error('GPIO_line_open() failed, ' + errno.strerror(error));

    self.IsInput     := (dir = IO.Interfaces.GPIO.Direction.Input);
    self.IsInterrupt := (edge <> Edges.None);
  end;

  finalizer Pin;

  begin
    var error : Int32;
    IO.Bindings.libsimpleio.GPIO_line_close(self.fd, @error);
  end;

  method Pin.GetState : Boolean;

  begin
    var s     : Int32;
    var error : Int32;

    if self.IsInterrupt then
      begin
        IO.Bindings.libsimpleio.GPIO_line_event(self.fd, @s, @error);

        if error <> 0 then
          raise new IO.Interfaces.GPIO.Error('GPIO_line_event() failed, ' +
            errno.strerror(error));
      end
    else
      begin
        IO.Bindings.libsimpleio.GPIO_line_read(self.fd, @s, @error);

        if error <> 0 then
          raise new IO.Interfaces.GPIO.Error('GPIO_line_read() failed, ' +
            errno.strerror(error));
      end;

    result := (s <> 0);
  end;

  method Pin.PutState(newstate : Boolean);

  begin
    var error : Int32;

    if self.IsInput then
      raise new IO.Interfaces.GPIO.Error('Cannot write to an input pin');

    IO.Bindings.libsimpleio.GPIO_line_write(self.fd, ord(newstate), @error);

    if error <> 0 then
      raise new IO.Interfaces.GPIO.Error('GPIO_line_write() failed, ' +
        errno.strerror(error));
  end;

end.
