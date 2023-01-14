-- Log messages with syslog using libsimpleio

-- Copyright (C)2018-2023, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY Logging.libsimpleio IS
  PRAGMA Warnings(Off, """err"" modified by call, but value might not be referenced");
  PRAGMA Warnings(Off, """err"" modified by call, but value overwritten at line 55");

  FUNCTION Create
   (sender   : String := libLinux.LOG_PROGNAME;
    options  : Integer := libLinux.LOG_NDELAY + libLinux.LOG_PID +
      libLinux.LOG_PERROR;
    facility : Integer := libLinux.LOG_SYSLOG) RETURN Logger IS

    Self : LoggerSubclass;

  BEGIN
    Initialize(Self, sender, options, facility);
    RETURN NEW LoggerSubclass'(Self);
  END Create;

  PROCEDURE Initialize
   (Self     : IN OUT LoggerSubclass;
    sender   : String  := libLinux.LOG_PROGNAME;
    options  : Integer := libLinux.LOG_NDELAY + libLinux.LOG_PID +
      libLinux.LOG_PERROR;
    facility : Integer := libLinux.LOG_SYSLOG) IS

    err : Integer;

  BEGIN
    Self := Destroyed;

    libLinux.CloseLog(err);
    libLinux.OpenLog(sender, options, facility, err);

    IF err /= 0 THEN
      RAISE Logging_Error WITH "libLinux.OpenLog() failed, " &
        errno.strerror(err);
    END IF;

    Self := LoggerSubclass'(NULL RECORD);
  END Initialize;

  PROCEDURE Destroy(Self : IN OUT LoggerSubclass) IS

    err : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libLinux.CloseLog(err);

    Self := Destroyed;
  END Destroy;

  -- Log an error event

  PROCEDURE Error(Self : LoggerSubclass; message : String) IS

    err : Integer;

  BEGIN
    libLinux.WriteLog(libLinux.LOG_ERR, message & ASCII.NUL, err);
  END Error;

  -- Log an error event, with errno value

  PROCEDURE Error(Self : LoggerSubclass; message : String; errnum : Integer) IS

    err : Integer;

  BEGIN
    libLinux.WriteLog(libLinux.LOG_ERR, message & ", " & errno.strerror(errnum) &
      ASCII.NUL, err);
  END Error;

  -- Log a warning event

  PROCEDURE Warning(Self : LoggerSubclass; message : String) IS

    err : Integer;

  BEGIN
    libLinux.WriteLog(libLinux.LOG_WARNING, message & ASCII.NUL,
      err);
  END Warning;

  -- Log a notification event

  PROCEDURE Note(Self : LoggerSubclass; message : String) IS

    err : Integer;

  BEGIN
    libLinux.WriteLog(libLinux.LOG_INFO, message & ASCII.NUL, err);
  END Note;

  -- The following subprograms are analogous to classwide static methods.

  PROCEDURE Error(message : String) IS

    err : Integer;

  BEGIN
    libLinux.WriteLog(libLinux.LOG_ERR, message & ASCII.NUL, err);
  END Error;

  PROCEDURE Error(message : String; errnum : Integer) IS

    err : Integer;

  BEGIN
    libLinux.WriteLog(libLinux.LOG_ERR, message & ", " &
      errno.strerror(errnum) & ASCII.NUL, err);
  END Error;

  PROCEDURE Warning(message : String) IS

    err : Integer;

  BEGIN
    libLinux.WriteLog(libLinux.LOG_WARNING, message & ASCII.NUL,
      err);
  END Warning;

  PROCEDURE Note(message : String) IS

    err : Integer;

  BEGIN
    libLinux.WriteLog(libLinux.LOG_INFO, message & ASCII.NUL, err);
  END Note;

END Logging.libsimpleio;
