-- I2C bus controller services using the Remote I/O Protocol

-- Copyright (C)2017-2023, Philip Munts, President, Munts AM Corp.
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
-- POSSIBILITY OF SUCH DAMAGE.

WITH Messaging;
WITH Message64;

PACKAGE BODY I2C.RemoteIO IS

  -- I2C bus object constructor

  FUNCTION Create
   (dev   : NOT NULL Standard.RemoteIO.Client.Device;
    num   : Standard.RemoteIO.ChannelNumber;
    speed : Positive := I2C.SpeedStandard) RETURN I2C.Bus IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.I2C_CONFIGURE_REQUEST));
    cmd(2) := Messaging.Byte(num);
    cmd(3) := Messaging.Byte(speed/16777216);
    cmd(4) := Messaging.Byte(speed/65536 MOD 256);
    cmd(5) := Messaging.Byte(speed/256 MOD 256);
    cmd(6) := Messaging.Byte(speed MOD 256);

    dev.Transaction(cmd, resp);

    RETURN NEW BusSubclass'(dev, num);
  END Create;

  -- Read only I2C bus cycle method

  PROCEDURE Read
   (Self    : BusSubclass;
    addr    : Address;
    resp    : OUT Response;
    resplen : Natural) IS

    cmd : Command(0 .. 0);

  BEGIN
    cmd(0) := 0;
    Transaction(Self, addr, cmd, 0, resp, resplen);
  END Read;

  -- Write only I2C bus cycle method

  PRAGMA Warnings(Off, """resp"" modified by call, but value might not be referenced");

  PROCEDURE Write
   (Self   : BusSubclass;
    addr   : Address;
    cmd    : Command;
    cmdlen : Natural) IS

    resp : Response(0 .. 0);

  BEGIN
    Transaction(Self, addr, cmd, cmdlen, resp, 0);
  END Write;

  PRAGMA Warnings(Off, """resp"" modified by call, but value might not be referenced");

  -- Combined Write/Read I2C bus cycle method

  PROCEDURE Transaction
   (Self    : BusSubclass;
    addr    : Address;
    cmd     : Command;
    cmdlen  : Natural;
    resp    : OUT Response;
    resplen : Natural;
    delayus : MicroSeconds := 0) IS

    cmdmsg  : Message64.Message;
    respmsg : Message64.Message;

  BEGIN
    cmdmsg := (OTHERS => 0);
    cmdmsg(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.I2C_TRANSACTION_REQUEST));
    cmdmsg(1) := Messaging.Byte(2);
    cmdmsg(2) := Messaging.Byte(Self.num);
    cmdmsg(3) := Messaging.Byte(addr);
    cmdmsg(4) := Messaging.Byte(cmdlen);
    cmdmsg(5) := Messaging.Byte(resplen);
    cmdmsg(6) := Messaging.Byte(delayus / 256);
    cmdmsg(7) := Messaging.Byte(delayus MOD 256);

    FOR i IN 1 .. cmdlen LOOP
      cmdmsg(i + 7) := Messaging.Byte(cmd(i - 1));
    END LOOP;

    Self.dev.Transaction(cmdmsg, respmsg);

    FOR i IN 1 .. Natural(respmsg(3)) LOOP
      resp(i - 1) := I2C.Byte(respmsg(i + 3));
    END LOOP;
  END Transaction;

END I2C.RemoteIO;
