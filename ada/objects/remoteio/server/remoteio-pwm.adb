-- Remote I/O Server Dispatcher for PWM commands

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

WITH errno;
WITH Messaging;

USE TYPE Messaging.Byte;

PACKAGE BODY RemoteIO.PWM IS

  FUNCTION Create
   (executor : NOT NULL RemoteIO.Executive.Executor) RETURN Dispatcher IS

    Self : Dispatcher;

  BEGIN
    Self := NEW DispatcherSubclass'(outputs => (OTHERS => Unused));

    executor.Register(PWM_PRESENT_REQUEST,   RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(PWM_CONFIGURE_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(PWM_WRITE_REQUEST,     RemoteIO.Dispatch.Dispatcher(Self));

    RETURN Self;
  END Create;

  -- Register PWM output by device designator

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    desg : Device.Designator) IS

  BEGIN
    IF Self.outputs(num).registered THEN
      RETURN;
    END IF;

    Self.outputs(num).registered := True;
    Self.outputs(num).configured := False;
    Self.outputs(num).preconfig  := False;
    Self.outputs(num).desg       := desg;
    Self.outputs(num).obj        := Standard.PWM.libsimpleio.Destroyed;
    Self.outputs(num).output     := Self.outputs(num).obj'Unchecked_Access;
    Self.outputs(num).period     := 0;
  END Register;

  -- Register PWM output by preconfigured object access

  PROCEDURE Register
   (Self   : IN OUT DispatcherSubclass;
    num    : ChannelNumber;
    output : NOT NULL Standard.PWM.Output;
    freq   : Positive) IS

  BEGIN
    IF Self.outputs(num).registered THEN
      RETURN;
    END IF;

    Self.outputs(num).registered := True;
    Self.outputs(num).configured := True;
    Self.outputs(num).preconfig  := True;
    Self.outputs(num).desg       := Device.Unavailable;
    Self.outputs(num).obj        := Standard.PWM.libsimpleio.Destroyed;
    Self.outputs(num).output     := output;
    Self.outputs(num).period     := 1000000000/freq;
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

    num    : RemoteIO.ChannelNumber;
    period : Positive;
    freq   : Positive;

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

    -- Check for preconfigured PWM output

    IF Self.outputs(num).preconfig THEN
      RETURN;
    END IF;

    -- Calculate the PWM pulse period in nanoseconds

    period :=
      Natural(cmd(3))*16777216 +
      Natural(cmd(4))*65536 +
      Natural(cmd(5))*256 +
      Natural(cmd(6));

    -- Calculate the PWM pulse frequency from the period

    freq := 1000000000/period;

    -- Configure the PWM output

    Standard.PWM.libsimpleio.Initialize(Self.outputs(num).obj,
      Self.outputs(num).desg, freq);

    Self.outputs(num).configured := True;
    Self.outputs(num).period     := period;

  EXCEPTION
    WHEN OTHERS =>
      resp(2) := errno.EIO;
  END;

  PROCEDURE Write
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    num    : RemoteIO.ChannelNumber;
    ontime : Natural;

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

    ontime :=
      Natural(cmd(3))*16777216 +
      Natural(cmd(4))*65536 +
      Natural(cmd(5))*256 +
      Natural(cmd(6));

    Self.outputs(num).output.Put(Duration(ontime)/1E9);

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
      WHEN PWM_PRESENT_REQUEST =>
        Present(Self, cmd, resp);

      WHEN PWM_CONFIGURE_REQUEST =>
        Configure(Self, cmd, resp);

      WHEN PWM_WRITE_REQUEST =>
        Write(Self, cmd, resp);

      WHEN OTHERS =>
        RAISE Program_Error WITH
          "Unexected message type: " & MessageTypes'Image(msgtype);
    END CASE;
  END Dispatch;

END RemoteIO.PWM;
