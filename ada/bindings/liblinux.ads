-- Minimal Ada wrapper for the Linux syscall services
-- implemented in libsimpleio.so

-- Copyright (C)2016-2020, Philip Munts, President, Munts AM Corp.
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

WITH System;

PACKAGE libLinux IS
  PRAGMA Link_With("-lsimpleio");

  LOG_PROGNAME : CONSTANT String := "" & ASCII.NUL;

  -- syslog option constants (extracted from syslog.h)

  LOG_PID      : CONSTANT Integer := 16#0001#; -- log the pid with each message
  LOG_CONS     : CONSTANT Integer := 16#0002#; -- log on the console if errors in sending
  LOG_ODELAY   : CONSTANT Integer := 16#0004#; -- delay open until first syslog() (default)
  LOG_NDELAY   : CONSTANT Integer := 16#0008#; -- don't delay open
  LOG_NOWAIT   : CONSTANT Integer := 16#0010#; -- don't wait for console forks: DEPRECATED
  LOG_PERROR   : CONSTANT Integer := 16#0020#; -- log to stderr as well

  -- syslog facility constants (extracted from syslog.h)

  LOG_KERN     : CONSTANT Integer := 16#0000#;
  LOG_USER     : CONSTANT Integer := 16#0008#;
  LOG_MAIL     : CONSTANT Integer := 16#0010#;
  LOG_DAEMON   : CONSTANT Integer := 16#0018#;
  LOG_AUTH     : CONSTANT Integer := 16#0020#;
  LOG_SYSLOG   : CONSTANT Integer := 16#0028#;
  LOG_LPR      : CONSTANT Integer := 16#0030#;
  LOG_NEWS     : CONSTANT Integer := 16#0038#;
  LOG_UUCP     : CONSTANT Integer := 16#0040#;
  LOG_CRON     : CONSTANT Integer := 16#0048#;
  LOG_AUTHPRIV : CONSTANT Integer := 16#0050#;
  LOG_FTP      : CONSTANT Integer := 16#0058#;
  LOG_LOCAL0   : CONSTANT Integer := 16#0080#;
  LOG_LOCAL1   : CONSTANT Integer := 16#0088#;
  LOG_LOCAL2   : CONSTANT Integer := 16#0090#;
  LOG_LOCAL3   : CONSTANT Integer := 16#0098#;
  LOG_LOCAL4   : CONSTANT Integer := 16#00A0#;
  LOG_LOCAL5   : CONSTANT Integer := 16#00A8#;
  LOG_LOCAL6   : CONSTANT Integer := 16#00B0#;
  LOG_LOCAL7   : CONSTANT Integer := 16#00B8#;

  -- syslog priority constants (extracted from syslog.h)

  LOG_EMERG    : CONSTANT Integer := 0; -- system is unusable
  LOG_ALERT    : CONSTANT Integer := 1; -- action must be taken immediately
  LOG_CRIT     : CONSTANT Integer := 2; -- critical conditions
  LOG_ERR      : CONSTANT Integer := 3; -- error conditions
  LOG_WARNING  : CONSTANT Integer := 4; -- warning conditions
  LOG_NOTICE   : CONSTANT Integer := 5; -- normal but significant condition
  LOG_INFO     : CONSTANT Integer := 6; -- informational
  LOG_DEBUG    : CONSTANT Integer := 7; -- debug-level messages

  PROCEDURE Detach
   (error    : OUT Integer);
  PRAGMA Import(C, Detach, "LINUX_detach");

  PROCEDURE DropPrivileges
   (username : String;
    error    : OUT Integer);
  PRAGMA Import(C, DropPrivileges, "LINUX_drop_privileges");

  PROCEDURE OpenLog
   (ident    : String;
    options  : Integer;
    facility : Integer;
    error    : OUT Integer);
  PRAGMA Import(C, OpenLog, "LINUX_openlog");

  PROCEDURE Syslog
   (priority : Integer;
    message  : String;
    error    : OUT Integer);
  PRAGMA Import(C, Syslog, "LINUX_syslog");

  FUNCTION ErrNo RETURN Integer;
  PRAGMA Import(C, ErrNo, "LINUX_errno");

  PROCEDURE StrError
   (error    : Integer;
    message  : OUT String;
    size     : Integer);
  PRAGMA Import(C, StrError, "LINUX_strerror");

  TYPE FilesType   IS ARRAY (Natural RANGE <>) OF Integer;
  TYPE EventsType  IS ARRAY (Natural RANGE <>) OF Integer;
  TYPE ResultsType IS ARRAY (Natural RANGE <>) OF Integer;

  POLLIN   : CONSTANT Integer := 16#0001#;
  POLLPRI  : CONSTANT Integer := 16#0002#;
  POLLOUT  : CONSTANT Integer := 16#0004#;
  POLLERR  : CONSTANT Integer := 16#0008#;
  POLLHUP  : CONSTANT Integer := 16#0010#;
  POLLNVAL : CONSTANT Integer := 16#0020#;

  PROCEDURE Poll
   (numfiles  : Integer;
    files     : IN OUT FilesType;
    events    : IN OUT EventsType;
    results   : IN OUT ResultsType;
    timeoutms : Integer;
    error     : OUT Integer);
  PRAGMA Import(C, Poll, "LINUX_poll");

  PROCEDURE USleep
   (usecs : Integer;
    error : OUT Integer);
  PRAGMA Import(C, USleep, "LINUX_usleep");

  PROCEDURE Command
   (cmd    : string;
    status : OUT Integer;
    error  : OUT Integer);
  PRAGMA Import(C, Command, "LINUX_command");

  PROCEDURE Open
   (name  : String;
    fd    : OUT Integer;
    error : OUT Integer);
  PRAGMA Import(C, Open, "LINUX_open_readwrite");

  PROCEDURE OpenRead
   (name  : String;
    fd    : OUT Integer;
    error : OUT Integer);
  PRAGMA Import(C, OpenRead, "LINUX_open_read");

  PROCEDURE OpenWrite
   (name  : String;
    fd    : OUT Integer;
    error : OUT Integer);
  PRAGMA Import(C, OpenWrite, "LINUX_open_write");

  PROCEDURE OpenReadWrite
   (name  : String;
    fd    : OUT Integer;
    error : OUT Integer);
  PRAGMA Import(C, OpenReadWrite, "LINUX_open_readwrite");

  PROCEDURE OpenCreate
   (name  : String;
    mode  : Integer;
    fd    : OUT Integer;
    error : OUT Integer);
  PRAGMA Import(C, OpenCreate, "LINUX_open_create");

  PROCEDURE Read
   (fd      : Integer;
    buf     : System.Address;
    bufsize : Integer;
    count   : OUT Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Read, "LINUX_read");

  PROCEDURE Write
   (fd      : Integer;
    buf     : System.Address;
    bufsize : Integer;
    count   : OUT Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Write, "LINUX_write");

  PROCEDURE Close
   (fd      : Integer;
    error   : OUT Integer);
  PRAGMA Import(C, Close, "LINUX_close");

  PROCEDURE POpenWrite
   (cmd     : String;
    stream  : OUT System.Address;
    error   : OUT Integer);
  PRAGMA Import(C, POpenWrite, "LINUX_popen_write");

  PROCEDURE POpenRead
   (cmd     : String;
    stream  : OUT System.Address;
    error   : OUT Integer);
  PRAGMA Import(C, POpenRead, "LINUX_popen_read");

  PROCEDURE PClose
   (stream  : System.Address;
    error   : OUT Integer);
  PRAGMA Import(C, PClose, "LINUX_pclose");
   
END libLinux;
