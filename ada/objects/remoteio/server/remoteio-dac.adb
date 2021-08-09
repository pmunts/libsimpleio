-- Remote I/O Server Dispatcher for DAC commands

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

PACKAGE BODY RemoteIO.DAC IS

  FUNCTION Create
   (executor : NOT NULL RemoteIO.Executive.Executor) RETURN Dispatcher IS

    Self : Dispatcher;

  BEGIN
    Self := NEW DispatcherSubclass'(outputs => (OTHERS => Unused));

    executor.Register(DAC_PRESENT_REQUEST,   RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(DAC_CONFIGURE_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(DAC_WRITE_REQUEST,     RemoteIO.Dispatch.Dispatcher(Self));

    RETURN Self;
  END Create;

  -- Register DAC output by device designator

  PROCEDURE Register
   (Self       : IN OUT DispatcherSubclass;
    num        : ChannelNumber;
    desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution) IS

  BEGIN
    IF Self.outputs(num).registered THEN
      RETURN;
    END IF;

    Self.outputs(num).registered := True;
    Self.outputs(num).configured := False;
    Self.outputs(num).desg       := desg;
    Self.outputs(num).obj        := Standard.DAC.libsimpleio.Destroyed;
    Self.outputs(num).output     := Self.outputs(num).obj'Unchecked_Access;
    Self.outputs(num).resolution := resolution;
  END Register;

  -- Register DAC output by preconfigured object access

  PROCEDURE Register
   (Self   : IN OUT DispatcherSubclass;
    num    : ChannelNumber;
    output : NOT NULL Analog.Output) IS

  BEGIN
    IF Self.outputs(num).registered THEN
      RETURN;
    END IF;

    Self.outputs(num).registered := True;
    Self.outputs(num).configured := True;
    Self.outputs(num).desg       := Device.Unavailable;
    Self.outputs(num).obj        := Standard.DAC.libsimpleio.Destroyed;
    Self.outputs(num).output     := output;
    Self.outputs(num).resolution := output.GetResolution;
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

      IF Self.outputs(c).registered THEN
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

    IF NOT Self.outputs(num).registered THEN
      resp(2) := errno.ENXIO;
      RETURN;
    END IF;

    IF Self.outputs(num).configured THEN
      resp(3) := Messaging.Byte(Self.outputs(num).resolution);
      RETURN;
    END IF;

    Self.outputs(num).obj.Initialize(Self.outputs(num).desg,
      Self.outputs(num).resolution);

    Self.outputs(num).configured := True;

    resp(3) := Messaging.Byte(Self.outputs(num).resolution);

  EXCEPTION
    WHEN OTHERS =>
      resp(2) := errno.EIO;
  END;

  PROCEDURE Write
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    num  : RemoteIO.ChannelNumber;
    data : Analog.Sample;

  BEGIN
    resp := (cmd(0) + 1, cmd(1), OTHERS => 0);

    -- Make sure the channel number is valid

    IF Natural(cmd(2)) > RemoteIO.ChannelNumber'Last THEN
      resp(2) := errno.EINVAL;
      RETURN;
    END IF;

    num := RemoteIO.ChannelNumber(cmd(2));

    -- Make sure the channel is available

    IF NOT Self.outputs(num).registered THEN
      resp(2) := errno.ENXIO;
      RETURN;
    END IF;

    IF NOT Self.outputs(num).configured THEN
      resp(2) := errno.ENODEV;
      RETURN;
    END IF;

    data :=
      Analog.Sample(cmd(3))*16777216 +
      Analog.Sample(cmd(4))*65536 +
      Analog.Sample(cmd(5))*256 +
      Analog.Sample(cmd(6));

    Self.outputs(num).output.Put(data);

  EXCEPTION
    WHEN OTHERS =>
      resp(2) := errno.EIO;
  END Write;

  PROCEDURE Dispatch
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.Message) IS

    msgtype : MessageTypes;

  BEGIN
    msgtype := MessageTypes'Val(cmd(0));

    CASE msgtype IS
      WHEN DAC_PRESENT_REQUEST =>
        Present(Self, cmd, resp);

      WHEN DAC_CONFIGURE_REQUEST =>
        Configure(Self, cmd, resp);

      WHEN DAC_WRITE_REQUEST =>
        Write(Self, cmd, resp);

      WHEN OTHERS =>
        RAISE Program_Error WITH
          "Unexected message type: " & MessageTypes'Image(msgtype);
    END CASE;
  END Dispatch;

END RemoteIO.DAC;
