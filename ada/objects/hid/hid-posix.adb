-- Portable 64-byte message services using services from the Posix package

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

WITH Posix;

PACKAGE BODY HID.Posix IS

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

  -- Initializer using raw HID device node name

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    name      : String;
    timeoutms : Natural := 1000) IS

    fd    : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    Standard.Posix.Open_ReadWrite(name, fd, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "Open() failed, " & Standard.Posix.strerror(error);
    END IF;

    IF timeoutms = 0 THEN
      Self := MessengerSubclass'(fd, -1);
    ELSE
      Self := MessengerSubclass'(fd, timeoutms);
    END IF;
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

  -- Destructor

  PROCEDURE Destroy(Self : IN OUT MessengerSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    Standard.Posix.Close(Self.fd, error);

    Self := Destroyed;

    IF error /= 0 THEN
      RAISE HID_Error WITH "Close() failed, " & Standard.Posix.strerror(error);
    END IF;
  END Destroy;

  -- Send a message

  PROCEDURE Send(Self : MessengerSubclass; msg : Message64.Message) IS

    error : Integer;
    count : Natural;

  BEGIN
    Self.CheckDestroyed;

    Standard.Posix.Write(Self.fd, msg'Address, msg'Length, count, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "Write() failed, " & Standard.Posix.strerror(error);
    END IF;
  END Send;

  -- Receive a message

  PROCEDURE Receive(Self : MessengerSubclass; msg : OUT Message64.Message) IS

    count : Integer;
    error : Integer;

  BEGIN
    Self.CheckDestroyed;

    IF Self.timeoutms > 0 THEN
      Standard.Posix.Poll(Self.fd, Self.timeoutms, error);

      IF error = Standard.Posix.ETIMEOUT THEN
        RAISE HID_Error WITH "Poll() timed out";
      ELSIF error /= 0 THEN
        RAISE HID_Error WITH "Poll() failed, " & Standard.Posix.strerror(error);
      END IF;
    END IF;

    Standard.Posix.Read(Self.fd, msg'Address, msg'Length, count, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "Read() failed, " & Standard.Posix.strerror(error);
    END IF;
  END Receive;

-- Check whether the HID device has been destroyed

  PROCEDURE CheckDestroyed(Self : MessengerSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE HID_Error WITH "HID device has been destroyed";
    END IF;
  END CheckDestroyed;

 END HID.Posix;
