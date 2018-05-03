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

UNIT libGPIO;

INTERFACE

  { Old GPIO sysfs API }

  CONST
    DIRECTION_INPUT     = 0;
    DIRECTION_OUTPUT    = 1;

    EDGE_NONE           = 0;
    EDGE_RISING         = 1;
    EDGE_FALLING        = 2;
    EDGE_BOTH           = 3;

    POLARITY_ACTIVELOW  = 0;
    POLARITY_ACTIVEHIGH = 1;

  PROCEDURE Configure
   (pin       : integer;
    direction : integer;
    state     : Integer;
    edge      : Integer;
    polarity  : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'GPIO_configure';

  PROCEDURE Open
   (pin       : Integer;
    VAR fd    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'GPIO_open';

  PROCEDURE Close
   (fd        : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'GPIO_close';

  PROCEDURE Read
   (fd        : Integer;
    VAR state : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'GPIO_read';

  PROCEDURE Write
   (fd        : Integer;
    state     : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'GPIO_write';

  { New GPIO descriptor API }

  CONST
    LINE_INFO_KERNEL         = $0001;
    LINE_INFO_OUTPUT         = $0002;
    LINE_INFO_ACTIVE_LOW     = $0004;
    LINE_INFO_OPEN_DRAIN     = $0008;
    LINE_INFO_OPEN_SOURCE    = $0010;

    LINE_REQUEST_INPUT       = $0001;
    LINE_REQUEST_OUTPUT      = $0002;

    LINE_REQUEST_ACTIVE_HIGH = $0000;
    LINE_REQUEST_ACTIVE_LOW  = $0004;

    LINE_REQUEST_PUSH_PULL   = $0000;
    LINE_REQUEST_OPEN_DRAIN  = $0008;
    LINE_REQUEST_OPEN_SOURCE = $0010;

    LINE_REQUEST_NONE        = $0000;
    LINE_REQUEST_RISING      = $0001;
    LINE_REQUEST_FALLING     = $0002;
    LINE_REQUEST_BOTH        = $0003;

  PROCEDURE ChipInfo
   (chip      : Integer;
    name      : PChar;
    namelen   : Integer;
    slabel    : PChar;
    labellen  : Integer;
    VAR lines : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'GPIO_chip_info';

  PROCEDURE LineInfo
   (chip      : Integer;
    line      : Integer;
    VAR flags : Integer;
    name      : PChar;
    namelen   : Integer;
    consumer  : PChar;
    consumerlen : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'GPIO_line_info';

  PROCEDURE LineOpen
   (chip      : Integer;
    line      : Integer;
    flags     : Integer;
    events    : Integer;
    state     : Integer;
    VAR fd    : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'GPIO_line_open';

  PROCEDURE LineRead
   (fd        : Integer;
    VAR state : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'GPIO_line_read';

  PROCEDURE LineWrite
   (fd        : Integer;
    state     : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'GPIO_line_write';

  PROCEDURE LineEvent
   (fd        : Integer;
    VAR state : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'GPIO_line_event';

  PROCEDURE LineClose
   (fd        : Integer;
    VAR error : Integer); CDECL; EXTERNAL NAME 'GPIO_line_close';

IMPLEMENTATION

  USES
    initc;

  {$linklib libsimpleio}
END.
