-- Remote I/O Server Dispatcher for ADC commands

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

WITH Analog;
WITH errno;
WITH Messaging;

USE TYPE Analog.Sample;
USE TYPE Messaging.Byte;

PACKAGE BODY RemoteIO.ADC IS

  FUNCTION Create
   (executor : NOT NULL RemoteIO.Executive.Executor) RETURN Dispatcher IS

    Self : Dispatcher;

  BEGIN
    Self := NEW DispatcherSubclass'(inputs => (OTHERS => Unused));

    executor.Register(ADC_PRESENT_REQUEST,   RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(ADC_CONFIGURE_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(ADC_READ_REQUEST,      RemoteIO.Dispatch.Dispatcher(Self));

    RETURN Self;
  END Create;

  -- Register analog input by device designator

  PROCEDURE Register
   (Self       : IN OUT DispatcherSubclass;
    num        : ChannelNumber;
    desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution) IS

  BEGIN
    IF Self.inputs(num).registered THEN
      RETURN;
    END IF;

    Self.inputs(num).registered := True;
    Self.inputs(num).configured := False;
    Self.inputs(num).desg       := desg;
    Self.inputs(num).obj        := Standard.ADC.libsimpleio.Destroyed;
    Self.inputs(num).input      := Self.inputs(num).obj'Unchecked_Access;
    Self.inputs(num).resolution := resolution;
  END Register;

  -- Register analog input by preconfigured object access

  PROCEDURE Register
   (Self  : IN OUT DispatcherSubclass;
    num   : ChannelNumber;
    input : NOT NULL Analog.Input) IS

  BEGIN
    IF Self.inputs(num).registered THEN
      RETURN;
    END IF;

    Self.inputs(num).registered := True;
    Self.inputs(num).configured := True;
    Self.inputs(num).desg       := Device.Unavailable;
    Self.inputs(num).obj        := Standard.ADC.libsimpleio.Destroyed;
    Self.inputs(num).input      := input;
    Self.inputs(num).resolution := input.GetResolution;
  END Register;

  PROCEDURE Present
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    byteindex : Natural;
    bitmask   : Messaging.Byte;

  BEGIN
    resp := (cmd(0) + 1, cmd(1), OTHERS => 0);

    FOR c IN ChannelNumber LOOP
      byteindex := c/8;
      bitmask   := 2**(7 - (c MOD 8));

      IF Self.inputs(c).registered THEN
        resp(3 + byteindex) := resp(3 + byteindex) OR bitmask;
      END IF;
    END LOOP;
  END Present;

  PROCEDURE Configure
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    num : RemoteIO.ChannelNumber;

  BEGIN
    resp := (cmd(0) + 1, cmd(1), OTHERS => 0);

    -- Make sure the channel number is valid

    IF Natural(cmd(2)) > RemoteIO.ChannelNumber'Last THEN
      resp(2) := errno.EINVAL;
      RETURN;
    END IF;

    num := RemoteIO.ChannelNumber(cmd(2));

    -- Make sure the channel is available

    IF NOT Self.inputs(num).registered THEN
      resp(2) := errno.ENXIO;
      RETURN;
    END IF;

    IF Self.inputs(num).configured THEN
      resp(3) := Messaging.Byte(Self.inputs(num).resolution);
      RETURN;
    END IF;

    Self.inputs(num).obj.Initialize(Self.inputs(num).desg,
      Self.inputs(num).resolution);

    Self.inputs(num).configured := True;

    resp(3) := Messaging.Byte(Self.inputs(num).resolution);

  EXCEPTION
    WHEN OTHERS =>
      resp(2) := errno.EIO;
  END;

  PROCEDURE Read
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    num    : RemoteIO.ChannelNumber;
    sample : Analog.Sample;

  BEGIN
    resp := (cmd(0) + 1, cmd(1), OTHERS => 0);

    -- Make sure the channel number is valid

    IF Natural(cmd(2)) > RemoteIO.ChannelNumber'Last THEN
      resp(2) := errno.EINVAL;
      RETURN;
    END IF;

    num := RemoteIO.ChannelNumber(cmd(2));

    -- Make sure the channel is available

    IF NOT Self.inputs(num).registered THEN
      resp(2) := errno.ENXIO;
      RETURN;
    END IF;

    IF NOT Self.inputs(num).configured THEN
      resp(2) := errno.ENODEV;
      RETURN;
    END IF;

    -- Get analog input sample

    sample := Self.inputs(num).input.Get;

    -- Copy analog input sample bytes to response

    resp(3) := Messaging.Byte(sample/16777216);
    resp(4) := Messaging.Byte(sample/65536 MOD 256);
    resp(5) := Messaging.Byte(sample/256 MOD 256);
    resp(6) := Messaging.Byte(sample MOD 256);

  EXCEPTION
    WHEN OTHERS =>
      resp(2) := errno.EIO;
  END Read;

  PROCEDURE Dispatch
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.Message) IS

    msgtype : MessageTypes;

  BEGIN
    msgtype := MessageTypes'Val(cmd(0));

    CASE msgtype IS
      WHEN ADC_PRESENT_REQUEST =>
        Present(Self, cmd, resp);

      WHEN ADC_CONFIGURE_REQUEST =>
        Configure(Self, cmd, resp);

      WHEN ADC_Read_Request =>
        Read(Self, cmd, resp);

      WHEN OTHERS =>
        RAISE Program_Error WITH
          "Unexected message type: " & MessageTypes'Image(msgtype);
    END CASE;
  END Dispatch;

END RemoteIO.ADC;
