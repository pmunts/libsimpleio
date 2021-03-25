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

PACKAGE BODY libRemoteIO.GPIO IS

  PROCEDURE GPIO_Configure
   (handle    : Integer;
    channel   : Integer;
    direction : Integer;
    state     : Integer;
    error     : OUT Integer) IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    error := EOK;

    -- Validate parameters

    IF (handle NOT IN AdapterRange) THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF AdapterTable(handle).dev = NULL THEN
      error := ENODEV;
    END IF;

    IF channel NOT IN RemoteIO.ChannelNumber THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF NOT AdapterTable(handle).GPIO_Channels.Contains(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    IF (direction < 0) OR (direction > 1) THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF (state < 0) OR (state > 1) THEN
      error := EINVAL;
      RETURN;
    END IF;

    -- Configure the GPIO pin as input or output

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(RemoteIO.MessageTypes'Pos(RemoteIO.GPIO_CONFIGURE_REQUEST));
    cmd(2 + channel / 8) := 2**(7 - channel MOD 8);

    IF direction = 1 THEN
      cmd(18 + channel / 8) := 2**(7 - channel MOD 8);
    END IF;

    AdapterTable(handle).dev.Transaction(cmd, resp);

    -- Write initial state for output pin

    IF direction = 1 THEN
      cmd := (OTHERS => 0);
      cmd(0) := Messaging.Byte(RemoteIO.MessageTypes'Pos(RemoteIO.GPIO_WRITE_REQUEST));
      cmd(2 + channel / 8) := 2**(7 - channel MOD 8);

      IF state = 1 THEN
        cmd(18 + channel / 8) := 2**(7 - channel MOD 8);
      END IF;

      AdapterTable(handle).dev.Transaction(cmd, resp);
    END IF;

  EXCEPTION
    WHEN e : OTHERS =>
      error := EIO;
  END GPIO_Configure;

  PROCEDURE GPIO_Read
   (handle    : Integer;
    channel   : Integer;
    state     : OUT Integer;
    error     : OUT Integer) IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    error := EOK;
    state := -1;

    -- Validate parameters

    IF (handle NOT IN AdapterRange) THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF AdapterTable(handle).dev = NULL THEN
      error := ENODEV;
    END IF;

    IF channel NOT IN RemoteIO.ChannelNumber THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF NOT AdapterTable(handle).GPIO_Channels.Contains(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(RemoteIO.MessageTypes'Pos(RemoteIO.GPIO_READ_REQUEST));
    cmd(2 + channel / 8) := 2**(7 - channel MOD 8);

    AdapterTable(handle).dev.Transaction(cmd, resp);

    IF (resp(3 + channel / 8) AND 2**(7 - channel MOD 8)) = 0 THEN
      state := 0;
    ELSE
      state := 1;
    END IF;

  EXCEPTION
    WHEN e : OTHERS =>
      state := -1;
      error := EIO;
  END GPIO_Read;

  PROCEDURE GPIO_Write
   (handle    : Integer;
    channel   : Integer;
    state     : Integer;
    error     : OUT Integer) IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    error := EOK;

    -- Validate parameters

    IF (handle NOT IN AdapterRange) THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF AdapterTable(handle).dev = NULL THEN
      error := ENODEV;
    END IF;

    IF channel NOT IN RemoteIO.ChannelNumber THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF NOT AdapterTable(handle).GPIO_Channels.Contains(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    IF (state < 0) OR (state > 1) THEN
      error := EINVAL;
      RETURN;
    END IF;

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(RemoteIO.MessageTypes'Pos(RemoteIO.GPIO_WRITE_REQUEST));
    cmd(2 + channel / 8) := 2**(7 - channel MOD 8);

    IF state = 1 THEN
      cmd(18 + channel / 8) := 2**(7 - channel MOD 8);
    END IF;

    AdapterTable(handle).dev.Transaction(cmd, resp);
  EXCEPTION
    WHEN e : OTHERS =>
      error := EIO;
  END GPIO_Write;

  PROCEDURE GPIO_channels
   (handle   : Integer;
    channels : OUT ChannelArray;
    error    : OUT Integer) IS

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
    END IF;

    -- Copy available channels to boolean array

    FOR c OF AdapterTable(handle).GPIO_Channels LOOP
      channels(c) := True;
    END LOOP;
  END GPIO_Channels;

END libRemoteIO.GPIO;
