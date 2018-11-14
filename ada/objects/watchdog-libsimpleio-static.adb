-- Watchdog timer device services using libsimpleio

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY Watchdog.libsimpleio.Static IS

  PROCEDURE Initialize
   (Self    : IN OUT TimerSubclass;
    devname : String   := DefaultDevice;
    timeout : Duration := DefaultTimeout) IS

    fd            : Integer;
    error         : Integer;
    actualtimeout : Integer;

  BEGIN
    Destroy(Self);

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

END Watchdog.libsimpleio.Static;
