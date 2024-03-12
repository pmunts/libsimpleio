{ Copyright (C)2024, Philip Munts dba Munts Technologies.                     }
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

{ Define an abstract interface for sending and/or receiving fixed length }
{ messages                                                               }

namespace IO.Interfaces.Message64;

interface

  type Message = array [0 .. 63] of Byte;

  type MessengerInterface = public interface

    procedure Send(msg : Message);

    procedure Receive(var msg : Message);

  end;

  procedure Zero(var msg : Message);

  procedure Dump(msg : Message);

implementation

  procedure Zero(var msg : Message);

  begin
    for i := 0 to 63 do
      msg[i] := 0;
  end;

  procedure Dump(msg : Message);

  begin
    const hexchars = '0123456789ABCDEF';

    for i := 0 to 63 do
      begin
        write(hexchars[msg[i] div 16]);
        write(hexchars[msg[i] mod 16]);
        if i < 63 then write(' ');
      end;

    writeLn;
  end;

end.
