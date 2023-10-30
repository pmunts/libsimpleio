{ 64-byte message services using Posix file I/O services }

{ Copyright (C)2020-2023, Philip Munts dba Munts Technologies.                }
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
{  0 => Receive operation blocks forever, until a report is received      }
{ >0 => Receive operation blocks for the indicated number of milliseconds }

UNIT HID_posix;

INTERFACE

  USES
    Message64;

  TYPE
    MessengerSubclass = CLASS(TInterfacedObject, Message64.Messenger)
      CONSTRUCTOR Create(vid : Cardinal; pid : Cardinal; serial : String = '';
        timeoutms : Cardinal = 1000);

      DESTRUCTOR Destroy; OVERRIDE;

      PROCEDURE Send(cmd : Message);

      PROCEDURE Receive(VAR resp : Message);

      PROCEDURE Transaction(cmd : Message; VAR resp : Message);

    PRIVATE
      fd      : Integer;
      timeout : Cardinal;
    END;

IMPLEMENTATION

  USES
    BaseUnix,
    Errors,
    SysUtils;

  { Create a Message64 messenger object using libsimpleio raw HID transport }

  CONSTRUCTOR MessengerSubclass.Create(vid : Cardinal; pid : Cardinal;
    serial : String; timeoutms : Cardinal);

  VAR
    filename : String;
    error  : LongInt;

  BEGIN
    filename := '/dev/hidraw-' + LowerCase(IntToHex(vid, 4)) + ':' +
      LowerCase(IntToHex(pid, 4));

    IF serial <> '' THEN
      filename := filename + '-' + serial;

    Self.fd := fpOpen(filename, O_RdWr);

    IF Self.fd < 0 THEN
      BEGIN
        error := fpGetErrno;
        RAISE Message64.Error.Create('ERROR: fpOpen() failed, ' + StrError(error));
      END;

    Self.timeout := timeoutms;
  END;

  { Destructor }

  DESTRUCTOR MessengerSubclass.Destroy;

  VAR
    error  : Integer;

  BEGIN
    IF Self.fd >= 0 THEN
      BEGIN
        fpClose(Self.fd);
        Self.fd := -1;
      END;

    INHERITED;
  END;

 { Send a Message64 message using libsimpleio raw HID transport }

  PROCEDURE MessengerSubclass.Send(cmd : Message);

  VAR
    count   : TsSize;
    error   : Integer;

  BEGIN
    count := fpWrite(Self.fd, @cmd, Message64.Size);

    IF count < 0 THEN
      BEGIN
        error := fpGetErrno;
        RAISE Message64.Error.Create('ERROR: fpWrite() failed, ' + StrError(error));
      END;
  END;

  { Receive a Message64 message using libsimpleio raw HID transport }

  PROCEDURE MessengerSubclass.Receive(VAR resp : Message);

  VAR
    fds     : pollfd;
    status  : Integer;
    count   : TsSize;
    error   : Integer;

  BEGIN
    IF Self.timeout > 0 THEN
      BEGIN
        fds.fd      := Self.fd;
        fds.events  := POLLIN;
        fds.revents := 0;

        status := fpPoll(@fds, 1, Self.timeout);

        IF status = 0 THEN
          RAISE Message64.Error.Create('ERROR: fpPoll timed out');

        IF status < 0 THEN
          BEGIN
            error := fpGetErrno;
            RAISE Message64.Error.Create('ERROR: fpPoll() failed, ' + StrError(error));
          END;
      END;

    count := fpRead(Self.fd, @resp, Message64.Size);

    IF count < 0 THEN
      BEGIN
        error := fpGetErrno;
        RAISE Message64.Error.Create('ERROR: fpRead() failed, ' + StrError(error));
      END;
  END;

  { Perform a Message64 command/response transaction }

  PROCEDURE MessengerSubclass.Transaction(cmd : Message; VAR resp : Message);

  BEGIN
    Send(cmd);
    Receive(resp);
  END;

END.
