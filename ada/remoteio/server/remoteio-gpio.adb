-- Remote I/O Server Dispatcher for GPIO commands

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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH errno;
WITH GPIO.libsimpleio.Static;
WITH Message64;
WITH RemoteIO.Server;

USE TYPE GPIO.libsimpleio.Designator;
USE TYPE GPIO.libsimpleio.PinSubclass;
USE TYPE Message64.Byte;

PACKAGE BODY RemoteIO.GPIO IS

  FUNCTION Create
   (logger   : Logging.Logger;
    executor : IN OUT RemoteIO.Executive.Executor) RETURN Dispatcher IS

    Self : Dispatcher;

  BEGIN
    Self := NEW DispatcherSubclass'(logger, (OTHERS => Unused));

    executor.Register(GPIO_PRESENT_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(GPIO_CONFIGURE_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(GPIO_READ_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(GPIO_WRITE_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));

    RETURN Self;
  END Create;

  PROCEDURE Present
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    byteindex  : Natural;
    bitmask    : Message64.Byte;

  BEGIN
    resp(0) := MessageTypes'Pos(GPIO_PRESENT_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    FOR c IN ChannelNumber LOOP
      byteindex  := c/8;
      bitmask    := 2**(7 - (c MOD 8));

      IF Self.pins(c).registered THEN
        resp(3 + byteindex) := resp(3 + byteindex) OR bitmask;
      END IF;
    END LOOP;
  END Present;

  PROCEDURE Configure
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    byteindex  : Natural;
    bitmask    : Message64.Byte;
    selected   : Boolean;
    output     : Boolean;
    registered : Boolean;
    configable : Boolean;

  BEGIN
    resp(0) := MessageTypes'Pos(GPIO_CONFIGURE_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    FOR c IN ChannelNumber LOOP
      byteindex  := c/8;
      bitmask    := 2**(7 - (c MOD 8));
      selected   := ((cmd(2 + byteindex) AND bitmask) /= 0);
      output     := ((cmd(18 + byteindex) AND bitmask) /= 0);
      registered := Self.pins(c).registered;
      configable := NOT Self.pins(c).preconfig;

      IF selected AND registered AND configable THEN
        BEGIN
          -- Destroy the GPIO pin if it has been previously configured

          IF Self.pins(c).configured THEN
            Standard.GPIO.libsimpleio.Static.Destroy(Self.pins(c).obj.ALL);
          END IF;

          -- Configure the GPIO pin

          IF output THEN
            Self.pins(c).obj.ALL :=
              Standard.GPIO.libsimpleio.Static.Create(Self.pins(c).desg,
              Standard.GPIO.Output);
          ELSE
            Self.pins(c).obj.ALL :=
              Standard.GPIO.libsimpleio.Static.Create(Self.pins(c).desg,
              Standard.GPIO.Input);
          END IF;
        EXCEPTION
          WHEN OTHERS =>
            Self.logger.Error("Caught exception");
        END;
      END IF;
    END LOOP;
  END Configure;

  PROCEDURE Read
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    byteindex  : Natural;
    bitmask    : Message64.Byte;
    selected   : Boolean;
    configured : Boolean;

  BEGIN
    resp(0) := MessageTypes'Pos(GPIO_READ_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    FOR c IN ChannelNumber LOOP
      byteindex  := c/8;
      bitmask    := 2**(7 - (c MOD 8));
      selected   := ((cmd(2 + byteindex) AND bitmask) /= 0);
      configured := Self.pins(c).registered AND Self.pins(c).configured;

      IF selected AND configured THEN
        BEGIN
          IF Self.pins(c).pin.Get THEN
            resp(3 + byteindex) := resp(3 + byteindex) OR bitmask;
          END IF;
        EXCEPTION
          WHEN OTHERS =>
            Self.logger.Error("Caught exception");
        END;
      END IF;
    END LOOP;
  END Read;

  PROCEDURE Write
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    byteindex  : Natural;
    bitmask    : Message64.Byte;
    selected   : Boolean;
    state      : Boolean;
    configured : Boolean;
    writable   : Boolean;

  BEGIN
    resp(0) := MessageTypes'Pos(GPIO_WRITE_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    FOR c IN ChannelNumber LOOP
      byteindex  := c/8;
      bitmask    := 2**(7 - (c MOD 8));
      selected   := ((cmd(2 + byteindex) AND bitmask) /= 0);
      state      := ((cmd(18 + byteindex) AND bitmask) /= 0);
      configured := Self.pins(c).registered AND Self.pins(c).configured;
      writable   := Self.pins(c).kind /= InputOnly;

      IF selected AND configured AND writable THEN
        BEGIN
          Self.pins(c).pin.Put(state);
        EXCEPTION
          WHEN OTHERS =>
            Self.logger.Error("Caught exception");
        END;
      END IF;
    END LOOP;
  END Write;

  PROCEDURE Dispatch
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.Message) IS

    msgtype : MessageTypes;

  BEGIN
    msgtype := MessageTypes'Val(cmd(0));

    CASE msgtype IS
      WHEN GPIO_PRESENT_REQUEST =>
        Present(Self, cmd, resp);

      WHEN GPIO_CONFIGURE_REQUEST =>
        Configure(Self, cmd, resp);

      WHEN GPIO_READ_REQUEST =>
        Read(Self, cmd, resp);

      WHEN GPIO_WRITE_REQUEST =>
        Write(Self, cmd, resp);

      WHEN OTHERS =>
        Self.logger.Error("Unexected message type: " &
          MessageTypes'Image(msgtype));
    END CASE;
  END Dispatch;

  -- Register libsimpleio GPIO pin by specified designator

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    desg : Standard.GPIO.libsimpleio.Designator;
    kind : Kinds := InputOutput) IS

  BEGIN
    Register(Self, num, desg.chip, desg.chan, kind);
  END Register;

  -- Register libsimpleio GPIO pin by specified chip and line

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    chip : Natural;
    line : Natural;
    kind : Kinds := InputOutput) IS

  BEGIN
    IF Self.pins(num).registered THEN
      RETURN;
    END IF;

    Self.pins(num).registered := True;
    Self.pins(num).kind       := kind;
    Self.pins(num).desg.chip  := chip;
    Self.pins(num).desg.chan  := line;

    CASE kind IS
      WHEN InputOnly =>
        Self.pins(num).configured := True;
        Self.pins(num).preconfig  := True;
        Self.pins(num).obj :=
          NEW Standard.GPIO.libsimpleio.PinSubclass'
           (Standard.GPIO.libsimpleio.Static.Create(Self.pins(num).desg,
            Standard.GPIO.Input));

      WHEN OutputOnly =>
        Self.pins(num).configured := True;
        Self.pins(num).preconfig  := True;
        Self.pins(num).obj :=
          NEW Standard.GPIO.libsimpleio.PinSubclass'
           (Standard.GPIO.libsimpleio.Static.Create(Self.pins(num).desg,
            Standard.GPIO.Output));

      WHEN InputOutput =>
        Self.pins(num).configured := False;
        Self.pins(num).preconfig  := False;
        Self.pins(num).obj :=
          NEW Standard.GPIO.libsimpleio.PinSubclass'
           (Standard.GPIO.libsimpleio.Destroyed);
    END CASE;

    Self.pins(num).pin := Standard.GPIO.Pin(Self.pins(num).obj);
  END Register;

  -- Register an arbitrary preconfigured GPIO pin

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    pin  : Standard.GPIO.Pin;
    kind : Kinds := InputOutput) IS

  BEGIN
    IF Self.pins(num).registered THEN
      RETURN;
    END IF;

    Self.pins(num).registered := True;
    Self.pins(num).configured := True;
    Self.pins(num).preconfig  := True;
    Self.pins(num).kind       := kind;
    Self.pins(num).pin        := pin;
  END Register;

END RemoteIO.GPIO;
