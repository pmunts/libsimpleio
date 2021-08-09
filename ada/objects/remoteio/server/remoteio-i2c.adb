-- Remote I/O Server Dispatcher for I2C commands

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
WITH I2C;
WITH Messaging;

USE TYPE I2C.Microseconds;
USE TYPE Messaging.Byte;

PACKAGE BODY RemoteIO.I2C IS

  FUNCTION Create
   (executor : NOT NULL RemoteIO.Executive.Executor) RETURN Dispatcher IS

    Self : Dispatcher;

  BEGIN
    Self := NEW DispatcherSubclass'(buses => (OTHERS => Unused));

    executor.Register(I2C_PRESENT_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(I2C_CONFIGURE_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(I2C_TRANSACTION_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));

    RETURN Self;
  END Create;

  -- Register I2C bus by device designator

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    desg : Device.Designator) IS

  BEGIN
    IF Self.buses(num).registered THEN
      RETURN;
    END IF;

    Self.buses(num).registered := True;
    Self.buses(num).configured := False;
    Self.buses(num).preconfig  := False;
    Self.buses(num).desg       := desg;
    Self.buses(num).obj        := Standard.I2C.libsimpleio.Destroyed;
    Self.buses(num).bus        := Self.buses(num).obj'Unchecked_Access;
  END Register;

  -- Register I2C bus by preconfigured object access

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    bus  : NOT NULL Standard.I2C.Bus) IS

  BEGIN
    IF Self.buses(num).registered THEN
      RETURN;
    END IF;

    Self.buses(num).registered := True;
    Self.buses(num).configured := True;
    Self.buses(num).preconfig  := True;
    Self.buses(num).desg       := Device.Unavailable;
    Self.buses(num).obj        := Standard.I2C.libsimpleio.Destroyed;
    Self.buses(num).bus        := bus;
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

      IF Self.buses(c).registered THEN
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

    IF NOT Self.buses(num).registered THEN
      resp(2) := errno.ENXIO;
      RETURN;
    END IF;

    -- Check for preconfigured I2C bus

    IF Self.buses(num).preconfig THEN
      RETURN;
    END IF;

    Self.buses(num).obj.Initialize(Self.buses(num).desg);

    Self.buses(num).configured := True;

  EXCEPTION
    WHEN OTHERS =>
      resp(2) := errno.EIO;
  END;

  PROCEDURE Transaction
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    num      : RemoteIO.ChannelNumber;
    bus      : Standard.I2C.Bus;
    addr     : Standard.I2C.Address;
    icmdlen  : Natural RANGE 0 .. 56;
    iresplen : Natural RANGE 0 .. 60;
    delayus  : Standard.I2C.Microseconds;
    icmd     : Standard.I2C.Command(8 .. 63)  := (OTHERS => 0);
    iresp    : Standard.I2C.Response(4 .. 63) := (OTHERS => 0);

  BEGIN
    resp := (cmd(0) + 1, cmd(1), OTHERS => 0);

    -- Make sure the channel number is valid

    IF Natural(cmd(2)) > RemoteIO.ChannelNumber'Last THEN
      resp(2) := errno.EINVAL;
      RETURN;
    END IF;

    num := RemoteIO.ChannelNumber(cmd(2));

    -- Make sure the channel is available

    IF NOT Self.buses(num).registered THEN
      resp(2) := errno.ENXIO;
      RETURN;
    END IF;

    IF NOT Self.buses(num).configured THEN
      resp(2) := errno.ENODEV;
      RETURN;
    END IF;

    bus      := Self.buses(num).bus;
    addr     := Standard.I2C.Address(cmd(3));
    icmdlen  := Natural(cmd(4));
    iresplen := Natural(cmd(5));
    delayus  := Standard.I2C.Microseconds(cmd(6))*256 +
      Standard.I2C.Microseconds(cmd(7));

    -- Copy bytes from command message to I2C command buffer

    IF (icmdlen > 0) THEN
      FOR i IN icmd'Range LOOP
        icmd(i) := Standard.I2C.Byte(cmd(i));
      END LOOP;
    END IF;

    -- Perform the I2C bus transaction

    IF (icmdlen /= 0) AND (iresplen /= 0) THEN
      bus.Transaction(addr, icmd, icmdlen, iresp, iresplen, delayus);
    ELSIF icmdlen /= 0 THEN
      bus.Write(addr, icmd, icmdlen);
    ELSIF iresplen /= 0 THEN
      bus.Read(addr, iresp, iresplen);
    END IF;

    -- Copy bytes from I2C response buffer to response message

    IF iresplen > 0 THEN
      FOR i IN iresp'Range LOOP
        resp(i) := Messaging.Byte(iresp(i));
      END LOOP;

      resp(3) := Messaging.Byte(iresplen);
    END IF;

  EXCEPTION
    WHEN OTHERS =>
      resp(2) := errno.EIO;
  END Transaction;

  PROCEDURE Dispatch
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.Message) IS

    msgtype : MessageTypes;

  BEGIN
    msgtype := MessageTypes'Val(cmd(0));

    CASE msgtype IS
      WHEN I2C_PRESENT_REQUEST =>
        Present(Self, cmd, resp);

      WHEN I2C_CONFIGURE_REQUEST =>
        Configure(Self, cmd, resp);

      WHEN I2C_TRANSACTION_REQUEST =>
        Transaction(Self, cmd, resp);

      WHEN OTHERS =>
        RAISE Program_Error WITH
          "Unexected message type: " & MessageTypes'Image(msgtype);
    END CASE;
  END Dispatch;

END RemoteIO.I2C;
