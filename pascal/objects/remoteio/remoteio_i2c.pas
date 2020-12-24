{ I2C bus controller services using the Remote I/O Protocol                   }

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

UNIT RemoteIO_I2C;

INTERFACE

  USES
    I2C,
    RemoteIO,
    RemoteIO_Client;

  TYPE
    BusSubclass = CLASS(TInterfacedObject, I2C.BUS)
      CONSTRUCTOR Create
       (dev      : Device;
        num      : Channels;
        speed    : Cardinal = I2C.SpeedStandard);

      { I2C read method }

      PROCEDURE Read
       (addr     : Address;
        VAR resp : ARRAY OF Byte;
        resplen  : Cardinal);

      { I2C write method }

      PROCEDURE Write
       (addr     : Address;
        cmd      : ARRAY OF Byte;
        cmdlen   : Cardinal);

      { I2C write/read transaction method }

      PROCEDURE Transaction
       (addr     : Address;
        cmd      : ARRAY OF Byte;
        cmdlen   : Cardinal;
        VAR resp : ARRAY OF Byte;
        resplen  : Cardinal;
        delayus  : Cardinal = 0);

    PRIVATE
      dev : Device;
      num : Channels;
    END;

IMPLEMENTATION

  USES
    Errors,
    Message64;

  CONSTRUCTOR BusSubclass.Create
   (dev      : Device;
    num      : Channels;
    speed    : Cardinal);

  VAR
    cmdmsg  : Message64.Message;
    respmsg : Message64.Message;

  BEGIN
    self.dev := dev;
    self.num := num;

    { Configure the I2C bus controller }

    FillChar(cmdmsg, SizeOf(cmdmsg), #0);

    cmdmsg[0] := Ord(I2C_CONFIGURE_REQUEST);
    cmdmsg[2] := Self.num;
    cmdmsg[3] := (speed SHR 24) AND $FF;
    cmdmsg[4] := (speed SHR 16) AND $FF;
    cmdmsg[5] := (speed SHR 8)  AND $FF;
    cmdmsg[6] := (speed SHR 0)  AND $FF;

    dev.Transaction(cmdmsg, respmsg);

    IF respmsg[2] <> 0 THEN
      RAISE Error.Create
       ('ERROR: Remote IO transaction failed, ' + StrError(respmsg[2]));
  END;

  { I2C read method }

  PROCEDURE BusSubclass.Read
   (addr     : Address;
    VAR resp : ARRAY OF Byte;
    resplen  : Cardinal);

  VAR
    cmd : ARRAY [0 .. 0] OF Byte;

  BEGIN
    cmd[0] := 0;
    Self.Transaction(addr, cmd, 0, resp, resplen);
  END;

  { I2C write method }

  PROCEDURE BusSubclass.Write
   (addr     : Address;
    cmd      : ARRAY OF Byte;
    cmdlen   : Cardinal);

  VAR
    resp : ARRAY [0 .. 0] OF Byte;

  BEGIN
    Self.Transaction(addr, cmd, cmdlen, resp, 0);
  END;

  { I2C write/read transaction method }

  PROCEDURE BusSubclass.Transaction
   (addr     : Address;
    cmd      : ARRAY OF Byte;
    cmdlen   : Cardinal;
    VAR resp : ARRAY OF Byte;
    resplen  : Cardinal;
    delayus  : Cardinal = 0);

  VAR
    cmdmsg  : Message64.Message;
    respmsg : Message64.Message;
    i       : Cardinal;

  BEGIN
    { Validate parameters }

    IF cmdlen > 56 THEN
      RAISE Error.Create
       ('ERROR: Command length is out of range');

    IF resplen > 60 THEN
      RAISE Error.Create
       ('ERROR: Response length is out of range');

    IF (cmdlen = 0) AND (resplen = 0) THEN
      RAISE Error.Create
       ('ERROR: Command length and response length are both zero');

    IF delayus > 65535 THEN
      RAISE Error.Create
       ('ERROR: delayus parameter is out of range');

    FillChar(cmdmsg, SizeOf(cmdmsg), #0);

    cmdmsg[0] := Ord(I2C_TRANSACTION_REQUEST);
    cmdmsg[2] := Self.num;
    cmdmsg[3] := addr;
    cmdmsg[4] := cmdlen;
    cmdmsg[5] := resplen;
    cmdmsg[6] := delayus DIV 256;
    cmdmsg[7] := delayus MOD 256;

    IF cmdlen > 0 THEN
      FOR i := 0 TO cmdlen - 1 DO
        cmdmsg[8 + i] := cmd[i];

    Self.dev.Transaction(cmdmsg, respmsg);

    IF respmsg[2] <> 0 THEN
      RAISE Error.Create
       ('ERROR: Remote IO transaction failed, ' + StrError(respmsg[2]));

    IF resplen > 0 THEN
      FOR i := 0 TO resplen -1 DO
        resp[i] := respmsg[4 + i];
  END;

END.
