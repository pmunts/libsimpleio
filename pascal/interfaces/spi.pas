{ Abstract interface for SPI devices }

{ Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.             }
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

UNIT SPI;

INTERFACE

  USES
    SysUtils;

  TYPE

    { Define an exception for SPI errors }

    SPI_Error = CLASS(Exception);

    { Define an interface for SPI devices }

    Device = INTERFACE

      { SPI read method }

      PROCEDURE Read
       (VAR resp : ARRAY OF Byte;
        resplen  : Cardinal);

      { SPI write method }

      PROCEDURE Write
       (cmd    : ARRAY OF Byte;
        cmdlen : Cardinal);

      { Combined SPI Write/Read method }

      PROCEDURE Transaction
       (cmd      : ARRAY OF Byte;
        cmdlen   : Cardinal;
        VAR resp : ARRAY OF Byte;
        resplen  : Cardinal;
        delayus  : Cardinal = 0);
    END;

IMPLEMENTATION

END.
