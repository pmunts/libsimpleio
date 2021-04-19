-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Exceptions;

WITH Message64;
WITH Messaging;
WITH RemoteIO.Client.hidapi;

USE TYPE Messaging.Byte;
USE TYPE RemoteIO.Client.Device;

PACKAGE BODY libRemoteIO.I2C IS

  PROCEDURE I2C_Configure
   (handle    : Integer;
    channel   : Integer;
    frequency : Integer;
    error     : OUT Integer) IS

    cmdmsg  : Message64.Message;
    respmsg : Message64.Message;

  BEGIN
    error := EOK;

    -- Validate parameters

    IF (handle NOT IN AdapterRange) THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF AdapterTable(handle).dev = NULL THEN
      error := ENODEV;
      RETURN;
    END IF;

    IF channel NOT IN RemoteIO.ChannelNumber THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF NOT AdapterTable(handle).I2C_Channels.Contains(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    IF frequency < 1 THEN
      error := EINVAL;
      RETURN;
    END IF;

    cmdmsg := (OTHERS => 0);
    cmdmsg(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.I2C_CONFIGURE_REQUEST));
    cmdmsg(2) := Messaging.Byte(channel);
    cmdmsg(3) := Messaging.Byte(frequency/16777216);
    cmdmsg(4) := Messaging.Byte(frequency/65536 MOD 256);
    cmdmsg(5) := Messaging.Byte(frequency/256 MOD 256);
    cmdmsg(6) := Messaging.Byte(frequency MOD 256);

    AdapterTable(handle).dev.Transaction(cmdmsg, respmsg);
    AdapterTable(handle).I2C_config(channel) := True;

  EXCEPTION
    WHEN e: OTHERS =>
      Debug.Put(e);
      error  := EIO;
  END I2C_Configure;

  PROCEDURE I2C_Transaction
   (handle    : Integer;
    channel   : Integer;
    addr      : Standard.I2C.Address;
    cmd       : IN OUT Messaging.Buffer;
    cmdlen    : Integer;
    resp      : IN OUT Messaging.Buffer;
    resplen   : Integer;
    delayus   : Integer;
    error     : OUT Integer) IS

    cmdmsg  : Message64.Message;
    respmsg : Message64.Message;

  BEGIN
    error := EOK;

    -- Validate parameters

    IF (handle NOT IN AdapterRange) THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF AdapterTable(handle).dev = NULL THEN
      error := ENODEV;
      RETURN;
    END IF;

    IF channel NOT IN RemoteIO.ChannelNumber THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF NOT AdapterTable(handle).I2C_Channels.Contains(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    IF NOT AdapterTable(handle).I2C_config(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    IF cmdlen < 0 OR resplen < 0 THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF cmdlen = 0 AND resplen = 0 THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF delayus < 0 OR delayus > 65535 THEN
      error := EINVAL;
      RETURN;
    END IF;

    cmdmsg := (OTHERS => 0);
    cmdmsg(0) := Messaging.Byte(Standard.RemoteIO.MessageTypes'Pos(
      Standard.RemoteIO.I2C_TRANSACTION_REQUEST));
    cmdmsg(2) := Messaging.Byte(channel);
    cmdmsg(3) := Messaging.Byte(addr);
    cmdmsg(4) := Messaging.Byte(cmdlen);
    cmdmsg(5) := Messaging.Byte(resplen);
    cmdmsg(6) := Messaging.Byte(delayus / 256);
    cmdmsg(7) := Messaging.Byte(delayus MOD 256);

    FOR i IN 1 .. cmdlen LOOP
      cmdmsg(i + 7) := cmd(i - 1);
    END LOOP;

    AdapterTable(handle).dev.Transaction(cmdmsg, respmsg);

    FOR i IN 1 .. Natural(respmsg(3)) LOOP
      resp(i - 1) := respmsg(i + 3);
    END LOOP;

  EXCEPTION
    WHEN e: OTHERS =>
      Debug.Put(e);
      error  := EIO;
  END I2C_Transaction;

  PROCEDURE I2C_Channels
   (handle    : Integer;
    channels  : OUT ChannelArray;
    error     : OUT Integer) IS

  BEGIN
    channels := (OTHERS => False);
    error    := EOK;

    -- Validate parameters

    IF (handle NOT IN AdapterRange) THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF AdapterTable(handle).dev = NULL THEN
      error := ENODEV;
      RETURN;
    END IF;

    -- Copy available channels to boolean array

    FOR c OF AdapterTable(handle).I2C_Channels LOOP
      channels(c) := True;
    END LOOP;
  END I2C_Channels;

END libRemoteIO.I2C;
