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

UNIT HID_libhidraw;

INTERFACE

  USES
    Message64;

  TYPE
    MessengerSubclass = CLASS(TInterfacedObject, Message64.Messenger)
      CONSTRUCTOR Create(vid : Cardinal; pid : Cardinal;
        timeoutms : Cardinal = 1000);

      DESTRUCTOR Destroy; OVERRIDE;

      PROCEDURE Send(cmd : Message);

      PROCEDURE Receive(VAR resp : Message);

      PROCEDURE Transaction(cmd : Message; VAR resp : Message);

      FUNCTION GetName : String;

      PROCEDURE GetInfo(VAR bustype : Integer; VAR vendor : Integer;
        VAR product : Integer);

    PRIVATE
      fd      : Integer;
      timeout : Cardinal;
    END;

IMPLEMENTATION

  USES
    errno,
    libHIDRaw,
    libLinux;

  { Create a Message64 messenger object using libsimpleio raw HID transport }

  CONSTRUCTOR MessengerSubclass.Create(vid : Cardinal; pid : Cardinal;
    timeoutms : Cardinal);

  VAR
    error  : Integer;

  BEGIN
    libHIDRaw.OpenID(vid, pid, Self.fd, error);

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

  FUNCTION MessengerSubclass.GetName : String;

  VAR
    cname : ARRAY [0 .. 255] OF Char;
    error : Integer;

  BEGIN
    libHIDRaw.GetName(Self.fd, cname, SizeOf(cname), error);

    IF error <> 0 THEN
      RAISE Message64.Error.Create('ERROR: libHIDRaw.GetName() failed, ' +
        errno.strerror(error));

    GetName := cname;
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