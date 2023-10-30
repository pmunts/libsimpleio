{ GPIO pin services using libsimpleio                                         }

{ Copyright (C)2017-2023, Philip Munts dba Munts Technologies.                }
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

UNIT GPIO_libsimpleio;

INTERFACE

  USES
    libsimpleio,
    GPIO;

  TYPE
    Drivers = (PushPull, OpenDrain, OpenSource);

    Polarities = (ActiveLow, ActiveHigh);

    Edges = (None, Rising, Falling, Both);

    PinSubclass = CLASS(TInterfacedObject, GPIO.Pin)
      CONSTRUCTOR Create
       (desg     : libsimpleio.Designator;
        dir      : Direction;
        state    : Boolean = False;
        driver   : Drivers = PushPull;
        polarity : Polarities = ActiveHigh;
        edge     : Edges = None);

      CONSTRUCTOR Create
       (chip     : Cardinal;
        line     : Cardinal;
        dir      : Direction;
        state    : Boolean = False;
        driver   : Drivers = PushPull;
        polarity : Polarities = ActiveHigh;
        edge     : Edges = None);

      DESTRUCTOR Destroy; OVERRIDE;

      FUNCTION Read : Boolean;

      PROCEDURE Write(state : Boolean);

      PROPERTY state : Boolean READ Read WRITE Write;
    PRIVATE
      fd  : Integer;
      inp : Boolean;
      int : Boolean;
    END;

IMPLEMENTATION

  USES
    Errors,
    libGPIO;

  PROCEDURE ComputeFlags
   (dir        : Direction;
    driver     : Drivers;
    polarity   : Polarities;
    edge       : Edges;
    VAR flags  : Integer;
    VAR events : integer);

  BEGIN
    CASE dir OF
      GPIO.Input  : flags := LINE_REQUEST_INPUT;
      GPIO.Output : flags := LINE_REQUEST_OUTPUT;
    END;

    CASE driver OF
      PushPull    : flags := flags OR LINE_REQUEST_PUSH_PULL;
      OpenDrain   : flags := flags OR LINE_REQUEST_OPEN_DRAIN;
      OpenSource  : flags := flags OR LINE_REQUEST_OPEN_SOURCE;
    END;

    CASE polarity OF
      ActiveHigh  : flags := flags OR LINE_REQUEST_ACTIVE_HIGH;
      ActiveLow   : flags := flags OR LINE_REQUEST_ACTIVE_LOW;
    END;

    CASE edge OF
      None        : events := EVENT_REQUEST_NONE;
      Rising      : events := EVENT_REQUEST_RISING;
      Falling     : events := EVENT_REQUEST_FALLING;
      Both        : events := EVENT_REQUEST_BOTH;
    END;
  END;

  { GPIO_libsimpleio.PinSubclass constructors }

  CONSTRUCTOR PinSubclass.Create
   (desg     : libsimpleio.Designator;
    dir      : Direction;
    state    : Boolean;
    driver   : Drivers;
    polarity : Polarities;
    edge     : Edges);

  VAR
    flags  : Integer;
    events : Integer;
    error  : Integer;

  BEGIN
    ComputeFlags(dir, driver, polarity, edge, flags, events);

    libGPIO.LineOpen(desg.chip, desg.chan, flags, events, Ord(state),
      Self.fd, error);

    IF error <> 0 THEN
      RAISE GPIO.Error.Create('ERROR: libGPIO.LineOpen() failed, ' +
        StrError(error));

    Self.inp := (dir = GPIO.Input);
    Self.int := (Edge <> None);
  END;

  CONSTRUCTOR PinSubclass.Create
   (chip     : Cardinal;
    line     : Cardinal;
    dir      : Direction;
    state    : Boolean = False;
    driver   : Drivers = PushPull;
    polarity : Polarities = ActiveHigh;
    edge     : Edges = None);

  VAR
    flags  : Integer;
    events : Integer;
    error  : Integer;

  BEGIN
    ComputeFlags(dir, driver, polarity, edge, flags, events);

    libGPIO.LineOpen(chip, line, flags, events, Ord(state), Self.fd, error);

    IF error <> 0 THEN
      RAISE GPIO.Error.Create('ERROR: libGPIO.LineOpen() failed, ' +
        StrError(error));

    Self.int := (edge <> None);
  END;

  { GPIO_libsimpleio.PinSubclass destructor }

  DESTRUCTOR PinSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN
    libGPIO.Close(Self.fd, error);
    INHERITED;
  END;

  { GPIO read method }

  FUNCTION PinSubclass.Read : Boolean;

  VAR
    s      : Integer;
    error  : Integer;

  BEGIN
    IF Self.int THEN
      BEGIN
        libGPIO.LineEvent(Self.fd, s, error);

        IF error <> 0 THEN
          RAISE GPIO.Error.Create('ERROR: libGPIO.LineEvent() failed, ' +
            StrError(error))
      END
    ELSE
      BEGIN
        libGPIO.LineRead(Self.fd, s, error);

        IF error <> 0 THEN
          RAISE GPIO.Error.Create('ERROR: libGPIO.LineRead() failed, ' +
            StrError(error))
      END;

    Read := Boolean(s);
  END;

  { GPIO write method }

  PROCEDURE PinSubclass.Write(state : Boolean);

  VAR
    error  : Integer;

  BEGIN
    IF Self.inp THEN
      RAISE GPIO.Error.Create('ERROR: Cannot write to input pin');

    libGPIO.LineWrite(Self.fd, Ord(state), error);

    IF error <> 0 THEN
      RAISE GPIO.Error.Create('ERROR: libGPIO.LineWrite() failed, ' +
        StrError(error));
  END;

END.
