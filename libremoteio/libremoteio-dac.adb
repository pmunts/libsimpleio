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

WITH Analog;
WITH Message64;
WITH Messaging;
WITH RemoteIO.Client.hidapi;

USE TYPE Analog.Sample;
USE TYPE Interfaces.Unsigned_32;
USE TYPE Messaging.Byte;
USE TYPE RemoteIO.Client.Device;

PACKAGE BODY libRemoteIO.DAC IS

  FUNCTION To_Sample IS NEW Ada.Unchecked_Conversion(Integer, Analog.Sample);

  PROCEDURE DAC_Configure
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
      RETURN;
    END IF;

    IF channel NOT IN RemoteIO.ChannelNumber THEN
      error := EINVAL;
      RETURN;
    END IF;

    IF NOT AdapterTable(handle).DAC_Channels.Contains(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    -- Configure the A/D input channel

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(RemoteIO.MessageTypes'Pos(RemoteIO.DAC_CONFIGURE_REQUEST));
    cmd(2) := Messaging.Byte(channel);

    AdapterTable(handle).dev.Transaction(cmd, resp);

    resolution := Integer(resp(3));

  EXCEPTION
    WHEN e : OTHERS =>
      error := EIO;
  END DAC_Configure;

  PROCEDURE DAC_Write
   (handle    : Integer;
    channel   : Integer;
    sample    : Integer;
    error     : OUT Integer) IS

    cmd  : Message64.Message;
    resp : Message64.Message;

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

    IF NOT AdapterTable(handle).DAC_Channels.Contains(channel) THEN
      error := ENODEV;
      RETURN;
    END IF;

    cmd := (OTHERS => 0);
    cmd(0) := Messaging.Byte(RemoteIO.MessageTypes'Pos(RemoteIO.DAC_WRITE_REQUEST));
    cmd(2) := Messaging.Byte(channel);
    cmd(3) := Messaging.Byte((To_Sample(sample) / 2**24) AND 16#FF#);
    cmd(4) := Messaging.Byte((To_Sample(sample) / 2**16) AND 16#FF#);
    cmd(5) := Messaging.Byte((To_Sample(sample) / 2**8)  AND 16#FF#);
    cmd(6) := Messaging.Byte((To_Sample(sample) / 2**0)  AND 16#FF#);

    AdapterTable(handle).dev.Transaction(cmd, resp);

  EXCEPTION
    WHEN e : OTHERS =>
      error  := EIO;
  END DAC_Write;

  PROCEDURE DAC_channels
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

    FOR c OF AdapterTable(handle).DAC_Channels LOOP
      channels(c) := True;
    END LOOP;
  END DAC_Channels;

END libRemoteIO.DAC;
