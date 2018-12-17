-- Remote I/O Server Dispatcher for ADC commands

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

WITH Device;
WITH errno;
WITH ADC.libsimpleio;
WITH Logging;
WITH Message64;
WITH RemoteIO.Dispatch;
WITH RemoteIO.Executive;
WITH RemoteIO.Server;

USE TYPE Message64.Byte;

PACKAGE BODY RemoteIO.ADC IS

  PROCEDURE Present
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    byteindex  : Natural;
    bitmask    : Message64.Byte;

  BEGIN
    resp(0) := MessageTypes'Pos(ADC_PRESENT_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    FOR c IN ChannelNumber LOOP
      byteindex  := c/8;
      bitmask    := 2**(7 - (c MOD 8));

      IF Self.inputs(c).registered THEN
        resp(3 + byteindex) := resp(3 + byteindex) OR bitmask;
      END IF;
    END LOOP;
  END Present;

  PROCEDURE Configure
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    num      : RemoteIO.ChannelNumber;

  BEGIN
    resp(0) := MessageTypes'Pos(ADC_CONFIGURE_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    num := RemoteIO.ChannelNumber(cmd(2));

    IF NOT Self.inputs(num).registered THEN
      resp(2) := errno.ENODEV;
    END IF;

    IF Self.inputs(num).configured THEN
      resp(3) := Message64.Byte(Self.inputs(num).resolution);
      RETURN;
    END IF;

    Self.inputs(num).inp :=
      Standard.ADC.libsimpleio.Create(Self.inputs(num).desg,
        Self.inputs(num).resolution);

    Self.inputs(num).configured := True;

    resp(3) := Message64.Byte(Self.inputs(num).resolution);
  END;

  PROCEDURE Read
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    num      : RemoteIO.ChannelNumber;
    sample   : Analog.Sample;

  BEGIN
    resp(0) := cmd(0) + 1;
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    num := RemoteIO.ChannelNumber(cmd(2));

    IF NOT Self.inputs(num).registered THEN
      resp(2) := errno.ENODEV;
      RETURN;
    END IF;

    sample := Self.inputs(num).inp.Get;

  EXCEPTION
    WHEN OTHERS =>
      resp(2) := errno.EIO;
  END Read;

  FUNCTION Create
   (logger   : Logging.Logger;
    executor : IN OUT RemoteIO.Executive.Executor) RETURN Dispatcher IS

    Self : Dispatcher;

  BEGIN
    Self := NEW DispatcherSubclass'(logger, (OTHERS => Unused));

    executor.Register(ADC_PRESENT_REQUEST,   RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(ADC_CONFIGURE_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(ADC_READ_REQUEST,      RemoteIO.Dispatch.Dispatcher(Self));

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
      WHEN ADC_PRESENT_REQUEST =>
        Present(Self, cmd, resp);

      WHEN ADC_CONFIGURE_REQUEST =>
        Configure(Self, cmd, resp);

      WHEN ADC_Read_Request =>
        Read(Self, cmd, resp);

      WHEN OTHERS =>
        Self.logger.Error("Unexected message type: " &
          MessageTypes'Image(msgtype));
    END CASE;
  END Dispatch;

  -- Register analog input by device designator

  PROCEDURE Register
   (Self       : IN OUT DispatcherSubclass;
    num        : ChannelNumber;
    desg       : Device.Designator;
    resolution : Natural) IS

  BEGIN
    IF Self.inputs(num).registered THEN
      RETURN;
    END IF;

    Self.inputs(num) := InputRec'(desg, resolution, NULL, True, False);
  END Register;

  -- Register analog input by preconfigured object access

  PROCEDURE Register
   (Self       : IN OUT DispatcherSubclass;
    num        : ChannelNumber;
    inp        : Analog.Input;
    resolution : Natural) IS

  BEGIN
    IF Self.inputs(num).registered THEN
      RETURN;
    END IF;

    Self.inputs(num) :=
      InputRec'(Device.Unavailable, resolution, inp, True, True);
  END Register;

END RemoteIO.ADC;
