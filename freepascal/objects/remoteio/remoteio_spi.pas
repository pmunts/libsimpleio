{ SPI device services using the Remote I/O Protocol                           }

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

UNIT RemoteIO_SPI;

INTERFACE

  USES
    SPI,
    RemoteIO,
    RemoteIO_Client;

  TYPE
    DeviceSubclass = CLASS(TInterfacedObject, SPI.Device)
      CONSTRUCTOR Create
       (dev      : Device;
        num      : Channels;
        mode     : Byte;
        wordsize : Byte;
        speed    : Cardinal);

      { SPI read method }

      PROCEDURE Read
       (VAR resp : ARRAY OF Byte;
        resplen  : Cardinal);

      { SPI write method }

      PROCEDURE Write
       (cmd      : ARRAY OF Byte;
        cmdlen   : Cardinal);

      { SPI write/read transaction method }

      PROCEDURE Transaction
       (cmd      : ARRAY OF Byte;
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
    Message64,
    SysUtils;

  CONSTRUCTOR DeviceSubclass.Create
   (dev      : Device;
    num      : Channels;
    mode     : Byte;
    wordsize : Byte;
    speed    : Cardinal);

  VAR
    cmdmsg  : Message64.Message;
    respmsg : Message64.Message;

  BEGIN
    self.dev := dev;
    self.num := num;

    { Configure the SPI device }

    FillChar(cmdmsg, SizeOf(cmdmsg), #0);

    cmdmsg[0] := Ord(SPI_CONFIGURE_REQUEST);
    cmdmsg[2] := Self.num;
    cmdmsg[3] := mode;
    cmdmsg[4] := wordsize;
    cmdmsg[5] := (speed SHR 24) AND $FF;
    cmdmsg[6] := (speed SHR 16) AND $FF;
    cmdmsg[7] := (speed SHR 8)  AND $FF;
    cmdmsg[8] := (speed SHR 0)  AND $FF;

    dev.Transaction(cmdmsg, respmsg);

    IF respmsg[2] <> 0 THEN
      RAISE Error.Create
       ('ERROR: Remote IO transaction failed, error=' + IntToStr(respmsg[2]));
  END;

  { SPI read method }

  PROCEDURE DeviceSubclass.Read
   (VAR resp : ARRAY OF Byte;
    resplen  : Cardinal);

  VAR
    cmd : ARRAY [0 .. 0] OF Byte;

  BEGIN
    cmd[0] := 0;
    Self.Transaction(cmd, 0, resp, resplen);
  END;

  { SPI write method }

  PROCEDURE DeviceSubclass.Write
   (cmd      : ARRAY OF Byte;
    cmdlen   : Cardinal);

  VAR
    resp : ARRAY [0 .. 0] OF Byte;

  BEGIN
    Self.Transaction(cmd, cmdlen, resp, 0);
  END;

  { SPI write/read transaction method }

  PROCEDURE DeviceSubclass.Transaction
   (cmd      : ARRAY OF Byte;
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

    IF cmdlen > 57 THEN
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

    cmdmsg[0] := Ord(SPI_TRANSACTION_REQUEST);
    cmdmsg[2] := Self.num;
    cmdmsg[3] := cmdlen;
    cmdmsg[4] := resplen;
    cmdmsg[5] := delayus DIV 256;
    cmdmsg[6] := delayus MOD 256;

    IF cmdlen > 0 THEN
      FOR i := 0 TO cmdlen - 1 DO
        cmdmsg[7 + i] := cmd[i];

    Self.dev.Transaction(cmdmsg, respmsg);

    IF respmsg[2] <> 0 THEN
      RAISE Error.Create
       ('ERROR: Remote IO transaction failed, error=' + IntToStr(respmsg[2]));

    IF resplen > 0 THEN
      FOR i := 0 TO resplen -1 DO
        resp[i] := respmsg[4 + i];
  END;

END.
