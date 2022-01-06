-- 64-byte message services using the raw HID services in libsimpleio

-- Copyright (C)2016-2020, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Strings.Fixed;

WITH errno;
WITH libHIDRaw;
WITH libLinux;

PACKAGE BODY HID.libsimpleio IS

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

    fd    : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    libHIDRaw.Open1(name & ASCII.NUL, fd, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "libHIDRaw.Open1() failed, " &
        errno.strerror(error);
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

    fd    : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    libHIDRaw.Open3(Integer(vid), Integer(pid), serial & ASCII.NUL, fd, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "libHIDRaw.Open3() failed, " & errno.strerror(error);
    END IF;

    Self := MessengerSubclass'(fd, timeoutms);
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

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libLinux.Close(Self.fd, error);

    Self := Destroyed;

    IF error /= 0 THEN
      RAISE HID_Error WITH "libLinux.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

  -- Send a message

  PROCEDURE Send(Self : MessengerSubclass; msg : Message64.Message) IS

    error : Integer;
    count : Integer;

  BEGIN
    Self.CheckDestroyed;

    libLinux.Write(Self.fd, msg'Address, msg'Length, count, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "libLinux.Write() failed, " &
        errno.strerror(error);
    END IF;
  END Send;

  -- Receive a message

  PROCEDURE Receive(Self : MessengerSubclass; msg : OUT Message64.Message) IS

    error : Integer;
    count : Integer;

  BEGIN
    Self.CheckDestroyed;

    IF Self.timeoutms > 0 THEN
      DECLARE

        files   : libLinux.FilesType(0 .. 0)   := (OTHERS => Self.fd);
        events  : libLinux.EventsType(0 .. 0)  := (OTHERS => libLinux.POLLIN);
        results : libLinux.ResultsType(0 .. 0) := (OTHERS =>0);

      BEGIN
        libLinux.Poll(1, files, events, results, Self.timeoutms, error);

        IF error = errno.EAGAIN THEN
          RAISE HID_Error WITH "libLinux.Poll() timed out";
        END IF;

        IF error /= 0 THEN
          RAISE HID_Error WITH "libLinux.Poll() failed, " &
            errno.strerror(error);
        END IF;
      END;
    END IF;

    libLinux.Read(Self.fd, msg'Address, msg'Length, count, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "libLinux.Read() failed, " &
        errno.strerror(error);
    END IF;

    IF count /= msg'Length THEN
      RAISE HID_Error WITH "libLinux.Read() failed, " &
        "expected" & Integer'Image(msg'Length) & " bytes " &
        "but read" & Integer'Image(count) & " bytes";
    END IF;
  END Receive;

  -- Get HID device name string

  FUNCTION Name(Self : MessengerSubclass) RETURN String IS

    name  : String(1 .. 256);
    error : Integer;

  BEGIN
    Self.CheckDestroyed;

    libHIDRAW.GetName(Self.fd, name, name'Length, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "libHIDRaw.GetName() failed, " &
        errno.strerror(error);
    END IF;

    RETURN Ada.Strings.Fixed.Trim(name, Ada.Strings.Right);
  END Name;

  -- Get HID device bus type

  FUNCTION BusType(Self : MessengerSubclass) RETURN Natural IS

    bustype : Integer;
    vid     : Integer;
    pid     : Integer;
    error   : Integer;

  BEGIN
    Self.CheckDestroyed;

    libHIDRaw.GetInfo(Self.fd, bustype, vid, pid, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "libHIDRaw.GetInfo() failed, " &
        errno.strerror(error);
    END IF;

    RETURN bustype;
  END BusType;

  -- Get HID device vendor ID

  FUNCTION Vendor(Self : MessengerSubclass) RETURN HID.Vendor IS

    bustype : Integer;
    vid     : Integer;
    pid     : Integer;
    error   : Integer;

  BEGIN
    Self.CheckDestroyed;

    libHIDRaw.GetInfo(Self.fd, bustype, vid, pid, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "libHIDRaw.GetInfo() failed, " &
        errno.strerror(error);
    END IF;

    RETURN HID.Vendor(vid);
  END Vendor;

  -- Get HID device product ID

  FUNCTION Product(Self : MessengerSubclass) RETURN HID.Product IS

    bustype : Integer;
    vid     : Integer;
    pid     : Integer;
    error   : Integer;

  BEGIN
    Self.CheckDestroyed;

    libHIDRaw.GetInfo(Self.fd, bustype, vid, pid, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "libHIDRaw.GetInfo() failed, " &
        errno.strerror(error);
    END IF;

    RETURN HID.Product(pid);
  END Product;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : MessengerSubclass) RETURN Integer IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.fd;
  END fd;

  -- Check whether the HID device has been destroyed

  PROCEDURE CheckDestroyed(Self : MessengerSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE HID_Error WITH "HID device has been destroyed";
    END IF;
  END CheckDestroyed;

 END HID.libsimpleio;
