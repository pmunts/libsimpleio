{ 64-byte message services using libsimpleio raw HID transport                }

{ Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.             }
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

{ Allowed values for the timeout parameter:                               }
{                                                                         }
{ -1 => Receive operation blocks forever, until a report is received      }
{  0 => Receive operation never blocks at all                             }
{ >0 => Receive operation blocks for the indicated number of milliseconds }

UNIT HID_libsimpleio;

INTERFACE

  USES
    Message64;

  TYPE
    MessengerSubclass = CLASS(TInterfacedObject, Message64.Messenger)
      CONSTRUCTOR Create(vid : Cardinal; pid : Cardinal; serial : String = '';
        timeoutms : Integer = 1000);

      DESTRUCTOR Destroy; OVERRIDE;

      PROCEDURE Send(cmd : Message);

      PROCEDURE Receive(VAR resp : Message);

      PROCEDURE Transaction(cmd : Message; VAR resp : Message);

      PROCEDURE GetInfo(VAR bustype : Integer; VAR vendor : Integer;
        VAR product : Integer);

      FUNCTION Name : String;

    PRIVATE
      fd      : Integer;
      timeout : Integer;
    END;

IMPLEMENTATION

  USES
    errno,
    libHIDRaw,
    libLinux;

  { Create a Message64 messenger object using libsimpleio raw HID transport }

  CONSTRUCTOR MessengerSubclass.Create(vid : Cardinal; pid : Cardinal;
    serial : String; timeoutms : Integer);

  VAR
    error  : Integer;

  BEGIN
    Self.fd := -1;

    IF timeoutms < -1 THEN
      RAISE Message64.Error.Create('ERROR: timeoutms parameter is out of range');

    libHIDRaw.Open3(vid, pid, PChar(serial), Self.fd, error);

    IF error <> 0 THEN
      RAISE Message64.Error.Create('ERROR: libHIDRaw.OpenID() failed, ' +
        errno.strerror(error));

    Self.timeout := timeoutms;
  END;

  { Destructor }

  DESTRUCTOR MessengerSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN
    IF Self.fd >= 0 THEN
      libHIDRaw.Close(Self.fd, error);

    INHERITED;
  END;

 { Send a Message64 message using libsimpleio raw HID transport }

  PROCEDURE MessengerSubclass.Send(cmd : Message);

  VAR
    count   : Integer;
    error   : Integer;

  BEGIN
    libHIDRaw.Send(Self.fd, @cmd, Message64.Size, count, error);

    IF error <> 0 THEN
      RAISE Message64.Error.Create('ERROR: libHIDRaw.Send() failed, ' +
        errno.strerror(error));
  END;

  { Receive a Message64 message using libsimpleio raw HID transport }

  PROCEDURE MessengerSubclass.Receive(VAR resp : Message);

  VAR
    files   : ARRAY [0 .. 0] OF Integer;
    events  : ARRAY [0 .. 0] OF Integer;
    results : ARRAY [0 .. 0] OF Integer;
    count   : Integer;
    error   : Integer;

  BEGIN
    IF Self.timeout > 0 THEN
      BEGIN
        files[0]   := Self.fd;
        events[0]  := libLinux.POLLIN;
        results[0] := 0;

        libLinux.Poll(1, files, events, results, Self.timeout, error);
        IF error <> 0 THEN
          RAISE Message64.Error.Create('ERROR: liblinux.Poll() failed, ' +
            errno.strerror(error));
      END;

    libHIDRaw.Receive(Self.fd, @resp, Message64.Size, count, error);

    IF error <> 0 THEN
      RAISE Message64.Error.Create('ERROR: libHIDRaw.Send() failed, ' +
        errno.strerror(error));
  END;

  { Perform a Message64 command/response transaction }

  PROCEDURE MessengerSubclass.Transaction(cmd : Message; VAR resp : Message);

  BEGIN
    Send(cmd);
    Receive(resp);
  END;

  { Get the HID device name }

  FUNCTION MessengerSubclass.Name : String;

  VAR
    cname : ARRAY [0 .. 255] OF Char;
    error : Integer;

  BEGIN
    libHIDRaw.GetName(Self.fd, cname, SizeOf(cname), error);

    IF error <> 0 THEN
      RAISE Message64.Error.Create('ERROR: libHIDRaw.Name() failed, ' +
        errno.strerror(error));

    Name := cname;
  END;

  { Get the HID device bus type, vendor ID, and product ID information }

  PROCEDURE MessengerSubclass.GetInfo(VAR bustype : Integer; VAR vendor : Integer;
    VAR product : Integer);

  VAR
    error : Integer;

  BEGIN
    libHIDRaw.GetInfo(Self.fd, bustype, vendor, product, error);

    IF error <> 0 THEN
      RAISE Message64.Error.Create('ERROR: libHIDRaw.GetInfo() failed, ' +
        errno.strerror(error));
  END;

END.
