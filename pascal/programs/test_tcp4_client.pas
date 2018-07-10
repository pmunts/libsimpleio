{ Linux Simple I/O Library IPv4 TCP client                                    }

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

PROGRAM test_tcp4_client(input, output);

USES
  errno,
  sysutils,
  libIPV4;

CONST
  port    = 1234;

TYPE
  BytePtr = ^Byte;

VAR
  addr    : Integer;
  error   : Integer;
  fd      : Integer;
  msg     : ShortString;
  count   : Integer;

BEGIN
  writeln('TCP4 Client Test');
  writeln;

  addr := 0;
  error := 0;

  IF ParamCount <> 2 THEN
    BEGIN
      writeln('Usage: test_tcp4_client <hostname> <port>');
      Halt(1);
    END;

  { Resolve the server's IPv4 address }

  IP_Resolve(PChar(ParamStr(1)), addr, error);
  IF error <> 0 THEN
    BEGIN
      writeln('IP_Resolve() for ', ParamStr(1), ' failed, ', strerror(error));
      Halt(1);
    END;

  { Connect to the server }

  TCP_Connect(addr, StrToInt(ParamStr(2)), fd, error);
  IF error <> 0 THEN
    BEGIN
      writeln('TCP_Connect() to ', ParamStr(1), ' failed, ', strerror(error));
      Halt(1);
    END;

  REPEAT
    write('Enter some text: ');
    readln(msg);

    msg := msg + #13#10; { append CR/LF }

    TCP_Send(fd, BytePtr(@msg)+1, Length(msg), count, error);

    CASE error OF
      0 {Success} : ;
      ECONNRESET  : BREAK;
      EPIPE       : BREAK;
    ELSE
      writeln('TCP_Send() failed, ', strerror(error));
      BREAK;
    END;
  UNTIL False;

  TCP_Close(fd, error);
  IF error <> 0 THEN
    BEGIN
      writeln('TCP_Close() failed, ', strerror(error));
      Halt(1);
    END;

  writeln('Connection closed.');
END.
