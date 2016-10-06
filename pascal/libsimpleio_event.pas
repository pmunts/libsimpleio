{ FreePascal bindings for libsimpleio (http://git.munts.com/libsimpleio)      }

{ Copyright (C)2016, Philip Munts, President, Munts AM Corp.                  }
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

UNIT libsimpleio_Event;

INTERFACE

  CONST

    { epoll events, extracted from /usr/include/sys/epoll.h }

    EPOLLIN      = $00000001;
    EPOLLPRI     = $00000002;
    EPOLLOUT     = $00000004;
    EPOLLRDNORM  = $00000040;
    EPOLLRDBAND  = $00000080;
    EPOLLWRNORM  = $00000100;
    EPOLLWRBAND  = $00000200;
    EPOLLMSG     = $00000400;
    EPOLLERR     = $00000008;
    EPOLLHUP     = $00000010;
    EPOLLRDHUP   = $00002000;
    EPOLLWAKEUP  = $20000000;
    EPOLLONESHOT = $40000000;
    EPOLLET      = $80000000;

  PROCEDURE Open
   (VAR error : Integer); CDECL; EXTERNAL NAME 'Event_open';

  PROCEDURE Close
   (VAR error : Integer); CDECL; EXTERNAL NAME 'Event_close';

  PROCEDURE Register
   (fd        : Integer;
    events    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'EVENT_register_fd';

  PROCEDURE Unregister
   (fd        : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'EVENT_unregister_fd';

  PROCEDURE Wait
   (VAR fd    : Integer;
    VAR event : Integer;
    timeoutms : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'EVENT_wait';

IMPLEMENTATION

  USES
    initc;

  {$linklib libsimpleio}
END.
