{ Remote I/O Protocol Implementation                                          }

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

UNIT RemoteIO;

INTERFACE

  USES
    Message64,
    SysUtils;

  TYPE
    RemoteIO_Error = CLASS(Exception);

    MessageTypes =
     (LOOPBACK_REQUEST,
      LOOPBACK_RESPONSE,
      VERSION_REQUEST,
      VERSION_RESPONSE,
      CAPABILITY_REQUEST,
      CAPABILITY_RESPONSE,
      GPIO_PRESENT_REQUEST,
      GPIO_PRESENT_RESPONSE,
      GPIO_CONFIGURE_REQUEST,
      GPIO_CONFIGURE_RESPONSE,
      GPIO_READ_REQUEST,
      GPIO_READ_RESPONSE,
      GPIO_WRITE_REQUEST,
      GPIO_WRITE_RESPONSE,
      I2C_PRESENT_REQUEST,
      I2C_PRESENT_RESPONSE,
      I2C_CONFIGURE_REQUEST,
      I2C_CONFIGURE_RESPONSE,
      I2C_TRANSACTION_REQUEST,
      I2C_TRANSACTION_RESPONSE,
      SPI_PRESENT_REQUEST,
      SPI_PRESENT_RESPONSE,
      SPI_CONFIGURE_REQUEST,
      SPI_CONFIGURE_RESPONSE,
      SPI_TRANSACTION_REQUEST,
      SPI_TRANSACTION_RESPONSE);

    Device = CLASS
      CONSTRUCTOR Create(m : Message64.Messenger);

      PROCEDURE Transaction(cmd : Message; VAR resp : Message);

      FUNCTION Version : String;

      FUNCTION Capability : String;
    PRIVATE
      msg : Message64.Messenger;
    END;

IMPLEMENTATION

  USES
    errno;

  { Create a Remote I/O Protocol device object }

  CONSTRUCTOR Device.Create(m : Message64.Messenger);

  BEGIN
    Self.msg := m;
  END;

  { Perform a Remote I/O Protocol operation }

  PROCEDURE Device.Transaction(cmd : Message; VAR resp : Message);

  BEGIN
    Self.msg.Transaction(cmd, resp);

    IF resp[0] <> cmd[0] + 1 THEN
      RAISE RemoteIO_Error.create('ERROR: Incorrect response message type');

    IF resp[1] <> cmd[1] THEN
      RAISE RemoteIO_Error.create('ERROR: Incorrect response message number');

    IF resp[2] <> EOK THEN
      RAISE RemoteIO_Error.create('ERROR: Command failed, ' + strerror(resp[2]));
  END;

  { Fetch the Remote I/O Protocol device version string }

  FUNCTION Device.Version : String;

  VAR
    cmd  : Message;
    resp : Message;
    vers : ARRAY [0 .. 60] OF Char;
    i    : Integer;

  BEGIN
    FillChar(cmd, SizeOf(cmd), 0);

    cmd[0] := Ord(VERSION_REQUEST);
    cmd[1] := 1;

    Self.Transaction(cmd, resp);

    FOR i := 0 TO 60 DO
      vers[i] := Char(resp[3 + i]);

    Version := vers;
  END;

  { Fetch the Remote I/O Protocol device capability string }

  FUNCTION Device.Capability : String;

  VAR
    cmd  : Message;
    resp : Message;
    caps : ARRAY [0 .. 60] OF Char;
    i    : Integer;

  BEGIN
    FillChar(cmd, SizeOf(cmd), 0);

    cmd[0] := Ord(CAPABILITY_REQUEST);
    cmd[1] := 1;

    Self.Transaction(cmd, resp);

    FOR i := 0 TO 60 DO
      caps[i] := Char(resp[3 + i]);

    Capability := caps;
  END;

END.
