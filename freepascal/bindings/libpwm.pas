{ FreePascal bindings for libsimpleio (https://github.com/pmunts/libsimpleio) }

{ Copyright (C)2017-2025, Philip Munts dba Munts Technologies.                }
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

UNIT libPWM;

INTERFACE

  CONST
    POLARITY_ACTIVELOW  = 0;	{ Not allowed by some PWM controllers }
    POLARITY_ACTIVEHIGH = 1;

  PROCEDURE Configure
   (chip      : Integer;
    channel   : Integer;
    period    : Integer;	{ nanoseconds }
    ontime    : Integer;	{ nanoseconds }
    polarity  : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'PWM_configure';

  PROCEDURE Open
   (chip      : Integer;
    channel   : Integer;
    VAR fd    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'PWM_open';

  PROCEDURE Close
   (fd        : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'PWM_close';

  PROCEDURE Write
   (fd        : Integer;
    ontime    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'PWM_write';

IMPLEMENTATION

  USES
    initc;

  {$linklib libsimpleio}
END.
