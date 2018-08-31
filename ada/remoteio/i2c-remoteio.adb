-- I2C bus controller services using the Remote I/O Protocol

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
-- POSSIBILITY OF SUCH DAMAGE.

WITH errno;
WITH Message64;
WITH Messaging;
WITH RemoteIO;

PACKAGE BODY I2C.RemoteIO IS

  -- I2C bus object constructor

  FUNCTION Create
   (dev   : Standard.RemoteIO.Device;
    num   : Standard.RemoteIO.ChannelNumber;
    speed : Positive := I2C.SpeedStandard) RETURN I2C.Bus IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    cmd := (OTHERS => 0);
    cmd(0) := Message64.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.I2C_CONFIGURE_REQUEST));
    cmd(1) := Message64.Byte(1);
    cmd(2) := Message64.Byte(num);
    cmd(3) := Message64.Byte(speed/16777216);
    cmd(4) := Message64.Byte(speed/65536 MOD 256);
    cmd(5) := Message64.Byte(speed/256 MOD 256);
    cmd(6) := Message64.Byte(speed MOD 256);

    dev.Transaction(cmd, resp);

    RETURN NEW BusSubclass'(dev, num);
  END Create;

  -- Read only I2C bus cycle method

  PROCEDURE Read
   (self    : BusSubclass;
    addr    : Address;
    resp    : OUT Response;
    resplen : Natural) IS

    cmd : Command(0 .. 0);

  BEGIN
    cmd(0) := 0;
    Transaction(self, addr, cmd, 0, resp, resplen);
  END Read;

  -- Write only I2C bus cycle method

  PROCEDURE Write
   (self   : BusSubclass;
    addr   : Address;
    cmd    : Command;
    cmdlen : Natural) IS

    resp : Response(0 .. 0);

  BEGIN
    Transaction(self, addr, cmd, cmdlen, resp, 0);
  END Write;

  -- Combined Write/Read I2C bus cycle method

  PROCEDURE Transaction
   (self    : BusSubclass;
    addr    : Address;
    cmd     : Command;
    cmdlen  : Natural;
    resp    : OUT Response;
    resplen : Natural;
    delayus : Natural := 0) IS

    cmdmsg  : Message64.Message;
    respmsg : Message64.Message;

  BEGIN
    cmdmsg := (OTHERS => 0);
    cmdmsg(0) := Message64.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.I2C_TRANSACTION_REQUEST));
    cmdmsg(1) := Message64.Byte(2);
    cmdmsg(2) := Message64.Byte(self.num);
    cmdmsg(3) := Message64.Byte(addr);
    cmdmsg(4) := Message64.Byte(cmdlen);
    cmdmsg(5) := Message64.Byte(resplen);

    FOR i IN 1 .. cmdlen LOOP
      cmdmsg(i + 5) := Message64.Byte(cmd(i - 1));
    END LOOP;

    self.dev.Transaction(cmdmsg, respmsg);

    FOR i IN 1 .. Natural(respmsg(3)) LOOP
      resp(i - 1) := I2C.Byte(respmsg(i + 3));
    END LOOP;
  END Transaction;

END I2C.RemoteIO;
