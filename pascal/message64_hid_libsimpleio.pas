{ 64-byte message services using libsimpleio raw HID transport                }

{ Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.             }
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

UNIT Message64_HID_libsimpleio;

INTERFACE

  USES
    Message64;

  CONST
    DefaultVendor  = $16D0;  { Munts Technologies }
    DefaultProduct = $0AFA;  { USB HID device }

  TYPE
    Messenger = CLASS(TInterfacedObject, IMessenger)
      CONSTRUCTOR Create(vid : Integer = DefaultVendor;
        pid : Integer = DefaultProduct);

      PROCEDURE Send(cmd : Message);

      PROCEDURE Receive(VAR resp : Message);

      PROCEDURE Transaction(cmd : Message; VAR resp : Message);

      FUNCTION GetName : String;

      PROCEDURE GetInfo(VAR bustype : Integer; VAR vendor : Integer;
        VAR product : Integer);

    PRIVATE
      fd : Integer;
    END;

IMPLEMENTATION

  USES
    errno,
    libHIDRaw;

  { Create a Message64 messenger object using libsimpleio raw HID transport }

  CONSTRUCTOR Messenger.Create(vid : Integer; pid : Integer);

  VAR
    error  : Integer;

  BEGIN
    libHIDRaw.OpenID(vid, pid, Self.fd, error);

    IF error <> 0 THEN
      RAISE Message64_Error.create('ERROR: libHIDRaw.OpenID() failed, ' +
        strerror(error));
  END;

  { Send a Message64 message using libsimpleio raw HID transport }

  PROCEDURE Messenger.Send(cmd : Message);

  VAR
    count : Integer;
    error : Integer;

  BEGIN
    libHIDRaw.Send(Self.fd, @cmd, Message64.Size, count, error);

    IF error <> 0 THEN
      RAISE Message64_Error.create('ERROR: libHIDRaw.Send() failed, ' +
        strerror(error));
  END;

  { Receive a Message64 message using libsimpleio raw HID transport }

  PROCEDURE Messenger.Receive(VAR resp : Message);

  VAR
    count : Integer;
    error : Integer;

  BEGIN
    libHIDRaw.Receive(Self.fd, @resp, Message64.Size, count, error);

    IF error <> 0 THEN
      RAISE Message64_Error.create('ERROR: libHIDRaw.Send() failed, ' +
        strerror(error));
  END;

  { Perform a Message64 command/response transaction }

  PROCEDURE Messenger.Transaction(cmd : Message; VAR resp : Message);

  BEGIN
    Send(cmd);
    Receive(resp);
  END;

  { Get the HID device name }

  FUNCTION Messenger.GetName : String;

  VAR
    cname : ARRAY [0 .. 255] OF Char;
    error : Integer;

  BEGIN
    libHIDRaw.GetName(Self.fd, cname, SizeOf(cname), error);

    IF error <> 0 THEN
      RAISE Message64_Error.create('ERROR: libHIDRaw.GetName() failed, ' +
        strerror(error));

    GetName := cname;
  END;

  { Get the HID device bus type, vendor ID, and product ID information }

  PROCEDURE Messenger.GetInfo(VAR bustype : Integer; VAR vendor : Integer;
    VAR product : Integer);

  VAR
    error : Integer;

  BEGIN
    libHIDRaw.GetInfo(Self.fd, bustype, vendor, product, error);

    IF error <> 0 THEN
      RAISE Message64_Error.create('ERROR: libHIDRaw.GetInfo() failed, ' +
        strerror(error));
  END;

END.
