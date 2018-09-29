{ Servo output services using libsimpleio                                     }

{ Copyright (C)2018, Philip Munts, President, Munts AM Corp.                  }
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

  USES Servo;

  TYPE
    OutputSubclass = CLASS(TInterfacedObject, Servo.Output)
      CONSTRUCTOR Create
       (chip      : Cardinal;
        channel   : Cardinal;
        frequency : Cardinal;
        position  : Real = POSITION_NEUTRAL);

      DESTRUCTOR Destroy; OVERRIDE;

      PROCEDURE WritePosition(position : Real);

      PROPERTY position : Real WRITE WritePosition;

    PRIVATE
      fd     : Integer;
    END;

IMPLEMENTATION

  USES
    errno,
    libPWM;

  { Servo_libsimpleio.OutputSubclass constructor }

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
      RAISE Servo_Error.Create('ERROR: Invalid position parameter, ' +
        errno.strerror(EINVAL));

    period := Round(1.0E9/frequency);
    ontime := Round(1500000.0 + 500000.0*position);

    libPWM.Configure(chip, channel, period, ontime, 1, error);

    IF error <> 0 THEN
      RAISE Servo_Error.Create('ERROR: libPWM.Configure() failed, ' +
        errno.strerror(error));

    libPWM.Open(chip, channel, Self.fd, error);

    IF error <> 0 THEN
      RAISE Servo_Error.Create('ERROR: libPWM.Open() failed, ' +
        errno.strerror(error));
  END;

  { Servo_libsimpleio.OutputSubclass destructor }

  DESTRUCTOR OutputSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN

    { Close the PWM output device file handle }

    libPWM.Close(Self.fd, error);

    IF error <> 0 THEN
      RAISE Servo_Error.Create('ERROR: libPWM.Close() failed, ' +
        errno.strerror(error));

    INHERITED;
  END;

  {  Servo_libsimpleio.OutputSubclass write method }

  PROCEDURE OutputSubclass.WritePosition(position : Real);

  VAR
    ontime : Integer;
    error  : Integer;

  BEGIN
    ontime := Round(1500000.0 + 500000.0*position);

    libPWM.Write(Self.fd, ontime, error);

    IF error <> 0 THEN
      RAISE Servo_Error.Create('ERROR: libPWM.Write() failed, ' +
        errno.strerror(error));
  END;

END.
