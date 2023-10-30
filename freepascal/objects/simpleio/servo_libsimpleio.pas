{ Servo output services using libsimpleio                                     }

{ Copyright (C)2018-2023, Philip Munts dba Munts Technologies.                }
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

UNIT Servo_libsimpleio;

INTERFACE

  USES
    libsimpleio,
    Servo;

  TYPE
    OutputSubclass = CLASS(TInterfacedObject, Servo.Output)
      CONSTRUCTOR Create
       (desg      : libsimpleio.Designator;
        frequency : Cardinal;
        position  : Real = POSITION_NEUTRAL);

      CONSTRUCTOR Create
       (chip      : Cardinal;
        channel   : Cardinal;
        frequency : Cardinal;
        position  : Real = POSITION_NEUTRAL);

      DESTRUCTOR Destroy; OVERRIDE;

      PROCEDURE Write(position : Real);

      PROPERTY position : Real WRITE Write;

    PRIVATE
      fd     : Integer;
    END;

IMPLEMENTATION

  USES
    Errors,
    libPWM;

  { Servo_libsimpleio.OutputSubclass constructor }

  CONSTRUCTOR OutputSubclass.Create
   (desg      : libsimpleio.Designator;
    frequency : Cardinal;
    position  : Real);

  VAR
    period : Integer;
    ontime : Integer;
    error  : Integer;

  BEGIN
    IF (position < POSITION_MIN) OR (position > POSITION_MAX) THEN
      RAISE Servo.Error.Create('ERROR: Invalid position parameter');

    period := Round(1.0E9/frequency);
    ontime := Round(1500000.0 + 500000.0*position);

    libPWM.Configure(desg.chip, desg.chan, period, ontime, 1, error);

    IF error <> 0 THEN
      RAISE Servo.Error.Create('ERROR: libPWM.Configure() failed, ' +
        StrError(error));

    libPWM.Open(desg.chip, desg.chan, Self.fd, error);

    IF error <> 0 THEN
      RAISE Servo.Error.Create('ERROR: libPWM.Open() failed, ' +
        StrError(error));
  END;

  CONSTRUCTOR OutputSubclass.Create
   (chip      : Cardinal;
    channel   : Cardinal;
    frequency : Cardinal;
    position  : Real);

  VAR
    period : Integer;
    ontime : Integer;
    error  : Integer;

  BEGIN
    IF (position < POSITION_MIN) OR (position > POSITION_MAX) THEN
      RAISE Servo.Error.Create('ERROR: Invalid position parameter');

    period := Round(1.0E9/frequency);
    ontime := Round(1500000.0 + 500000.0*position);

    libPWM.Configure(chip, channel, period, ontime, 1, error);

    IF error <> 0 THEN
      RAISE Servo.Error.Create('ERROR: libPWM.Configure() failed, ' +
        StrError(error));

    libPWM.Open(chip, channel, Self.fd, error);

    IF error <> 0 THEN
      RAISE Servo.Error.Create('ERROR: libPWM.Open() failed, ' +
        StrError(error));
  END;

  { Servo_libsimpleio.OutputSubclass destructor }

  DESTRUCTOR OutputSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN
    libPWM.Close(Self.fd, error);
    INHERITED;
  END;

  {  Servo_libsimpleio.OutputSubclass write method }

  PROCEDURE OutputSubclass.Write(position : Real);

  VAR
    ontime : Integer;
    error  : Integer;

  BEGIN
    ontime := Round(1500000.0 + 500000.0*position);

    libPWM.Write(Self.fd, ontime, error);

    IF error <> 0 THEN
      RAISE Servo.Error.Create('ERROR: libPWM.Write() failed, ' +
        StrError(error));
  END;

END.
