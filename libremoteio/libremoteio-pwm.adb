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
WITH Ada.Unchecked_Conversion;
WITH Interfaces;

WITH Message64;
WITH Messaging;
WITH PWM;
WITH RemoteIO.Client.hidapi;

USE TYPE Interfaces.Unsigned_32;
USE TYPE Messaging.Byte;
USE TYPE PWM.DutyCycle;
USE TYPE RemoteIO.Client.Device;

PACKAGE BODY libRemoteIO.PWM IS

  PROCEDURE PWM_Configure
   (handle     : Integer;
    channel    : Integer;
    frequency  : Integer;
    duty       : Float;
    error      : OUT Integer) IS

    cmd    : Message64.Message;
    resp   : Message64.Message;

  BEGIN
    error      := EOK;

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

    IF NOT AdapterTable(handle).PWM_Channels.Contains(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    IF frequency < 1 THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF duty < Float(Standard.PWM.MinimumDutyCycle) OR
       duty > Float(Standard.PWM.MaximumDutyCycle) THEN
      error := EINVAL;
      RETURN;
    END IF;

    AdapterTable(handle).PWM_periods(channel) := 1000000000/frequency;

    -- Configure the PWM output channel

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(RemoteIO.MessageTypes'Pos(RemoteIO.PWM_CONFIGURE_REQUEST));
    cmd(2) := Messaging.Byte(channel);
    cmd(3) := Messaging.Byte(AdapterTable(handle).PWM_periods(channel)/16777216);
    cmd(4) := Messaging.Byte(AdapterTable(handle).PWM_periods(channel)/65536 MOD 256);
    cmd(5) := Messaging.Byte(AdapterTable(handle).PWM_periods(channel)/256 MOD 256);
    cmd(6) := Messaging.Byte(AdapterTable(handle).PWM_periods(channel) MOD 256);

    AdapterTable(handle).dev.Transaction(cmd, resp);
    AdapterTable(handle).PWM_config(channel) := True;

    PWM_Write(handle, channel, duty, error);

  EXCEPTION
    WHEN e : OTHERS =>
      Debug.Put(e);
      error := EIO;
  END PWM_Configure;

  PROCEDURE PWM_Write
   (handle    : Integer;
    channel   : Integer;
    duty      : Float;
    error     : OUT Integer) IS

    cmd  : Message64.Message;
    resp : Message64.Message;
    ontime : Natural;

  BEGIN
    error  := EOK;

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

    IF NOT AdapterTable(handle).PWM_Channels.Contains(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    IF NOT AdapterTable(handle).PWM_config(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    IF duty < Float(Standard.PWM.MinimumDutyCycle) OR
       duty > Float(Standard.PWM.MaximumDutyCycle) THEN
      error := EINVAL;
      RETURN;
    END IF;

    ontime := Natural(Float(duty/100.0)*Float(AdapterTable(handle).PWM_periods(channel)));

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(RemoteIO.MessageTypes'Pos(RemoteIO.PWM_WRITE_REQUEST));
    cmd(2) := Messaging.Byte(channel);
    cmd(3) := Messaging.Byte(ontime/16777216);
    cmd(4) := Messaging.Byte(ontime/65536 MOD 256);
    cmd(5) := Messaging.Byte(ontime/256 MOD 256);
    cmd(6) := Messaging.Byte(ontime MOD 256);

    AdapterTable(handle).dev.Transaction(cmd, resp);

  EXCEPTION
    WHEN e : OTHERS =>
      Debug.Put(e);
      error  := EIO;
  END PWM_Write;

  PROCEDURE PWM_channels
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
      RETURN;
    END IF;

    -- Copy available channels to boolean array

    FOR c OF AdapterTable(handle).PWM_Channels LOOP
      channels(c) := True;
    END LOOP;
  END PWM_Channels;

END libRemoteIO.PWM;
