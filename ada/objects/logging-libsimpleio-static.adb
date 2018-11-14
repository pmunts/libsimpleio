-- Log messages using syslog with libsimpleio without heap

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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
WITH libLinux;

PACKAGE BODY Logging.libsimpleio.Static IS

  PROCEDURE Initialize
   (Self     : IN OUT LoggerSubclass;
    sender   : String  := libLinux.LOG_PROGNAME;
    options  : Integer := libLinux.LOG_NDELAY + libLinux.LOG_PID +
      libLinux.LOG_PERROR;
    facility : Integer := libLinux.LOG_SYSLOG) IS

    error : Integer;

  BEGIN
    Self := Destroyed;

    libLinux.OpenLog(sender, options, facility, error);

    IF error /= 0 THEN
      RAISE Logging_Error WITH "libLinux.OpenLog() failed, " &
        errno.strerror(error);
    END IF;

    Self := LoggerSubclass'(NULL RECORD);
  END Initialize;

  PROCEDURE Destroy(Self : IN OUT LoggerSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    Self := Destroyed;
  END Destroy;

END Logging.libsimpleio.Static;
