{ FreePascal bindings for libsimpleio (http://git.munts.com/libsimpleio)      }

{ Copyright (C)2017-2023, Philip Munts dba Munts Technologies.                }
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

UNIT libADC;

INTERFACE

  PROCEDURE GetName
   (chip       : Integer;
    name       : PChar;
    size       : Integer;
    VAR error  : Integer); CDECL; EXTERNAL NAME 'ADC_get_name';

  PROCEDURE Open
   (chip       : Integer;
    channel    : Integer;
    VAR fd     : Integer;
    VAR error  : Integer); CDECL; EXTERNAL NAME 'ADC_open';

  PROCEDURE Close
   (fd         : Integer;
    VAR error  : Integer); CDECL; EXTERNAL NAME 'ADC_close';

  PROCEDURE Read
   (fd         : Integer;
    VAR sample : Integer;
    VAR error  : Integer); CDECL; EXTERNAL NAME 'ADC_read';

IMPLEMENTATION

  USES
    initc;

  {$linklib libsimpleio}
END.
