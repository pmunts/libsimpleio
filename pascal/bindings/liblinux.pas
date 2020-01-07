{ FreePascal bindings for libsimpleio (http://git.munts.com/libsimpleio)      }

{ Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.             }
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

UNIT libLinux;

INTERFACE

  CONST
    LOG_PROGNAME = '';

    { syslog option constants (extracted from syslog.h) }

    LOG_PID      = $0001; { log the pid with each message             }
    LOG_CONS     = $0002; { log on the console if errors in sending   }
    LOG_ODELAY   = $0004; { delay open until first syslog() (default) }
    LOG_NDELAY   = $0008; { don't delay open                          }
    LOG_NOWAIT   = $0010; { don't wait for console forks: DEPRECATED  }
    LOG_PERROR   = $0020; { log to stderr as well                     }

    { syslog facility constants (extracted from syslog.h) }

    LOG_KERN     = $0000;
    LOG_USER     = $0008;
    LOG_MAIL     = $0010;
    LOG_DAEMON   = $0018;
    LOG_AUTH     = $0020;
    LOG_SYSLOG   = $0028;
    LOG_LPR      = $0030;
    LOG_NEWS     = $0038;
    LOG_UUCP     = $0040;
    LOG_CRON     = $0048;
    LOG_AUTHPRIV = $0050;
    LOG_FTP      = $0058;
    LOG_LOCAL0   = $0080;
    LOG_LOCAL1   = $0088;
    LOG_LOCAL2   = $0090;
    LOG_LOCAL3   = $0098;
    LOG_LOCAL4   = $00A0;
    LOG_LOCAL5   = $00A8;
    LOG_LOCAL6   = $00B0;
    LOG_LOCAL7   = $00B8;

    { syslog priority constants (extracted from syslog.h) }

    LOG_EMERG    = 0; { system is unusable               }
    LOG_ALERT    = 1; { action must be taken immediately }
    LOG_CRIT     = 2; { critical conditions              }
    LOG_ERR      = 3; { error conditions                 }
    LOG_WARNING  = 4; { warning conditions               }
    LOG_NOTICE   = 5; { normal but significant condition }
    LOG_INFO     = 6; { informational                    }
    LOG_DEBUG    = 7; { debug-level messages             }

    { poll event constants (extracted from poll.h) }

    POLLIN       = $0001;
    POLLPRI      = $0002;
    POLLOUT      = $0004;
    POLLERR      = $0008;
    POLLHUP      = $0010;
    POLLNVAL     = $0020;

  { Detach process from controlling terminal and run in the background }

  PROCEDURE Detach
   (VAR error : Integer); CDECL; EXTERNAL NAME 'LINUX_detach';

  { Drop root privileges to those of specified  user }

  PROCEDURE DropPrivileges
   (username  : PChar;
    VAR error : Integer); CDECL; EXTERNAL NAME 'LINUX_drop_privileges';

  { Open connection to syslog facility }

  PROCEDURE OpenLog
   (id        : PChar;
    options   : Integer;
    facility  : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'LINUX_openlog';

  { Log a message to syslog facility }

  PROCEDURE Syslog
   (priority  : Integer;
    msg       : PChar;
    VAR error : Integer); CDECL; EXTERNAL NAME 'LINUX_syslog';

  { Retrieve errno }

  FUNCTION ErrNo : Integer; CDECL; EXTERNAL NAME 'LINUX_errno';

  { Retrieve an error message }

  PROCEDURE StrError
   (error     : Integer;
    msg       : PChar;
    size      : Integer); CDECL; EXTERNAL NAME 'LINUX_strerror';

  { Wait for I/O ready }

  PROCEDURE Poll
   (numfiles    : Integer;
    VAR files   : ARRAY OF Integer;
    VAR events  : ARRAY OF Integer;
    VAR results : ARRAY OF Integer;
    timeoutms   : Integer;
    VAR error   : Integer); CDECL; EXTERNAL NAME 'LINUX_poll';

  { Sleep for awhile }

  PROCEDURE USleep
   (microsecs : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'LINUX_usleep';

  PROCEDURE Command
   (cmd        : PChar;
    VAR status : Integer;
    VAR error  : Integer); CDECL; EXTERNAL NAME 'LINUX_command';

IMPLEMENTATION

  USES
    initc;

  {$linklib libsimpleio}
END.
