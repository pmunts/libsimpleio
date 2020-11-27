-- Watchdog timer device services using libsimpleio

-- Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

WITH errno;
WITH libWatchdog;

PACKAGE BODY Watchdog.libsimpleio IS

  -- Watchdog device object constructor

  FUNCTION Create
   (devname : String   := DefaultDevice;
    timeout : Duration := DefaultTimeout) RETURN Watchdog.Timer IS

    Self : TimerSubclass;

  BEGIN
    Self.Initialize(devname, timeout);
    RETURN NEW TimerSubclass'(Self);
  END Create;

  -- Watchdog device object initializer

  PROCEDURE Initialize
   (Self    : IN OUT TimerSubclass;
    devname : String   := DefaultDevice;
    timeout : Duration := DefaultTimeout) IS

    fd            : Integer;
    error         : Integer;
    actualtimeout : Integer;

  BEGIN
    Self.Destroy;

    -- Open the watchdog device

    libWatchdog.Open(devname & ASCII.NUL, fd, error);

    IF error /= 0 THEN
      RAISE Watchdog_Error WITH "libWatchdog.Open() failed, " &
        errno.strerror(error);
    END IF;

    -- Change the timeout, if requested

    IF timeout /= DefaultTimeout THEN
      libWatchdog.SetTimeout(fd, Integer(timeout), actualtimeout, error);

      IF error /= 0 THEN
        RAISE Watchdog_Error WITH "libWatchdog.SetTimeout() failed, " &
          errno.strerror(error);
      END IF;
    END IF;

    -- Return the new watchdog device object instance

    Self := TimerSubclass'(fd => fd);
  END Initialize;

  -- Watchdog device object destroyer

  PROCEDURE Destroy(Self : IN OUT TimerSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libWatchdog.Close(Self.fd, error);

    Self := Destroyed;

    IF error /= 0 THEN
      RAISE Watchdog_Error WITH "libWatchdog.Close() failed, " &
        errno.strerror(error);
    END IF;
  END Destroy;

  -- Method to get the watchdog timeout in seconds

  FUNCTION GetTimeout(Self : TimerSubclass) RETURN Duration IS

    timeout : Integer;
    error   : Integer;

  BEGIN
    Self.CheckDestroyed;

    libWatchdog.GetTimeout(Self.fd, timeout, error);

    IF error /= 0 THEN
      RAISE Watchdog_Error WITH "libWatchdog.GetTimeout() failed, " &
        errno.strerror(error);
    END IF;

    RETURN Duration(timeout);
  END GetTimeout;

  -- Method to change the watchdog timeout in seconds

  PROCEDURE SetTimeout(Self : TimerSubclass; timeout : Duration) IS

    error         : Integer;
    actualtimeout : Integer;

  BEGIN
    Self.CheckDestroyed;

    libWatchdog.SetTimeout(Self.fd, Integer(timeout), actualtimeout, error);

    IF error /= 0 THEN
      RAISE Watchdog_Error WITH "libWatchdog.SetTimeout() failed, " &
        errno.strerror(error);
    END IF;
  END SetTimeout;

  -- Method to reset the watchdog timer

  PROCEDURE Kick(Self : TimerSubclass) IS

    error : Integer;

  BEGIN
    Self.CheckDestroyed;

    libWatchdog.Kick(Self.fd, error);

    IF error /= 0 THEN
      RAISE Watchdog_Error WITH "libWatchdog.Kick() failed, " &
        errno.strerror(error);
    END IF;
  END Kick;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : TimerSubclass) RETURN Integer IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.fd;
  END fd;

  -- Check whether watchdog timer has been destroyed

  PROCEDURE CheckDestroyed(Self : TimerSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE Watchdog_Error WITH "Watchdog timer has been destroyed";
    END IF;
  END CheckDestroyed;

END Watchdog.libsimpleio;
