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

UNIT libHIDRaw;

INTERFACE

  PROCEDURE Open
   (name        : PChar;
    VAR fd      : Integer;
    VAR error   : Integer); CDECL; EXTERNAL NAME 'HIDRAW_open';

  PROCEDURE OpenID
   (vendor      : Integer;
    product     : Integer;
    VAR fd      : Integer;
    VAR error   : Integer); CDECL; EXTERNAL NAME 'HIDRAW_open_id';

  PROCEDURE Close
   (fd          : Integer;
    VAR error   : Integer); CDECL; EXTERNAL NAME 'HIDRAW_close';

  PROCEDURE GetName
   (fd          : Integer;
    name        : PChar;
    size        : Integer;
    VAR error   : Integer); CDECL; EXTERNAL NAME 'HIDRAW_get_name';

  PROCEDURE GetInfo
   (fd          : Integer;
    VAR bustype : Integer;
    VAR vendor  : Integer;
    VAR product : Integer;
    VAR error   : Integer); CDECL; EXTERNAL NAME 'HIDRAW_get_info';

  PROCEDURE Send
   (fd          : Integer;
    buf         : Pointer;
    bufsize     : Integer;
    VAR count   : Integer;
    VAR error   : Integer); CDECL; EXTERNAL NAME 'HIDRAW_send';

  PROCEDURE Receive
   (fd          : Integer;
    buf         : Pointer;
    bufsize     : Integer;
    VAR count   : Integer;
    VAR error   : Integer); CDECL; EXTERNAL NAME 'HIDRAW_receive';

IMPLEMENTATION

  USES
    initc;

  {$linklib libsimpleio}
END.
