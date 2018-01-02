{ GPIO pin services using libsimpleio                                         }

{ Copyright (C)2017, Philip Munts, President, Munts AM Corp.                  }
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
    GPIO;

  TYPE
    Edges = (None, Rising, Falling, Both);

    Polarities = (ActiveLow, ActiveHigh);

    { Define a class that implements the GPIO.Pin interface }

    PinSubclass = CLASS(TInterfacedObject, Pin)
      CONSTRUCTOR Create(num : Integer; dir : Direction;
        state : Boolean = False; edge : Edges = None;
        polarity : Polarities = ActiveHigh);

      DESTRUCTOR Destroy; OVERRIDE;

      FUNCTION Read : Boolean;

      PROCEDURE Write(state : Boolean);

      PROPERTY state : Boolean READ Read WRITE Write;
    PRIVATE
      fd : Integer;
    END;

IMPLEMENTATION

  USES
    errno,
    libGPIO;

  { GPIO_libsimpleio.PinSubclass constructor }

  CONSTRUCTOR PinSubclass.Create(num : Integer; dir : Direction;
    state : Boolean; edge : Edges; polarity : Polarities);

  VAR
    error  : Integer;

  BEGIN

    { Configure the GPIO pin }

    libGPIO.Configure(num, Ord(dir), Ord(State), Ord(edge), ord(polarity),
      error);

    IF error <> 0 THEN
      RAISE GPIO_Error.create('ERROR: libGPIO.Configure() failed, ' +
        strerror(error));

    { Open the GPIO pin device node }

    libGPIO.Open(num, Self.fd, error);

    IF error <> 0 THEN
      RAISE GPIO_Error.create('ERROR: libGPIO.Open() failed, ' +
        strerror(error));
  END;

  { GPIO_libsimpleio.PinSubclass destructor }

  DESTRUCTOR PinSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN

    { Close the GPIO pin file handle }

    libGPIO.Close(Self.fd, error);

    IF error <> 0 THEN
      RAISE GPIO_Error.create('ERROR: libGPIO.Close() failed, ' +
        strerror(error));

    INHERITED;
  END;

  { GPIO read method }

  FUNCTION PinSubclass.Read : Boolean;

  VAR
    s      : Integer;
    error  : Integer;

  BEGIN
    libGPIO.Read(Self.fd, s, error);

    IF error <> 0 THEN
      RAISE GPIO_Error.create('ERROR: libGPIO.read() failed, ' +
        strerror(error));

    Read := Boolean(s);
  END;

  { GPIO write method }

  PROCEDURE PinSubclass.Write(state : Boolean);

  VAR
    error  : Integer;

  BEGIN
    libGPIO.Write(Self.fd, Ord(state), error);

    IF error <> 0 THEN
      RAISE GPIO_Error.create('ERROR: libGPIO.read() failed, ' +
        strerror(error));
  END;

END.
