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

WITH errno;
WITH GPIO.libsimpleio.Static;
WITH Message64;
WITH RemoteIO.Server;

USE TYPE GPIO.libsimpleio.PinSubclass;
USE TYPE Message64.Byte;

PACKAGE BODY RemoteIO.GPIO_libsimpleio IS

  FUNCTION Create
   (logger   : Logging.Logger;
    executor : IN OUT RemoteIO.Executive.Executor) RETURN DispatcherSubclass IS

    Self : ACCESS DispatcherSubclass;

  BEGIN
    Self := NEW DispatcherSubclass'(logger, (OTHERS => Unregistered));

    executor.Register(GPIO_PRESENT_REQUEST, Self);
    executor.Register(GPIO_CONFIGURE_REQUEST, Self);
    executor.Register(GPIO_READ_REQUEST, Self);
    executor.Register(GPIO_WRITE_REQUEST, Self);

    RETURN Self.ALL;
  END Create;

  PROCEDURE Present
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    byteindex  : Natural;
    bitmask    : Message64.Byte;
    registered : Boolean;

  BEGIN
    resp(0) := MessageTypes'Pos(GPIO_PRESENT_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    FOR c IN ChannelNumber LOOP
      byteindex  := c/8;
      bitmask    := 2**(c MOD 8);
      registered := (Self.pins(c) /= Unregistered);

      IF registered THEN
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
    registered : Boolean;
    created    : Boolean;
    output     : Boolean;

  BEGIN
    resp(0) := MessageTypes'Pos(GPIO_CONFIGURE_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    FOR c IN ChannelNumber LOOP
      byteindex  := c/8;
      bitmask    := 2**(c MOD 8);
      selected   := ((cmd(2 + byteindex) AND bitmask) /= 0);
      registered := (Self.pins(c) /= Unregistered);
      created    := (Self.pins(c).obj /= Standard.GPIO.libsimpleio.Destroyed);
      output     := ((cmd(18 + byteindex) AND bitmask) /= 0);

      IF selected AND registered THEN
        BEGIN
          -- Destroy the GPIO pin if it has been previously configured

          IF created THEN
            Standard.GPIO.libsimpleio.Static.Destroy(Self.pins(c).obj);
          END IF;

          -- (Re)Create the GPIO pin

          IF output THEN
            Self.pins(c).obj :=
              Standard.GPIO.libsimpleio.Static.Create(Self.pins(c).pin,
              Standard.GPIO.Output);
          ELSE
            Self.pins(c).obj :=
              Standard.GPIO.libsimpleio.Static.Create(Self.pins(c).pin,
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
    registered : Boolean;
    created    : Boolean;

  BEGIN
    resp(0) := MessageTypes'Pos(GPIO_READ_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    FOR c IN ChannelNumber LOOP
      byteindex  := c/8;
      bitmask    := 2**(c MOD 8);
      selected   := ((cmd(2 + byteindex) AND bitmask) /= 0);
      registered := (Self.pins(c) /= Unregistered);
      created    := (Self.pins(c).obj /= Standard.GPIO.libsimpleio.Destroyed);

      IF selected AND registered AND created THEN
        BEGIN
          IF Self.pins(c).obj.Get THEN
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
    registered : Boolean;
    created    : Boolean;
    state      : Boolean;

  BEGIN
    resp(0) := MessageTypes'Pos(GPIO_WRITE_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    FOR c IN ChannelNumber LOOP
      byteindex  := c/8;
      bitmask    := 2**(c MOD 8);
      selected   := ((cmd(2 + byteindex) AND bitmask) /= 0);
      registered := (Self.pins(c) /= Unregistered);
      created    := (Self.pins(c).obj /= Standard.GPIO.libsimpleio.Destroyed);
      state      := ((cmd(18 + byteindex) AND bitmask) /= 0);

      IF selected AND registered AND created THEN
        BEGIN
          Self.pins(c).obj.Put(state);
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

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    desg : Standard.GPIO.libsimpleio.Designator) IS

  BEGIN
    Register(Self, num, desg.chip, desg.line);
  END Register;

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    chip : Natural;
    line : Natural) IS

  BEGIN
    Self.pins(num).pin.chip := chip;
    Self.pins(num).pin.line := line;
    Self.pins(num).obj := Standard.GPIO.libsimpleio.Destroyed;
  END Register;

END RemoteIO.GPIO_libsimpleio;
