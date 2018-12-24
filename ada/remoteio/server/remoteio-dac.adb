-- Remote I/O Server Dispatcher for DAC commands

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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
WITH Device;
WITH errno;
WITH Logging;
WITH Message64;
WITH DAC.libsimpleio;
WITH RemoteIO.Dispatch;
WITH RemoteIO.Executive;
WITH RemoteIO.Server;

USE TYPE Analog.Sample;
USE TYPE Message64.Byte;

PACKAGE BODY RemoteIO.DAC IS

  PROCEDURE Present
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    byteindex  : Natural;
    bitmask    : Message64.Byte;

  BEGIN
    resp(0) := MessageTypes'Pos(DAC_PRESENT_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    FOR c IN ChannelNumber LOOP
      byteindex  := c/8;
      bitmask    := 2**(7 - (c MOD 8));

      IF Self.outputs(c).registered THEN
        resp(3 + byteindex) := resp(3 + byteindex) OR bitmask;
      END IF;
    END LOOP;
  END Present;

  PROCEDURE Configure
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    num  : RemoteIO.ChannelNumber;

  BEGIN
    resp(0) := MessageTypes'Pos(DAC_CONFIGURE_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    num  := RemoteIO.ChannelNumber(cmd(2));

    IF NOT Self.outputs(num).registered THEN
      resp(2) := errno.ENODEV;
    END IF;

    IF Self.outputs(num).configured THEN
      resp(3) := Message64.Byte(Self.outputs(num).resolution);
      RETURN;
    END IF;

    Self.outputs(num).output :=
      Standard.DAC.libsimpleio.Create(Self.outputs(num).desg,
        Self.outputs(num).resolution);

    Self.outputs(num).configured := True;

    resp(3) := Message64.Byte(Self.outputs(num).resolution);
  END;

  PROCEDURE Write
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    num  : RemoteIO.ChannelNumber;
    data : Analog.Sample;

  BEGIN
    resp(0) := cmd(0) + 1;
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    num  := RemoteIO.ChannelNumber(cmd(2));

    IF NOT Self.outputs(num).registered THEN
      resp(2) := errno.ENODEV;
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

  FUNCTION Create
   (logger   : Logging.Logger;
    executor : IN OUT RemoteIO.Executive.Executor) RETURN Dispatcher IS

    Self : Dispatcher;

  BEGIN
    Self := NEW DispatcherSubclass'(logger, (OTHERS => Unused));

    executor.Register(DAC_PRESENT_REQUEST,   RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(DAC_CONFIGURE_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(DAC_WRITE_REQUEST,     RemoteIO.Dispatch.Dispatcher(Self));

    RETURN Self;
  END Create;

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
        Self.logger.Error("Unexected message type: " &
          MessageTypes'Image(msgtype));
    END CASE;
  END Dispatch;

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

    Self.outputs(num) := OutputRec'(desg, resolution, NULL, True, False);
  END Register;

  -- Register DAC output by preconfigured object access

  PROCEDURE Register
   (Self       : IN OUT DispatcherSubclass;
    num        : ChannelNumber;
    output     : Analog.Output) IS

  BEGIN
    IF Self.outputs(num).registered THEN
      RETURN;
    END IF;

    Self.outputs(num) := OutputRec'(Device.Unavailable, output.GetResolution,
      output, True, True);
  END Register;

END RemoteIO.DAC;