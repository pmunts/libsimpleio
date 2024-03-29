{ PWM (Pulse Width Modulated) output services using libsimpleio               }

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

UNIT PWM_libsimpleio;

INTERFACE

  USES
    libsimpleio,
    PWM;

  TYPE
    Polarities = (ActiveLow, ActiveHigh);

    OutputSubclass = CLASS(TInterfacedObject, PWM.Output)
      CONSTRUCTOR Create
       (desg      : libsimpleio.Designator;
        frequency : Cardinal;
        dutycycle : Real = DUTYCYCLE_MIN;
        polarity  : Polarities = ActiveHigh);

      CONSTRUCTOR Create
       (chip      : Cardinal;
        channel   : Cardinal;
        frequency : Cardinal;
        dutycycle : Real = DUTYCYCLE_MIN;
        polarity  : Polarities = ActiveHigh);

      DESTRUCTOR Destroy; OVERRIDE;

      PROCEDURE Write(dutycycle : Real);

      PROPERTY dutycycle : Real WRITE Write;

    PRIVATE
      fd     : Integer;
      period : Integer;
    END;

IMPLEMENTATION

  USES
    Errors,
    libPWM;

  { PWM_libsimpleio.OutputSubclass constructor }

  CONSTRUCTOR OutputSubclass.Create
   (desg      : libsimpleio.Designator;
    frequency : Cardinal;
    dutycycle : Real;
    polarity  : Polarities);

  VAR
    ontime : Integer;
    error  : Integer;

  BEGIN
    IF (dutycycle < DUTYCYCLE_MIN) OR (dutycycle > DUTYCYCLE_MAX) THEN
      RAISE PWM.Error.Create('ERROR: Invalid duty cycle parameter');

    Self.period := Round(1.0E9/frequency);
    ontime := Round(dutycycle/DUTYCYCLE_MAX*period);

    libPWM.Configure(desg.chip, desg.chan, period, ontime,
      Ord(polarity), error);

    IF error <> 0 THEN
      RAISE PWM.Error.Create('ERROR: libPWM.Configure() failed, ' +
        StrError(error));

    libPWM.Open(desg.chip, desg.chan, Self.fd, error);

    IF error <> 0 THEN
      RAISE PWM.Error.Create('ERROR: libPWM.Open() failed, ' +
        StrError(error));
  END;

  CONSTRUCTOR OutputSubclass.Create
   (chip      : Cardinal;
    channel   : Cardinal;
    frequency : Cardinal;
    dutycycle : Real;
    polarity  : Polarities);

  VAR
    ontime : Integer;
    error  : Integer;

  BEGIN
    IF (dutycycle < DUTYCYCLE_MIN) OR (dutycycle > DUTYCYCLE_MAX) THEN
      RAISE PWM.Error.Create('ERROR: Invalid duty cycle parameter');

    Self.period := Round(1.0E9/frequency);
    ontime := Round(dutycycle/DUTYCYCLE_MAX*period);

    libPWM.Configure(chip, channel, period, ontime, Ord(polarity), error);

    IF error <> 0 THEN
      RAISE PWM.Error.Create('ERROR: libPWM.Configure() failed, ' +
        StrError(error));

    libPWM.Open(chip, channel, Self.fd, error);

    IF error <> 0 THEN
      RAISE PWM.Error.Create('ERROR: libPWM.Open() failed, ' +
        StrError(error));
  END;

  { PWM_libsimpleio.OutputSubclass destructor }

  DESTRUCTOR OutputSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN
    libPWM.Close(Self.fd, error);
    INHERITED;
  END;

  {  PWM_libsimpleio.OutputSubclass write method }

  PROCEDURE OutputSubclass.Write(dutycycle : Real);

  VAR
    ontime : Integer;
    error  : Integer;

  BEGIN
    ontime := Round(dutycycle/DUTYCYCLE_MAX*Self.period);

    libPWM.Write(Self.fd, ontime, error);

    IF error <> 0 THEN
      RAISE PWM.Error.Create('ERROR: libPWM.Write() failed, ' +
        StrError(error));
  END;

END.
