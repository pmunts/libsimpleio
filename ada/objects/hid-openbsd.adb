-- 64-byte message services using the raw HID services from the OpenBSD kernel

-- Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

-- This package requires the OpenBSD hotplug daemon hotplugd to be enabled and
-- the USB raw HID hotplug helpers for OpenBSD in libsimpleio/openbsd/hotplug/
-- to be installed.

WITH Interfaces.C;
WITH System;

USE TYPE Interfaces.C.int;

PACKAGE BODY HID.OpenBSD IS

  -- Bind to some OpenBSD C library functions

  TYPE ssize_t IS NEW Long_Integer;

  TYPE pollfd IS RECORD
    fd      : Interfaces.C.int;
    events  : Interfaces.C.short;
    revents : Interfaces.C.short;
  END RECORD;

  O_RDWR : CONSTANT := 16#0002#;    -- From /usr/include/fcntl.h
  POLLIN : CONSTANT := 16#0001#;    -- From /usr/include/sys/poll.h
  EAGAIN : CONSTANT := 35;          -- From /usr/include/sys/errno.h

  FUNCTION Open
   (path      : Interfaces.C.char_array;
    flags     : Interfaces.C.int;
    mode      : Interfaces.C.int := 0) RETURN Interfaces.C.int;

  PRAGMA Import(C, Open, "open");

  FUNCTION Close(fd : Interfaces.C.int) RETURN Interfaces.C.int;

  PRAGMA Import(C, Close, "close");

  FUNCTION Read
   (fd        : Interfaces.C.int;
    msg       : System.Address;
    len       : Interfaces.C.size_t) RETURN ssize_t;

  PRAGMA Import(C, Read, "read");

  FUNCTION Write
   (fd        : Interfaces.C.int;
    msg       : System.Address;
    len       : Interfaces.C.size_t) RETURN ssize_t;

  PRAGMA Import(C, Write, "write");

  FUNCTION Poll
   (fds       : System.Address;
    nfds      : Integer;
    timeoutms : Integer) RETURN Integer;

  PRAGMA Import(C, Poll, "poll");

  -- Implement strerror() for Ada on OpenBSD

  FUNCTION errno RETURN Interfaces.C.int;

  PRAGMA Import(C, errno, "__get_errno");

  FUNCTION strerror_r
   (err : Interfaces.C.int;
    dst : OUT Interfaces.C.char_array;
    len : Interfaces.C.size_t) RETURN Interfaces.C.int;

  PRAGMA Import(C, strerror_r, "strerror_r");

  FUNCTION strerror(err : Interfaces.C.int) RETURN String IS

    status : Interfaces.C.int;
    msg    : Interfaces.C.char_array(0 .. 255);

  BEGIN
    status := strerror_r(err, msg, msg'Length);
    RETURN Interfaces.C.To_Ada(msg);
  END strerror;

 -- Constructor using raw HID device node name

  FUNCTION Create
   (name      : String;
    timeoutms : Natural := 1000) RETURN Message64.Messenger IS

    Self : MessengerSubclass;

  BEGIN
    Self.Initialize(name, timeoutms);
    RETURN NEW MessengerSubclass'(Self);
  END Create;

  -- Constructor using HID vendor and product ID's

  FUNCTION Create
   (vid       : HID.Vendor;
    pid       : HID.Product;
    serial    : String := "";
    timeoutms : Natural := 1000) RETURN Message64.Messenger IS

    Self : MessengerSubclass;

  BEGIN
    Self.Initialize(vid, pid, serial, timeoutms);
    RETURN NEW MessengerSubclass'(Self);
  END Create;

  -- Constructor using open file descriptor

  FUNCTION Create
   (fd        : Integer;
    timeoutms : Natural := 1000) RETURN Message64.Messenger IS

    Self : MessengerSubclass;

  BEGIN
    Self.Initialize(fd, timeoutms);
    RETURN NEW MessengerSubclass'(Self);
  END Create;

  -- Initializer using raw HID device node name

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    name      : String;
    timeoutms : Natural := 1000) IS

    fd : Integer;

  BEGIN
    Self.Destroy;

    fd := Integer(Open(Interfaces.C.To_C(name), O_RDWR));

    IF fd < 0 THEN
      RAISE HID_Error WITH "Open() failed, " & strerror(errno);
    END IF;

    Self := MessengerSubclass'(fd, timeoutms);
  END Initialize;

  -- Initializer using HID vendor and product ID's

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    vid       : HID.Vendor;
    pid       : HID.Product;
    serial    : String := "";
    timeoutms : Natural := 1000) IS

  BEGIN
    IF serial = "" THEN
      Initialize(Self, "/dev/hidraw-" & HID.ToString(vid, pid, HID.Lower),
        timeoutms);
    ELSE
      Initialize(Self, "/dev/hidraw-" & HID.ToString(vid, pid, HID.Lower) &
        "-" & serial, timeoutms);
    END IF;
  END Initialize;

  -- Initializer using open file descriptor

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    fd        : Integer;
    timeoutms : Natural := 1000) IS

  BEGIN
    Self.Destroy;

    Self := MessengerSubclass'(fd, timeoutms);
  END Initialize;

  -- Destructor

  PROCEDURE Destroy(Self : IN OUT MessengerSubclass) IS

    status : Interfaces.C.int;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    status := Close(Interfaces.C.int(Self.fd));

    Self := Destroyed;

    IF status /= 0 THEN
      RAISE HID_Error WITH "Close() failed, " & strerror(errno);
    END IF;
  END Destroy;

  -- Send a message

  PROCEDURE Send(Self : MessengerSubclass; msg : Message64.Message) IS

  BEGIN
    Self.CheckDestroyed;

    IF Write(Interfaces.C.int(Self.fd), msg'Address, msg'Length) < 0 THEN
      RAISE HID_Error WITH "Write() failed, " & strerror(errno);
    END IF;
  END Send;

  -- Receive a message

  PROCEDURE Receive(Self : MessengerSubclass; msg : OUT Message64.Message) IS

    fds    : pollfd;
    status : Integer;

  BEGIN
    Self.CheckDestroyed;

    IF Self.timeoutms > 0 THEN
      fds.fd      := Interfaces.C.int(Self.fd);
      fds.events  := POLLIN;
      fds.revents := 0;

      status := Poll(fds'Address, 1, Self.timeoutms);

      IF status = 0 THEN
        RAISE HID_Error WITH "Poll() timed out";
      ELSIF status = -1 THEN
        RAISE HID_Error WITH "Poll() failed, " & strerror(errno);
      END IF;
    END IF;

    IF Read(Interfaces.C.int(Self.fd), msg'Address, msg'Length) < 0 THEN
      RAISE HID_Error WITH "Read() failed, " & strerror(errno);
    END IF;
  END Receive;

-- Check whether the HID device has been destroyed

  PROCEDURE CheckDestroyed(Self : MessengerSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE HID_Error WITH "HID device has been destroyed";
    END IF;
  END CheckDestroyed;

 END HID.OpenBSD;
