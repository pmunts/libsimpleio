-- Log messages with syslog using libsimpleio

-- Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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

PACKAGE Logging.libsimpleio IS

  TYPE LoggerSubclass IS NEW Logging.LoggerInterface WITH PRIVATE;

  Destroyed : CONSTANT LoggerSubclass;

  FUNCTION Create
   (sender   : String := libLinux.LOG_PROGNAME;
    options  : Integer := libLinux.LOG_NDELAY + libLinux.LOG_PID +
      libLinux.LOG_PERROR;
    facility : Integer := libLinux.LOG_SYSLOG) RETURN Logger;

  PROCEDURE Initialize
   (Self     : IN OUT LoggerSubclass;
    sender   : String  := libLinux.LOG_PROGNAME;
    options  : Integer := libLinux.LOG_NDELAY + libLinux.LOG_PID +
      libLinux.LOG_PERROR;
    facility : Integer := libLinux.LOG_SYSLOG);

  PROCEDURE Destroy(Self : IN OUT LoggerSubclass);

  -- Log an error event

  PROCEDURE Error(Self : LoggerSubclass; message : String);

  -- Log an error event, with errno value

  PROCEDURE Error(Self : LoggerSubclass; message : String; errnum : Integer);

  -- Log a warning event

  PROCEDURE Warning(Self : LoggerSubclass; message : String);

  -- Log a notification event

  PROCEDURE Note(Self : LoggerSubclass; message : String);

  -- The following subprograms are analogous to classwide static methods.

  PROCEDURE Error(message : String);

  PROCEDURE Error(message : String; errnum : Integer);

  PROCEDURE Warning(message : String);

  PROCEDURE Note(message : String);

PRIVATE

  TYPE LoggerSubclass IS NEW Logging.LoggerInterface WITH NULL RECORD;

  Destroyed : CONSTANT LoggerSubclass := (NULL RECORD);

END Logging.libsimpleio;
