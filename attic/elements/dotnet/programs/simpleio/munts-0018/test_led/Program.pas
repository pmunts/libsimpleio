{ MUNTS-0018 Raspberry Pi Tutorial I/O Board LED Test }

{ Copyright (C)2023, Philip Munts dba Munts Technologies.                     }
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

namespace test_led;

  uses RemObjects.Elements.RTL;
  uses IO.Objects.SimpleIO.Platforms;

  procedure Main();

  begin
    writeLn;
    writeLn('MUNTS-0018 LED Test');
    writeLn;

{$IF OrangePiZero2W}
{$MESSAGE Compiling for OrangePiZero2W}
    var LED := MUNTS_0018.OrangePiZero2W.LEDOutputFactory(false);
{$ELSE}
{$MESSAGE Compiling for Raspberry Pi}
    var LED := MUNTS_0018.RaspberryPi.LEDOutputFactory(false);
{$ENDIF}

    loop
      begin
        LED.state := not LED.state;
        Thread.Sleep(1000);
      end;
  end;

end.
