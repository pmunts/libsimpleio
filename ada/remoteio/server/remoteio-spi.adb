-- Remote I/O Server Dispatcher for SPI commands

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
WITH SPI.libsimpleio;
WITH Logging;
WITH Message64;
WITH RemoteIO.Dispatch;
WITH RemoteIO.Executive;
WITH RemoteIO.Server;

USE TYPE SPI.Microseconds;
USE TYPE Message64.Byte;

PACKAGE BODY RemoteIO.SPI IS

  PROCEDURE Present
   (Self : IN OUT DispatcherSubclass;
    cmd  : Message64.Message;
    resp : OUT Message64.message) IS

    byteindex  : Natural;
    bitmask    : Message64.Byte;

  BEGIN
    resp(0) := MessageTypes'Pos(SPI_PRESENT_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    FOR c IN ChannelNumber LOOP
      byteindex  := c/8;
      bitmask    := 2**(7 - (c MOD 8));

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
    resp(0) := MessageTypes'Pos(SPI_CONFIGURE_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    num      := RemoteIO.ChannelNumber(cmd(2));

    IF NOT Self.devices(num).registered THEN
      resp(2) := errno.ENODEV;
    END IF;

    IF Self.devices(num).configured THEN
      RETURN;
    END IF;

    mode     := Natural(cmd(3));
    wordsize := Natural(cmd(4));
    speed    := Natural(cmd(5))*2**24 + Natural(cmd(6))*2**16 +
      Natural(cmd(7))*2**8 + Natural(cmd(8));

    Self.devices(num).device :=
      Standard.SPI.libsimpleio.Create(Self.devices(num).desg, mode, wordsize,
      speed);

    Self.devices(num).configured := True;
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
    resp(0) := MessageTypes'Pos(SPI_TRANSACTION_RESPONSE);
    resp(1) := cmd(1);
    resp(2) := 0;
    resp(3 .. 63) := (OTHERS => 0);

    num      := RemoteIO.ChannelNumber(cmd(2));

    -- Make sure the device is available

    IF NOT Self.devices(num).registered THEN
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
        resp(i) := Message64.Byte(iresp(i));
      END LOOP;

      resp(3) := Message64.Byte(iresplen);
    END IF;
  EXCEPTION
    WHEN OTHERS =>
      resp(2) := errno.EIO;
  END Transaction;

  FUNCTION Create
   (logger   : Logging.Logger;
    executor : IN OUT RemoteIO.Executive.Executor) RETURN Dispatcher IS

    Self : Dispatcher;

  BEGIN
    Self := NEW DispatcherSubclass'(logger, (OTHERS => Unused));

    executor.Register(SPI_PRESENT_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(SPI_CONFIGURE_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));
    executor.Register(SPI_TRANSACTION_REQUEST, RemoteIO.Dispatch.Dispatcher(Self));

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
      WHEN SPI_PRESENT_REQUEST =>
        Present(Self, cmd, resp);

      WHEN SPI_CONFIGURE_REQUEST =>
        Configure(Self, cmd, resp);

      WHEN SPI_TRANSACTION_REQUEST =>
        Transaction(Self, cmd, resp);

      WHEN OTHERS =>
        Self.logger.Error("Unexected message type: " &
          MessageTypes'Image(msgtype));
    END CASE;
  END Dispatch;

  -- Register SPI slave device by device designato

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    desg : Device.Designator) IS

  BEGIN
    IF Self.devices(num).registered THEN
      RETURN;
    END IF;

    Self.devices(num) := DeviceRec'(desg, NULL, True, False);
  END Register;

  -- Register SPI slave device by preconfigured object access

  PROCEDURE Register
   (Self : IN OUT DispatcherSubclass;
    num  : ChannelNumber;
    dev  : Standard.SPI.Device) IS

  BEGIN
    IF Self.devices(num).registered THEN
      RETURN;
    END IF;

    Self.devices(num) := DeviceRec'(Device.Unavailable, dev, True, True);
  END Register;

END RemoteIO.SPI;
