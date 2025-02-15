{ FreePascal bindings for libsimpleio (http://git.munts.com/libsimpleio)      }

{ Copyright (C)2016-2023, Philip Munts dba Munts Technologies.                }
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

UNIT libSerial;

INTERFACE

  CONST
    PARITY_NONE  = 0;
    PARITY_EVEN  = 1;
    PARITY_ODD   = 2;
    FLUSH_INPUT  = 0
    FLUSH_OUTPUT = 1;
    FLUSH_BOTH   = 2;

  PROCEDURE Open
   (devname   : PChar;
    baudrate  : Integer;
    parity    : Integer;
    databits  : Integer;
    stopbits  : Integer;
    VAR fd    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'SERIAL_open';

  PROCEDURE Close
   (fd        : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'SERIAL_close';

  PROCEDURE Send
   (fd        : Integer;
    buf       : Pointer;
    size      : Integer;
    VAR count : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'SERIAL_send';

  PROCEDURE Receive
   (fd        : Integer;
    buf       : Pointer;
    size      : Integer;
    VAR count : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'SERIAL_receive';

  PROCEDURE Flush
   (fd        : Integer;
    what      : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'SERIAL_flush';

IMPLEMENTATION

  USES
    initc;

  {$linklib libsimpleio}
END.
