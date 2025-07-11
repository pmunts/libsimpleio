-- Simple debug output services

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH libLinux;

PACKAGE BODY Debug.syslog IS

  PROCEDURE Initialize
   (ident    : String  := libLinux.LOG_PROGNAME;
    options  : Integer := libLinux.LOG_NDELAY;
    facility : Integer := liblinux.LOG_SYSLOG) IS

    error : Integer;

  BEGIN
    libLinux.OpenLog(ident & ASCII.Nul, options, facility, error);
  END Initialize;

  FUNCTION DoPrint RETURN Boolean IS

  BEGIN
    RETURN Level = 1 OR Level = 3;
  END DoPrint;

  FUNCTION DoSyslog RETURN Boolean IS

  BEGIN
    RETURN Level = 2 OR Level = 3;
  END DoSyslog;

  -- Print information string

  PROCEDURE Put(s : String) IS

    error : Integer;

  BEGIN
    IF DoPrint THEN
      Put_Line(Standard_Error, s);
    END IF;

    IF DoSyslog THEN
      libLinux.WriteLog(libLinux.LOG_NOTICE, s & ASCII.Nul, error);
    END IF;
  END Put;

  -- Print information about an exception

  PROCEDURE Put(e : Ada.Exceptions.Exception_Occurrence) IS

    error : Integer;

  BEGIN
    IF DoPrint THEN
      Put_Line(Standard_Error, Ada.Exceptions.Exception_Name(e));
      Put_Line(Standard_Error, Ada.Exceptions.Exception_Message(e));
    END IF;

    IF DoSyslog THEN
      libLinux.WriteLog(libLinux.LOG_NOTICE,
        Ada.Exceptions.Exception_Name(e)    & ASCII.Nul, error);
      libLinux.WriteLog(libLinux.LOG_NOTICE,
        Ada.Exceptions.Exception_Message(e) & ASCII.Nul, error);
    END IF;
  END Put;

BEGIN
  Initialize;
END Debug.syslog;
