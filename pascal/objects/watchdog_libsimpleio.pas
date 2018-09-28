{ Watchdog timer device services using libsimpleio                            }

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

UNIT Watchdog_libsimpleio;

INTERFACE

  USES
    Watchdog;

  CONST
    DefaultDevice  = '/dev/watchdog';
    DefaultTimeout = 0;

  TYPE
    TimerSubclass = CLASS(TInterfacedObject, Watchdog.Timer)
      CONSTRUCTOR Create(name : String = DefaultDevice; timeout : Cardinal = 0);

      DESTRUCTOR Destroy; OVERRIDE;

      FUNCTION GetTimeout : Cardinal;

      PROCEDURE SetTimeout(timeout : Cardinal);

      PROCEDURE Kick;

    PRIVATE
      fd : Integer;
    END;

IMPLEMENTATION

  USES
    errno,
    libWatchdog;

  { Constructor }

  CONSTRUCTOR TimerSubclass.Create(name : String; timeout : Cardinal);

  VAR
    error      : Integer;
    newtimeout : Integer;

  BEGIN
    libWatchdog.Open(PChar(name), Self.fd, error);

    IF error <> 0 THEN
      RAISE Watchdog_Error.create('ERROR: libWatchdog.Open() failed, ' +
        errno.strerror(error));

    IF timeout <> DefaultTimeout THEN
      BEGIN
        libWatchdog.SetTimeout(Self.fd, timeout, newtimeout, error);

        IF error <> 0 THEN
          RAISE Watchdog_Error.create('ERROR: libWatchdog.Open() failed, ' +
            errno.strerror(error));
      END;
  END;

  { Destructor }

  DESTRUCTOR TimerSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN
    libWatchdog.Close(Self.fd, error);

    IF error <> 0 THEN
      RAISE Watchdog_Error.create('ERROR: libWatchdog.Close() failed, ' +
        errno.strerror(error));

    INHERITED;
  END;

  { Get timeout method }

  FUNCTION TimerSubclass.GetTimeout : Cardinal;

  VAR
    timeout : Integer;
    error   : Integer;

  BEGIN
    libWatchdog.GetTimeout(Self.fd, timeout, error);

    IF error <> 0 THEN
      RAISE Watchdog_Error.create('ERROR: libWatchdog.GetTimeout() failed, ' +
        errno.strerror(error));

    GetTimeout := timeout;
  END;

  { Set timeout method }

  PROCEDURE TimerSubclass.SetTimeout(timeout : Cardinal);

  VAR
    newtimeout : Integer;
    error      : Integer;

  BEGIN
    libWatchdog.SetTimeout(Self.fd, timeout, newtimeout, error);

    IF error <> 0 THEN
      RAISE Watchdog_Error.create('ERROR: libWatchdog.SetTimeout() failed, ' +
        errno.strerror(error));
  END;

  { Kick watchdog timer method }

  PROCEDURE TimerSubclass.Kick;

  VAR
    error  : Integer;

  BEGIN
    libWatchdog.Kick(Self.fd, error);

    IF error <> 0 THEN
      RAISE Watchdog_Error.create('ERROR: libWatchdog.Kick() failed, ' +
        errno.strerror(error));
  END;

END.
