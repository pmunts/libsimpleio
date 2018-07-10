{ Linux Simple I/O Library HID button test                                    }
{ See devices/HID_Button_LED/ for the corresponding USB device project        }

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

PROGRAM test_hid_button_led(input, output);

USES
  errno,
  sysutils,
  libhidraw;

VAR
  fd      : Integer;
  error   : Integer;
  name    : ARRAY [0 .. 255] OF char;
  bustype : Integer;
  vendor  : Integer;
  product : Integer;
  count   : Integer;
  rcvbuf  : ARRAY [0 .. 63] OF Byte;
  xmtbuf  : ARRAY [0 .. 63] OF Byte;

BEGIN
  writeln('HID Button and LED Test');
  writeln;

  IF ParamCount <> 1 THEN
    BEGIN
      writeln('Usage: test_hid_button_led <devname>');
      Halt(1);
    END;

  { Open the raw HID device }

  Open(PChar(ParamStr(1)), fd, error);
  IF error <> 0 THEN
    BEGIN
      writeln('Open() for ', ParamStr(1), ' failed, ', strerror(error));
      Halt(1);
    END;

  { Get raw HID device string }

  GetName(fd, name, SizeOf(name), error);
  IF error <> 0 THEN
    BEGIN
      writeln('GetName() failed, ', strerror(error));
      Halt(1);
    END;

  { Get raw HID device info }

  GetInfo(fd, bustype, vendor, product, error);
  IF error <> 0 THEN
    BEGIN
      writeln('GetInfo() failed, ', strerror(error));
      Halt(1);
    END;

  { Display device information }

  writeln('HID name     is ', name);
  writeln('HID bus type is ', IntToHex(bustype, 4));
  writeln('HID vendor   is ', IntToHex(vendor, 4));
  writeln('HID product  is ', IntToHex(product, 4));
  writeln;

  { Process incoming keypress reports }

  REPEAT
    FillByte(rcvbuf, 0, SizeOf(rcvbuf));
    FillByte(xmtbuf, 0, SizeOf(rcvbuf));

    Receive(fd, @rcvbuf, SizeOf(rcvbuf), count, error);
    IF error <> 0 THEN
      BEGIN
        writeln('Receive() failed, ', strerror(error));
        Halt(1);
      END;

    CASE rcvbuf[0] OF
      0 :
        BEGIN
          writeln('RELEASED');

          xmtbuf[0] := 0;

          Send(fd, @xmtbuf, SizeOf(xmtbuf), count, error);
          IF error <> 0 THEN
            BEGIN
              writeln('Send() failed, ', strerror(error));
              Halt(1);
            END;
        END;

      1 :
        BEGIN
          writeln('PRESSED');

          xmtbuf[0] := 1;

          Send(fd, @xmtbuf, SizeOf(xmtbuf), count, error);
          IF error <> 0 THEN
            BEGIN
              writeln('Send() failed, ', strerror(error));
              Halt(1);
            END;
        END;
    ELSE
      writeln('ERROR: Unexpected keypress status value');
    END;
  UNTIL False;
END.
