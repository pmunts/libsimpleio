-- Log messages using syslog

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

WITH libLinux;

PACKAGE Logging.Syslog IS

  TYPE LoggerSubclass IS NEW Logging.LoggerInterface WITH PRIVATE;

  FUNCTION Create
   (sender   : String;
    options  : Integer := libLinux.LOG_NDELAY + libLinux.LOG_PID +
      libLinux.LOG_PERROR;
    facility : Integer := libLinux.LOG_SYSLOG) RETURN Logger;

  -- Log an error event

  PROCEDURE Error(self : LoggerSubclass; message : String);

  -- Log an error event, with errno value

  PROCEDURE Error(self : LoggerSubclass; message : String; errnum : Integer);

  -- Log a warning event

  PROCEDURE Warning(self : LoggerSubclass; message : String);

  -- Log a notification event

  PROCEDURE Note(self : LoggerSubclass; message : String);

PRIVATE

  TYPE LoggerSubclass IS NEW Logging.LoggerInterface WITH NULL RECORD;

END Logging.Syslog;
