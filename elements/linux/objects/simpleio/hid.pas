{ Copyright (C)2024, Philip Munts.                                            }
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

namespace IO.Objects.SimpleIO.HID;

interface

  type Device = public class(Object, IO.Interfaces.Message64.MessengerInterface)
    public constructor
     (VID     : Cardinal;
      PID     : Cardinal;
      serial  : String := Nil;
      timeout : Cardinal := 1000);  { milliseconds, 0 = forever }

    { Send a HID report to a raw HID device }

    procedure Send(msg : IO.Interfaces.Message64.Message);

    { Receive a HID report from a raw HID device }

    procedure Receive(var msg : IO.Interfaces.Message64.Message);

    { Get device name string }

    function GetName : String;

    { Retrieve underlying file descriptor }

    private function Getfd : Int32;

    public property fd : Int32 read Getfd;

    { Private internal state }

    private myfd      : Int32;
    private mytimeout : Cardinal;
  end;

implementation

  constructor Device
     (VID     : Cardinal;
      PID     : Cardinal;
      serial  : String := nil;
      timeout : Cardinal := 1000);  { milliseconds, 0 = forever }

  begin
    var error : Int32;

    if serial = nil then
      IO.Bindings.libsimpleio.HIDRAW_open3(VID, PID, '', @self.myfd, @error)
    else
      IO.Bindings.libsimpleio.HIDRAW_open3(VID, PID, serial, @self.myfd, @error);

    if error <> 0 then
      raise new Exception('HIDRAW_open3() failed, ' + errno.strerror(error));

    self.mytimeout := timeout;
  end;

  procedure Device.Send(msg : IO.Interfaces.Message64.Message);

  begin
    var count : Int32;
    var error : Int32;

    IO.Bindings.libsimpleio.HIDRAW_send(self.fd, @msg, length(msg),
      @count, @error);

    if error <> 0 then
      raise new Exception('HIDRAW_send() failed, ' + errno.strerror(error));

    if count <> length(msg) then
      raise new Exception('HIDRAW_send() failed, count <> 64');
  end;

  procedure Device.Receive(var msg : IO.Interfaces.Message64.Message);

  begin
    var count : Int32;
    var error : Int32;

    { Wait a limited period for an incoming HID report }

    if self.mytimeout > 0 then
      begin
        var files   : Int32 := self.myfd;
        var events  : Int32 := IO.Bindings.libsimpleio.POLLIN;
        var results : Int32 := 0;

        IO.Bindings.libsimpleio.LINUX_poll(1, @files, @events, @results,
          self.mytimeout, @error);

        if error = errno.EAGAIN then
          raise new Exception('LINUX_poll() timed out');

        if error <> 0 then
          raise new Exception('LINUX_poll() failed, ' + errno.strerror(error));
      end;

    IO.Bindings.libsimpleio.HIDRAW_receive(self.fd, @msg, length(msg),
      @count, @error);

    if error <> 0 then
      raise new Exception('HIDRAW_receive() failed, ' + errno.strerror(error));

    if count <> length(msg) then
      raise new Exception('HIDRAW_receive() failed, count <> 64');
  end;

  function Device.GetName: String;

  begin
    var buf   : array [0 .. 255] of AnsiChar;
    var error : Int32;

    IO.Bindings.libsimpleio.HIDRAW_get_name(self.fd, @buf, 255, @error);

    if error <> 0 then
      raise new Exception('HIDRAW_receive() failed, ' + errno.strerror(error));

    GetName := String.FromPAnsiChar(@buf);
  end;

  function Device.Getfd : Int32;

  begin
    Getfd := self.myfd;
  end;

end.