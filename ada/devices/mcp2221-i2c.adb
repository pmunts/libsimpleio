-- MCP2221 I2C Bus Controller Services

-- Copyright (C)2018-2023, Philip Munts, President, Munts AM Corp.
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

USE TYPE Messaging.Byte;

PACKAGE BODY MCP2221.I2C IS
  PRAGMA Warnings(Off, """respmsg"" modified by call, but value *");

  -- Constructor

  FUNCTION Create(dev : NOT NULL Device) RETURN Standard.I2C.Bus IS

  BEGIN
    RETURN NEW BusSubclass'(dev => dev);
  END;

  -- Read only I2C bus cycle method

  PROCEDURE Read
   (Self    : BusSubclass;
    addr    : Standard.I2C.Address;
    resp    : OUT Standard.I2C.Response;
    resplen : Natural) IS

    cmdmsg  : Message64.Message;
    respmsg : Message64.Message;

  BEGIN
    IF resplen > 60 THEN
      RAISE Standard.I2C.I2C_Error WITH "resplen parameter is out of range";
    END IF;

    -- Issue I2C read command

    cmdmsg := (OTHERS => 0);
    cmdmsg(0) := CMD_I2C_READ;
    cmdmsg(1) := Messaging.Byte(resplen);
    cmdmsg(3) := Messaging.Byte(addr)*2 + 1;

    Self.dev.Command(cmdmsg, respmsg);

    -- Issue I2C GET DATA command

    cmdmsg := (OTHERS => 0);
    cmdmsg(0) := CMD_I2C_GET_DATA;

    Self.dev.Command(cmdmsg, respmsg);

    IF Natural(respmsg(3)) /= resplen THEN
      RAISE Standard.I2C.I2C_Error WITH "MCP2221 I2C byte count mismatch";
    END IF;

    -- Copy data from response message buffer

    FOR i IN 0 .. resplen - 1 LOOP
      resp(i) := Standard.I2C.Byte(respmsg(i + 4));
    END LOOP;
  END Read;

  -- Write only I2C bus cycle method

  PROCEDURE Write
   (Self   : BusSubclass;
    addr   : Standard.I2C.Address;
    cmd    : Standard.I2C.Command;
    cmdlen : Natural) IS

    cmdmsg  : Message64.Message;
    respmsg : Message64.Message;

  BEGIN
    IF cmdlen > 60 THEN
      RAISE Standard.I2C.I2C_Error WITH "cmdlen parameter is out of range";
    END IF;

    cmdmsg := (OTHERS => 0);
    cmdmsg(0) := CMD_I2C_WRITE;
    cmdmsg(1) := Messaging.Byte(cmdlen);
    cmdmsg(3) := Messaging.Byte(addr)*2;

    FOR i IN 0 .. cmdlen - 1 LOOP
      cmdmsg(i + 4) := Messaging.Byte(cmd(i));
    END LOOP;

    Self.dev.Command(cmdmsg, respmsg);
  END Write;

  -- Combined Write/Read I2C bus cycle method

  PROCEDURE Transaction
   (Self    : BusSubclass;
    addr    : Standard.I2C.Address;
    cmd     : Standard.I2C.Command;
    cmdlen  : Natural;
    resp    : OUT Standard.I2C.Response;
    resplen : Natural;
    delayus : Standard.I2C.MicroSeconds := 0) IS

    cmdmsg  : Message64.Message;
    respmsg : Message64.Message;

  BEGIN
    IF cmdlen > 60 THEN
      RAISE Standard.I2C.I2C_Error WITH "cmdlen parameter is out of range";
    END IF;

    IF resplen > 60 THEN
      RAISE Standard.I2C.I2C_Error WITH "resplen parameter is out of range";
    END IF;

    IF (cmdlen = 0) AND (resplen = 0) THEN
      RAISE Standard.I2C.I2C_Error WITH "cmdlen and resplen cannot both be zero";
    END IF;

    -- Issue I2C write command

    cmdmsg := (OTHERS => 0);
    cmdmsg(0) := CMD_I2C_WRITE_NOSTOP;
    cmdmsg(1) := Messaging.Byte(cmdlen);
    cmdmsg(3) := Messaging.Byte(addr)*2;

    FOR i IN 0 .. cmdlen - 1 LOOP
      cmdmsg(i + 4) := Messaging.Byte(cmd(i));
    END LOOP;

    Self.dev.Command(cmdmsg, respmsg);

    -- Pause between I2C write and read operations

    DELAY Duration(delayus)/1000000.0;

    -- Issue I2C read command

    cmdmsg := (OTHERS => 0);
    cmdmsg(0) := CMD_I2C_READ_REPEAT;
    cmdmsg(1) := Messaging.Byte(resplen);
    cmdmsg(3) := Messaging.Byte(addr)*2 + 1;

    Self.dev.Command(cmdmsg, respmsg);

    -- Issue I2C GET DATA command

    cmdmsg := (OTHERS => 0);
    cmdmsg(0) := CMD_I2C_GET_DATA;

    Self.dev.Command(cmdmsg, respmsg);

    IF Natural(respmsg(3)) /= resplen THEN
      RAISE Standard.I2C.I2C_Error WITH "MCP2221 I2C byte count mismatch";
    END IF;

    -- Copy data from response message buffer

    FOR i IN 0 .. resplen - 1 LOOP
      resp(i) := Standard.I2C.Byte(respmsg(i + 4));
    END LOOP;
  END Transaction;

END MCP2221.I2C;
