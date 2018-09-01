-- SPI device services using the Remote I/O Protocol

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.i2c-remoteio.ads

WITH errno;
WITH Messaging;
WITH Message64;
WITH RemoteIO;

USE TYPE Message64.Byte;

PACKAGE BODY SPI.RemoteIO IS

  -- SPI device object constructor

  FUNCTION Create
   (dev      : Standard.RemoteIO.Device;
    num      : Standard.RemoteIO.ChannelNumber;
    mode     : Natural;
    wordsize : Natural;
    speed    : Natural) RETURN SPI.Device IS

    cmdmsg  : Message64.Message;
    respmsg : Message64.Message;

  BEGIN
    cmdmsg := (OTHERS => 0);
    cmdmsg(0) := Message64.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.SPI_CONFIGURE_REQUEST));
    cmdmsg(1) := 1;
    cmdmsg(2) := Message64.Byte(num);
    cmdmsg(3) := Message64.Byte(mode);
    cmdmsg(4) := Message64.Byte(wordsize);
    cmdmsg(5) := Message64.Byte(speed/16777216);
    cmdmsg(6) := Message64.Byte(speed/65536 MOD 256);
    cmdmsg(7) := Message64.Byte(speed/256 MOD 256);
    cmdmsg(8) := Message64.Byte(speed MOD 256);

    dev.Transaction(cmdmsg, respmsg);

    RETURN NEW DeviceSubclass'(dev, num);
  END Create;

  -- Read only SPI device transaction method

  PROCEDURE Read
   (self    : DeviceSubclass;
    resp    : OUT Response;
    resplen : Natural) IS

    cmd : Command(0 .. 0);

  BEGIN
    cmd := (OTHERS => 0);

    Transaction(self, cmd, 0, resp, resplen);
  END Read;

  -- Write only SPI device transaction method

  PROCEDURE Write
   (self   : DeviceSubclass;
    cmd    : Command;
    cmdlen : Natural) IS

    resp : Response(0 .. 0);

  BEGIN
    Transaction(self, cmd, cmdlen, resp, 0);
  END Write;

  -- Combined Write/Read SPI device transaction method

  PROCEDURE Transaction
   (self    : DeviceSubclass;
    cmd     : Command;
    cmdlen  : Natural;
    resp    : OUT Response;
    resplen : Natural;
    delayus : MicroSeconds := 0) IS

    cmdmsg  : Message64.Message;
    respmsg : Message64.Message;

  BEGIN
    IF cmdlen > cmdmsg'Length - 7 THEN
      RAISE SPI_Error WITH "Invalid command length";
    END IF;

    IF delayus > 65535 THEN
      RAISE SPI_Error WITH "Invalid delay value";
    END IF;

    IF resplen > respmsg'Length - 4 THEN
      RAISE SPI_Error WITH "Invalid response length";
    END IF;

    cmdmsg := (OTHERS => 0);
    cmdmsg(0) := Message64.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.SPI_TRANSACTION_REQUEST));
    cmdmsg(1) := 2;
    cmdmsg(2) := Message64.Byte(self.num);
    cmdmsg(3) := Message64.Byte(cmdlen);
    cmdmsg(4) := Message64.Byte(resplen);
    cmdmsg(5) := Message64.Byte(delayus / 256);
    cmdmsg(6) := Message64.Byte(delayus MOD 256);

    FOR i IN Natural RANGE 0 .. cmdlen - 1 LOOP
      cmdmsg(7 + i) := Message64.Byte(cmd(i));
    END LOOP;

    self.dev.Transaction(cmdmsg, respmsg);

    FOR i IN Natural RANGE 0 .. Natural(respmsg(3)) - 1 LOOP
      resp(i) := SPI.Byte(respmsg(4 + i));
    END LOOP;
  END Transaction;

END SPI.RemoteIO;
