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
WITH Interfaces;

WITH Analog;
WITH Message64;
WITH Messaging;
WITH RemoteIO.Client.hidapi;

USE TYPE Interfaces.Unsigned_32;
USE TYPE Messaging.Byte;
USE TYPE RemoteIO.Client.Device;

PACKAGE BODY libRemoteIO.ADC IS

  PROCEDURE ADC_Configure
   (handle     : Integer;
    channel    : Integer;
    resolution : OUT Integer;
    error      : OUT Integer) IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    resolution := 0;
    error      := EOK;

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

    IF NOT AdapterTable(handle).ADC_Channels.Contains(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    -- Configure the A/D input channel

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(RemoteIO.MessageTypes'Pos(RemoteIO.ADC_CONFIGURE_REQUEST));
    cmd(2) := Messaging.Byte(channel);

    AdapterTable(handle).dev.Transaction(cmd, resp);

    resolution := Integer(resp(3));

  EXCEPTION
    WHEN e : OTHERS =>
      error := EIO;
  END ADC_Configure;

  PROCEDURE ADC_Read
   (handle    : Integer;
    channel   : Integer;
    sample    : OUT Integer;
    error     : OUT Integer) IS

    cmd  : Message64.Message;
    resp : Message64.Message;

  BEGIN
    error  := EOK;
    sample := 0;

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

    IF NOT AdapterTable(handle).ADC_Channels.Contains(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(RemoteIO.MessageTypes'Pos(RemoteIO.ADC_READ_REQUEST));
    cmd(2) := Messaging.Byte(channel);

    AdapterTable(handle).dev.Transaction(cmd, resp);

    sample := Integer
     (Interfaces.Shift_Left(Interfaces.Unsigned_32(resp(3)), 24) +
      Interfaces.Shift_Left(Interfaces.Unsigned_32(resp(4)), 16) +
      Interfaces.Shift_Left(Interfaces.Unsigned_32(resp(5)),  8) +
      Interfaces.Unsigned_32(resp(6)));

  EXCEPTION
    WHEN e : OTHERS =>
      sample := 0;
      error  := EIO;
  END ADC_Read;

  PROCEDURE ADC_channels
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

    FOR c OF AdapterTable(handle).ADC_Channels LOOP
      channels(c) := True;
    END LOOP;
  END ADC_Channels;

END libRemoteIO.ADC;
