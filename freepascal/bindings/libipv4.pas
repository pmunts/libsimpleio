{ FreePascal bindings for libsimpleio (https://github.com/pmunts/libsimpleio) }

{ Copyright (C)2016-2025, Philip Munts dba Munts Technologies.                }
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

UNIT libIPV4;

INTERFACE

  CONST
    INADDR_ANY       = $00000000;  { Bind to all network interfaces }
    INADDR_LOOPBACK  = $7F000001;  { Bind to loopback interface aka localhost }
    INADDR_BROADCAST = $FFFFFFFF;

    (* Flags for UDP4_Send() and UDP4_Receive() *)

    MSG_DONTROUTE    = $0004;
    MSG_DONTWAIT     = $0040;
    MSG_MORE         = $8000;

  PROCEDURE IP_Resolve
   (hostname  : PChar;
    VAR addr  : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'IPV4_resolve';

  PROCEDURE IP_NtoA
   (addr      : Integer;
    dst       : PChar;
    dstsize   : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'IPV4_ntoa';

  PROCEDURE TCP_Connect
   (addr      : Integer;
    port      : Integer;
    VAR fd    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_connect';

  PROCEDURE TCP_Accept
   (addr      : Integer;
    port      : Integer;
    VAR fd    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_accept';

  PROCEDURE TCP_Server
   (addr      : Integer;
    port      : Integer;
    VAR fd    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_server';

  PROCEDURE TCP_Close
   (fd        : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_close';

  PROCEDURE TCP_Send
   (fd        : Integer;
    buf       : Pointer;
    size      : Integer;
    VAR count : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_send';

  PROCEDURE TCP_Receive
   (fd        : Integer;
    buf       : Pointer;
    size      : Integer;
    VAR count : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_receive';

  PROCEDURE UDP4_Open
   (host      : Integer;
    port      : Integer;
    VAR fd    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'UDP4_open';

  PROCEDURE UDP4_Close
   (fd        : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'UDP4_close';

  PROCEDURE UDP4_Send
   (fd        : Integer;
    host      : Integer;
    port      : Integer;
    buf       : Pointer;
    bufsize   : Integer;
    flags     : Integer;
    VAR count : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'UDP4_send';

  PROCEDURE UDP4_Receive
   (fd        : Integer;
    VAR host  : Integer;
    VAR port  : Integer;
    buf       : Pointer;
    bufsize   : Integer;
    flags     : Integer;
    VAR count : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'UDP4_receive';

IMPLEMENTATION

  USES
    initc;

  {$linklib libsimpleio}
END.
