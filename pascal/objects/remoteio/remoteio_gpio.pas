{ GPIO pin services using the Remote I/O Protocol                             }

{ Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.             }
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

UNIT RemoteIO_GPIO;

INTERFACE

  USES
    GPIO,
    RemoteIO,
    RemoteIO_Client;

  TYPE
    PinSubclass = CLASS(TInterfacedObject, GPIO.Pin)
      CONSTRUCTOR Create
       (dev   : Device;
        num   : Channels;
        dir   : GPIO.Direction;
        state : Boolean = False);

      FUNCTION Read : Boolean;

      PROCEDURE Write(state : Boolean);

      PROPERTY state : Boolean READ Read WRITE Write;
    PRIVATE
      mydev   : Device;
      mydir   : GPIO.Direction;
      myindex : Cardinal;
      mymask  : Byte;

      PROCEDURE Configure;
    END;

IMPLEMENTATION

  USES
    Message64,
    SysUtils;

  CONSTRUCTOR PinSubclass.Create
   (dev   : Device;
    num   : Channels;
    dir   : GPIO.Direction;
    state : Boolean);

  BEGIN
    Self.mydev   := dev;
    Self.mydir   := dir;
    Self.myindex := num DIV 8;
    Self.mymask  := 1 SHL (7 - num MOD 8);

    Self.Configure;

    IF dir = GPIO.Output THEN
      Self.Write(state);
  END;

  { GPIO configure method }

  PROCEDURE PinSubclass.Configure;

  VAR
    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    FillChar(cmd, SizeOf(cmd), #0);

    cmd[0] := Ord(GPIO_CONFIGURE_REQUEST);
    cmd[2 + Self.myindex] := Self.mymask;

    IF Self.mydir = GPIO.Output THEN
      cmd[18 + Self.myindex] := Self.mymask;

    Self.mydev.Transaction(cmd, resp);

    IF resp[2] <> 0 THEN
      RAISE Error.Create
       ('ERROR: Remote IO transaction failed, error=' + IntToStr(resp[2]));
  END;

  { GPIO read method }

  FUNCTION PinSubclass.Read : Boolean;

  VAR
    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    FillChar(cmd, SizeOf(cmd), #0);

    cmd[0] := Ord(GPIO_READ_REQUEST);
    cmd[2 + Self.myindex] := Self.mymask;

    Self.mydev.Transaction(cmd, resp);

    IF resp[2] <> 0 THEN
      RAISE Error.Create
       ('ERROR: Remote IO transaction failed, error=' + IntToStr(resp[2]));

    Read := (resp[3 + Self.myindex] AND Self.mymask) <> 0;
  END;

  { GPIO write method }

  PROCEDURE PinSubclass.Write(state : Boolean);

  VAR
    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    FillChar(cmd, SizeOf(cmd), #0);

    cmd[0] := Ord(GPIO_WRITE_REQUEST);
    cmd[2 + Self.myindex] := Self.mymask;

    IF state THEN
      cmd[18 + Self.myindex] := Self.mymask;

    Self.mydev.Transaction(cmd, resp);

    IF resp[2] <> 0 THEN
      RAISE Error.Create
       ('ERROR: Remote IO transaction failed, error=' + IntToStr(resp[2]));
  END;

END.
