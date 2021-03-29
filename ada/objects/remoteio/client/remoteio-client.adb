-- Remote I/O Client Services using Message64 transport (e.g. raw HID)

-- Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Strings;
WITH Ada.Strings.Fixed;

WITH Messaging;
WITH errno;

USE TYPE Messaging.Byte;

PACKAGE BODY RemoteIO.Client IS

  -- Constructors

  FUNCTION Create(msg : NOT NULL Message64.Messenger) RETURN Device IS

  BEGIN
    RETURN NEW DeviceClass'(msg, 0);
  END Create;

  -- Execute an operation

  PROCEDURE Transaction
   (Self : IN OUT DeviceClass;
    cmd  : IN OUT Message64.Message;
    resp : OUT Message64.Message) IS

  BEGIN
    Self.num := Self.num + 23;
    cmd(1) := Self.num;

    Self.msg.Send(cmd);
    Self.msg.Receive(resp);

    IF resp(0) /= cmd(0) + 1 THEN
      RAISE RemoteIO_Error WITH "Invalid response message type";
    END IF;

    IF resp(1) /= cmd(1) THEN
      RAISE RemoteIO_Error WITH "Invalid response message number";
    END IF;

    IF resp(2) /= errno.EOK THEN
      RAISE RemoteIO_Error WITH "Command failed, " &
        errno.strerror(Integer(resp(2)));
    END IF;
  END Transaction;

  -- Get the remote device version string

  FUNCTION GetVersion(Self : IN OUT DeviceClass) RETURN String IS

    cmd  : Message64.Message;
    resp : Message64.Message;
    vers : String(1 .. resp'Length - 3);

  BEGIN

    -- Fill the version string buffer with spaces

    vers := (OTHERS => ' ');

    -- Zero the command buffer

    cmd := (OTHERS => 0);

    -- Build the version request command

    cmd(0) := MessageTypes'Pos(VERSION_REQUEST);

    -- Dispatch the version request command

    Self.Transaction(cmd, resp);

    -- Copy the version string

    FOR i IN vers'Range LOOP
      EXIT WHEN resp(i+2) = 0;
      vers(i) := Character'Val(resp(i+2));
    END LOOP;

    -- Return trimmed version string

    RETURN Ada.Strings.Fixed.Trim(vers, Ada.Strings.Left);
  END GetVersion;

  -- Get the remote device capability string

  FUNCTION GetCapability(Self : IN OUT DeviceClass) RETURN String IS

    cmd  : Message64.Message;
    resp : Message64.Message;
    caps : String(1 .. resp'Length - 3);

  BEGIN

    -- Fill the capability string buffer with spaces

    caps := (OTHERS => ' ');

    -- Zero the command buffer

    cmd := (OTHERS => 0);

    -- Build the capability request command

    cmd(0) := MessageTypes'Pos(CAPABILITY_REQUEST);

    -- Dispatch the capability request command

    self.Transaction(cmd, resp);

    -- Copy the capability string

    FOR i IN caps'Range LOOP
      EXIT WHEN resp(i+2) = 0;
      caps(i) := Character'Val(resp(i+2));
    END LOOP;

    -- Return trimmed capability string

    RETURN Ada.Strings.Fixed.Trim(caps, Ada.Strings.Left);
  END GetCapability;

  -- Get the available channels for a given service type

  QueryCommands : CONSTANT ARRAY (ChannelTypes) OF MessageTypes :=
   (ADC_PRESENT_REQUEST,
    DAC_PRESENT_REQUEST,
    GPIO_PRESENT_REQUEST,
    I2C_PRESENT_REQUEST,
    PWM_PRESENT_REQUEST,
    SPI_PRESENT_REQUEST,
    DEVICE_PRESENT_REQUEST);

  FUNCTION GetAvailableChannels
   (Self    : IN OUT DeviceClass;
    service : ChannelTypes) RETURN ChannelSets.Set IS

    cmd     : Message64.Message;
    resp    : Message64.Message;
    chanset : ChannelSets.Set;

  BEGIN
    cmd(0) := Messaging.Byte(MessageTypes'Pos(QueryCommands(service)));

    Self.Transaction(cmd, resp);

    FOR c IN ChannelNumber LOOP
      IF (resp(3 + c/8) AND Messaging.Byte(2**(7 - c MOD 8))) /= 0 THEN
        chanset.Include(c);
      END IF;
    END LOOP;

    RETURN chanset;
  END GetAvailableChannels;

  -- Return the underlying Message64.Messenger object

  FUNCTION GetMessenger(Self : IN OUT DeviceClass) RETURN Message64.Messenger IS

  BEGIN
    RETURN Self.msg;
  END GetMessenger;

END RemoteIO.Client;
