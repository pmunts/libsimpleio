-- Remote I/O Server Dispatcher for SPI commands

-- Copyright (C)2018-2023, Philip Munts.
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
WITH SPI;
WITH Messaging;

USE TYPE SPI.Microseconds;
USE TYPE Messaging.Byte;

PACKAGE BODY RemoteIO.SPI IS

  FUNCTION Create
   (executor : NOT NULL RemoteIO.Executive.Executor) RETURN Dispatcher IS

    Self : Dispatcher;

  BEGIN
    Self := NEW DispatcherSubclass'(devices => (OTHERS => Unused));

    executor.Register(SPI_PRESENT_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(SPI_CONFIGURE_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(SPI_TRANSACTION_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));

    RETURN Self;
  END Create;

  -- Register SPI slave device by device designato

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    desg : Device.Designator) IS

  BEGIN
    IF Self.devices(num).registered THEN
      RETURN;
    END IF;

    Self.devices(num).registered := True;
    Self.devices(num).configured := False;
    Self.devices(num).preconfig  := False;
    Self.devices(num).desg       := desg;
    Self.devices(num).obj        := Standard.SPI.libsimpleio.Destroyed;
    Self.devices(num).device     := Self.devices(num).obj'Unchecked_Access;
  END Register;

  -- Register SPI slave device by preconfigured object access

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    dev  : NOT NULL Standard.SPI.Device) IS

  BEGIN
    IF Self.devices(num).registered THEN
      RETURN;
    END IF;

    Self.devices(num).registered := True;
    Self.devices(num).configured := True;
    Self.devices(num).preconfig  := True;
    Self.devices(num).desg       := Device.Unavailable;
    Self.devices(num).obj        := Standard.SPI.libsimpleio.Destroyed;
    Self.devices(num).device     := dev;
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

      IF Self.devices(c).registered THEN
        resp(3 + byteindex) := resp(3 + byteindex) OR bitmask;
      END IF;
    END LOOP;
  END Present;

  PROCEDURE Configure
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    num      : RemoteIO.ChannelNumber;
    mode     : Natural;
    wordsize : Natural;
    speed    : Natural;

  BEGIN
    resp := (cmd(0) + 1, cmd(1), OTHERS => 0);

    -- Make sure the channel number is valid

    IF Natural(cmd(2)) > RemoteIO.ChannelNumber'Last THEN
      resp(2) := errno.EINVAL;
      RETURN;
    END IF;

    num := RemoteIO.ChannelNumber(cmd(2));

    -- Make sure the channel is available

    IF NOT Self.devices(num).registered THEN
      resp(2) := errno.ENXIO;
    END IF;

    -- Check for preconfigured SPI device

    IF Self.devices(num).preconfig THEN
      RETURN;
    END IF;

    mode     := Natural(cmd(3));
    wordsize := Natural(cmd(4));
    speed    := Natural(cmd(5))*2**24 + Natural(cmd(6))*2**16 +
      Natural(cmd(7))*2**8 + Natural(cmd(8));

    Self.devices(num).obj.Initialize(Self.devices(num).desg, mode, wordsize, speed);
    Self.devices(num).configured := True;

  EXCEPTION
    WHEN OTHERS =>
      resp(2) := errno.EIO;
  END;

  PROCEDURE Transaction
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    num      : RemoteIO.ChannelNumber;
    dev      : Standard.SPI.Device;
    icmdlen  : Natural RANGE 0 .. 56;
    iresplen : Natural RANGE 0 .. 60;
    delayus  : Standard.SPI.Microseconds;
    icmd     : Standard.SPI.Command(7 .. 63)  := (OTHERS => 0);
    iresp    : Standard.SPI.Response(4 .. 63) := (OTHERS => 0);

  BEGIN
    resp := (cmd(0) + 1, cmd(1), OTHERS => 0);

    -- Make sure the channel number is valid

    IF Natural(cmd(2)) > RemoteIO.ChannelNumber'Last THEN
      resp(2) := errno.EINVAL;
      RETURN;
    END IF;

    num := RemoteIO.ChannelNumber(cmd(2));

    -- Make sure the channel is available

    IF NOT Self.devices(num).registered THEN
      resp(2) := errno.ENXIO;
      RETURN;
    END IF;

    IF NOT Self.devices(num).configured THEN
      resp(2) := errno.ENODEV;
      RETURN;
    END IF;

    dev      := Self.devices(num).device;
    icmdlen  := Natural(cmd(3));
    iresplen := Natural(cmd(4));
    delayus  := Standard.SPI.Microseconds(cmd(5))*256 +
      Standard.SPI.Microseconds(cmd(6));

    -- Copy bytes from command message to SPI command buffer

    IF (icmdlen > 0) THEN
      FOR i IN icmd'Range LOOP
        icmd(i) := Standard.SPI.Byte(cmd(i));
      END LOOP;
    END IF;

    -- Perform the SPI bus transaction

    IF (icmdlen /= 0) AND (iresplen /= 0) THEN
      dev.Transaction(icmd, icmdlen, iresp, iresplen, delayus);
    ELSIF icmdlen /= 0 THEN
      dev.Write(icmd, icmdlen);
    ELSIF iresplen /= 0 THEN
      dev.Read(iresp, iresplen);
    END IF;

    -- Copy bytes from SPI response buffer to response message

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
      WHEN SPI_PRESENT_REQUEST =>
        Present(Self, cmd, resp);

      WHEN SPI_CONFIGURE_REQUEST =>
        Configure(Self, cmd, resp);

      WHEN SPI_TRANSACTION_REQUEST =>
        Transaction(Self, cmd, resp);

      WHEN OTHERS =>
        RAISE Program_Error WITH
          "Unexected message type: " & MessageTypes'Image(msgtype);
    END CASE;
  END Dispatch;

END RemoteIO.SPI;
