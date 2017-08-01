{ FreePascal bindings for libsimpleio (http://git.munts.com/libsimpleio)      }

{ Copyright (C)2016-2017, Philip Munts, President, Munts AM Corp.             }
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

UNIT libTCP4;

INTERFACE

  CONST
    INADDR_ANY      = $00000000;
    INADDR_LOOPBACK = $7F000001;

  PROCEDURE Resolve
   (hostname  : PChar;
    VAR addr  : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_resolve';

  PROCEDURE NtoA
   (addr      : Integer;
    dst       : PChar;
    dstsize   : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_ntoa';

  PROCEDURE Connect
   (addr      : Integer;
    port      : Integer;
    VAR fd    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_connect';

  PROCEDURE Accept
   (addr      : Integer;
    port      : Integer;
    VAR fd    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_accept';

  PROCEDURE Server
   (addr      : Integer;
    port      : Integer;
    VAR fd    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_server';

  PROCEDURE Close
   (fd        : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_close';

  PROCEDURE Send
   (fd        : Integer;
    buf       : Pointer;
    size      : Integer;
    VAR count : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_send';

  PROCEDURE Receive
   (fd        : Integer;
    buf       : Pointer;
    size      : Integer;
    VAR count : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'TCP4_receive';

IMPLEMENTATION

  USES
    initc;

  {$linklib libsimpleio}
END.
