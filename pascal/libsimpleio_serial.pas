{ FreePascal bindings for libsimpleio (http://git.munts.com/libsimpleio)      }

{ Copyright (C)2014-2016, Philip Munts, President, Munts AM Corp.             }
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

UNIT libsimpleio_serial;

INTERFACE

  CONST
    PARITY_NONE = 0;
    PARITY_EVEN = 1;
    PARITY_ODD  = 2;

  PROCEDURE SERIAL_open
   (devname   : PChar;
    baudrate  : Integer;
    parity    : Integer;
    databits  : Integer;
    stopbits  : Integer;
    VAR fd    : Integer;
    VAR error : Integer); CDECL; EXTERNAL;

  PROCEDURE SERIAL_close
   (fd        : Integer;
    VAR error : Integer); CDECL; EXTERNAL;

  PROCEDURE SERIAL_send
   (fd        : Integer;
    buf       : Pointer;
    size      : Integer;
    VAR error : Integer); CDECL; EXTERNAL;

  PROCEDURE SERIAL_receive
   (fd        : Integer;
    buf       : Pointer;
    VAR size  : Integer;
    VAR error : Integer); CDECL; EXTERNAL;

IMPLEMENTATION

  USES
    initc;

  {$linklib libsimpleio}
END.
