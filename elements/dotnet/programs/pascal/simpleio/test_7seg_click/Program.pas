{ Mikroelektronika 7seg Click Test                                            }

{ Copyright (C)2020, Philip Munts, President, Munts AM Corp.                  }
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

namespace test_7seg_click;

  uses
    IO.Devices.ClickBoards.SimpleIO.SevenSegment;

  procedure Main(args: array of String);

  begin
    writeLn;
    writeLn('Mikroelektronika 7seg Click Test');
    writeLn;

    write('Socket number?  ');
    var socket := Integer.Parse(readLn());

    var disp := new Board(socket);

    { Test decimal mode }

    disp.Clear;
    disp.radix := Board.Base.Decimal;
    disp.blanking := Board.ZeroBlanking.Leading;

    RemObjects.Elements.RTL.Thread.Sleep(1000);

    for i : Integer := 0 to 99 do
      begin
        disp.state := i;
        RemObjects.Elements.RTL.Thread.Sleep(100);
      end;

    RemObjects.Elements.RTL.Thread.Sleep(1000);

    for i : Integer := 99 downto 0 do
      begin
        disp.state := i;
        RemObjects.Elements.RTL.Thread.Sleep(100);
      end;

    RemObjects.Elements.RTL.Thread.Sleep(1000);

    { Text hexadecimal mode }

    disp.Clear;
    disp.radix := Board.Base.Hexadecimal;
    disp.blanking := Board.ZeroBlanking.Leading;

    RemObjects.Elements.RTL.Thread.Sleep(1000);

    for i : Integer := 0 to 255 do
      begin
        disp.state := i;
        RemObjects.Elements.RTL.Thread.Sleep(100);
      end;

    RemObjects.Elements.RTL.Thread.Sleep(1000);

    for i : Integer := 255 downto 0 do
      begin
        disp.state := i;
        RemObjects.Elements.RTL.Thread.Sleep(100);
      end;

    RemObjects.Elements.RTL.Thread.Sleep(1000);

    { Test decimal points }

    disp.Clear;
    disp.rightdp := true;
    RemObjects.Elements.RTL.Thread.Sleep(1000);
    disp.rightdp := false;
    RemObjects.Elements.RTL.Thread.Sleep(1000);
    disp.leftdp := true;
    RemObjects.Elements.RTL.Thread.Sleep(1000);
    disp.leftdp := false;
  end;

end.
