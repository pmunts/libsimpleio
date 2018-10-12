-- Abstract interface for logging subsystems (e.g. syslog)

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

PACKAGE Logging IS

  -- Define an exception for logging subsystem errors

  Logging_Error : EXCEPTION;

  -- Define an abstract interface for logging subsystems

  TYPE LoggerInterface IS INTERFACE;

  -- Define an access type compatible with any subclass implementing
  -- LoggerInterface

  TYPE Logger IS ACCESS ALL LoggerInterface'Class;

  -- Log an error

  PROCEDURE Error(Self : LoggerInterface; message : String) IS ABSTRACT;

  -- Log an error including an errno value

  PROCEDURE Error(Self : LoggerInterface; message : String;
    errnum : Integer) IS ABSTRACT;

  -- Log a warning

  PROCEDURE Warning(Self : LoggerInterface; message : String) IS ABSTRACT;

  -- Log an informational note

  PROCEDURE Note(Self : LoggerInterface; message : String) IS ABSTRACT;

END Logging;
