{ Copyright (C)2018-2023, Philip Munts dba Munts Technologies.                }
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

namespace test_query;

procedure ShowAvailable(title : String;
  channels : System.Collections.Generic.List<Integer>);

begin
  write(title);

  for each C in channels do
    write(' ' + C.ToString());

  writeLn;
end;

procedure Main(args : array of String);

begin
  writeLn;
  writeLn('Remote I/O Device Information Query');
  writeLn;

  var msg : IO.Objects.USB.HID.Messenger :=
    new IO.Objects.USB.HID.Messenger();

  var remdev : IO.Objects.RemoteIO.Device :=
    new IO.Objects.RemoteIO.Device(msg);

  writeLn(msg.Info);
  writeLn(remdev.Version);
  writeLn(remdev.Capabilities);
  writeLn;

  ShowAvailable('ADC Channels:', remdev.ADC_Available);
  ShowAvailable('GPIO Pins:   ', remdev.GPIO_Available);
  ShowAvailable('I2C Buses:   ', remdev.I2C_Available);
  ShowAvailable('SPI Devices: ', remdev.SPI_Available);
end;

end.
