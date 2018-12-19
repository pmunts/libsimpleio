-- Remote I/O Server Dispatcher for PWM commands

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
WITH Logging;
WITH Message64;
WITH PWM.libsimpleio;
WITH RemoteIO.Dispatch;
WITH RemoteIO.Executive;
WITH RemoteIO.Server;

USE TYPE Message64.Byte;

PACKAGE BODY RemoteIO.PWM IS

  PROCEDURE Present
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    byteindex  : Natural;
    bitmask    : Message64.Byte;

  BEGIN
    resp(0) := MessageTypes'Pos(PWM_PRESENT_RESPONSE);
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
    freq : Positive;

  BEGIN
    resp(0) := MessageTypes'Pos(PWM_CONFIGURE_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    num  := RemoteIO.ChannelNumber(cmd(2));

    IF NOT Self.outputs(num).registered THEN
      resp(2) := errno.ENODEV;
    END IF;

    IF Self.outputs(num).configured THEN
      resp(3) := 32;
      RETURN;
    END IF;

    freq :=
      Positive(cmd(3))*16777216 +
      Positive(cmd(4))*65536 +
      Positive(cmd(5))*256 +
      Positive(cmd(6));

    Self.outputs(num).output :=
      Standard.PWM.libsimpleio.Create(Self.outputs(num).desg, freq);

    Self.outputs(num).configured := True;

    resp(3) := 32;
  END;

  PROCEDURE Write
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    num  : RemoteIO.ChannelNumber;
    duty : Float;

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

    duty :=
      Float(cmd(3))*16777216.0 +
      Float(cmd(4))*65536.0 +
      Float(cmd(5))*256.0 +
      Float(cmd(6));

    duty := duty*Self.outputs(num).scalefactor;

    Self.outputs(num).output.Put(Standard.PWM.DutyCycle(duty));

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

    executor.Register(PWM_PRESENT_REQUEST,   RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(PWM_CONFIGURE_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(PWM_WRITE_REQUEST,     RemoteIO.Dispatch.Dispatcher(Self));

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
      WHEN PWM_PRESENT_REQUEST =>
        Present(Self, cmd, resp);

      WHEN PWM_CONFIGURE_REQUEST =>
        Configure(Self, cmd, resp);

      WHEN PWM_WRITE_REQUEST =>
        Write(Self, cmd, resp);

      WHEN OTHERS =>
        Self.logger.Error("Unexected message type: " &
          MessageTypes'Image(msgtype));
    END CASE;
  END Dispatch;

  -- Register PWM output by device designator

  PROCEDURE Register
   (Self       : IN OUT DispatcherSubclass;
    num        : ChannelNumber;
    desg       : Device.Designator) IS

  BEGIN
    IF Self.outputs(num).registered THEN
      RETURN;
    END IF;

    Self.outputs(num) :=
      OutputRec'(desg, 100.0/(2.0**32 - 1.0), NULL, True, False);
  END Register;

  -- Register PWM output by preconfigured object access

  PROCEDURE Register
   (Self       : IN OUT DispatcherSubclass;
    num        : ChannelNumber;
    output     : Standard.PWM.Interfaces.Output) IS

  BEGIN
    IF Self.outputs(num).registered THEN
      RETURN;
    END IF;

    Self.outputs(num) := OutputRec'(Device.Unavailable, 
      100.0/(2.0**32 - 1.0), output, True, True);
  END Register;

END RemoteIO.PWM;
