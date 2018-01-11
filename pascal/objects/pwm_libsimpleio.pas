{ PWM (Pulse Width Modulated) output services using libsimpleio               }

{ Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.             }
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

  USES PWM;

  TYPE
    Polarities = (ActiveLow, ActiveHigh);

    { Define a class implementing PWM.Device }

    DeviceSubclass = CLASS(TInterfacedObject, PWM.Device)

      CONSTRUCTOR Create
       (chip      : Cardinal;
        channel   : Cardinal;
        frequency : Cardinal;
        dutycycle : Real = 0.0;
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
    errno,
    libPWM;

  { PWM_libsimpleio.DeviceSubclass constructor }

  CONSTRUCTOR DeviceSubclass.Create
   (chip      : Cardinal;
    channel   : Cardinal;
    frequency : Cardinal;
    dutycycle : Real;
    polarity  : Polarities);

  VAR
    ontime : Integer;
    error  : Integer;

  BEGIN
    IF (dutycycle < 0.0) OR (dutycycle > 100.0) THEN
      RAISE PWM_Error.create('ERROR: Invalid duty cycle parameter, ' +
        strerror(EINVAL));

    Self.period := Round(1.0E9/frequency);
    ontime := Round(dutycycle/100.0*period);

    libPWM.Configure(chip, channel, period, ontime, Ord(polarity), error);

    IF error <> 0 THEN
      RAISE PWM_Error.create('ERROR: libPWM.Configure() failed, ' +
        strerror(error));

    libPWM.Open(chip, channel, Self.fd, error);

    IF error <> 0 THEN
      RAISE PWM_Error.create('ERROR: libPWM.Open() failed, ' +
        strerror(error));
  END;

  { PWM_libsimpleio.DeviceSubclass destructor }

  DESTRUCTOR DeviceSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN

    { Close the PWM output device file handle }

    libPWM.Close(Self.fd, error);

    IF error <> 0 THEN
      RAISE PWM_Error.create('ERROR: libPWM.Close() failed, ' +
        strerror(error));

    INHERITED;
  END;

  {  PWM_libsimpleio.DeviceSubclass write method }

  PROCEDURE DeviceSubclass.Write(dutycycle : Real);

  VAR
    ontime : Integer;
    error  : Integer;

  BEGIN
    ontime := Round(dutycycle/100.0*Self.period);

    libPWM.Write(Self.fd, ontime, error);

    IF error <> 0 THEN
      RAISE PWM_Error.create('ERROR: libPWM.Write() failed, ' +
        strerror(error));
  END;

END.
