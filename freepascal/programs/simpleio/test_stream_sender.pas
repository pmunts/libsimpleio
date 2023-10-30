{ Linux Simple I/O Library Stream Framing Protocol sender                     }

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

PROGRAM test_stream_sender;

USES
  BaseUnix,
  Errors,
  SysUtils,
  libStream,
  libIPV4;

CONST
  host      = INADDR_LOOPBACK;
  port      = 12345;

TYPE
  BytePtr   = ^Byte;

VAR
  fd        : Integer;
  error     : Integer;
  msg       : String;
  frame     : ARRAY [0 .. 255] OF Byte;
  framesize : Integer;
  count     : Integer;

BEGIN
  Writeln('Stream Framing Protocol Sender Test');
  Writeln;

  libIPV4.TCP_Connect(host, port, fd, error);
  IF error <> 0 THEN
    BEGIN
      Writeln('ERROR: TCP_Connect() failed, ', StrError(error));
      Halt(1);
    END;

  framesize := 0;

  REPEAT
    Readln(msg);

    libStream.Encode(BytePtr(@msg)+1, Length(msg), @frame, SizeOf(frame), framesize, error);
    IF error <> 0 THEN
      BEGIN
        Writeln('ERROR: Encode() failed, ', StrError(error));
        Halt(1);
      END;

    libStream.Send(fd, @frame, framesize, count, error);
    IF error = ESysEPIPE THEN EXIT;

    IF error <> 0 THEN
      BEGIN
        Writeln('ERROR: Send() failed, ', StrError(error));
        Halt(1);
      END;
  UNTIL msg = 'quit';

  libIPV4.TCP_Close(fd, error);
  IF error <> 0 THEN
    BEGIN
      Writeln('TCP_Close() failed, ', StrError(error));
      Halt(1);
    END;
END.
