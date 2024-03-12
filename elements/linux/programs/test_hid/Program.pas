{ Raw HID Test using libsimpleio }

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

namespace test_hid;

  procedure Main(args : array of String);

  begin
    writeLn;
    writeLn('Raw HID Test using libsimpleio');
    writeLn;

    { Create raw HID device object }

    var dev := new IO.Objects.SimpleIO.HID.Device(IO.Objects.HID.Munts.VID,
      IO.Objects.HID.Munts.PID);

    { Display raw HID device name }

    writeLn('Device Info: ' + dev.GetName);
    writeLn;

    { Send a command to the raw HID device }

    var cmd : IO.Interfaces.Message64.Message;
    IO.Interfaces.Message64.Zero(var cmd);
    dev.Send(cmd);

    { Receive a response from the raw HID device }

    var resp : IO.Interfaces.Message64.Message;
    IO.Interfaces.Message64.Zero(var resp);
    dev.Receive(var resp);

    { Dump results }

    IO.Interfaces.Message64.Dump(cmd);
    IO.Interfaces.Message64.Dump(resp);
  end;

end.