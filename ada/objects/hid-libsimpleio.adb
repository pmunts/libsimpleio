-- 64-byte message services using the raw HID services in libsimpleio

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

WITH Ada.Strings;
WITH Ada.Strings.Fixed;

WITH errno;
WITH libHIDRaw;
WITH libLinux;
WITH Message64;

PACKAGE BODY HID.libsimpleio IS

  -- Constructor using raw HID device node name

  FUNCTION Create
   (name      : String;
    timeoutms : Integer := 1000) RETURN Message64.Messenger IS

    fd    : Integer;
    error : Integer;

  BEGIN
    libHIDRaw.Open(name & ASCII.NUL, fd, error);

    IF error /= 0 THEN
      RAISE Standard.HID.HID_Error WITH "libHIDRaw.Open() failed, " &
        errno.strerror(error);
    END IF;

    RETURN NEW MessengerSubclass'(fd, timeoutms);
  END Create;

  -- Constructor using HID vendor and product ID's

  FUNCTION Create
   (vid       : Standard.HID.Vendor;
    pid       : Standard.HID.Product;
    timeoutms : Integer := 1000) RETURN Message64.Messenger IS

    fd    : Integer;
    error : Integer;

  BEGIN
    libHIDRaw.OpenID(Integer(vid), Integer(pid), fd, error);

    IF error /= 0 THEN
      RAISE Standard.HID.HID_Error WITH "libHIDRaw.OpenID() failed, " &
        errno.strerror(error);
    END IF;

    RETURN NEW MessengerSubclasbindings/liblinux.adss'(fd, timeoutms);
  END;

  -- Send a message to a HID device

  PROCEDURE Send(self : MessengerSubclass; msg : Message64.Message) IS

    error : Integer;
    count : Integer;

  BEGIN
    IF self.timeout > 0 THEN
      DECLARE

        files   : libLinux.FilesType(0 .. 0)  := self.fd;
        events  : liblinux.EventsType(0 .. 0) := libLinux.POLLOUT;
        results : liblinux.EventsType(0 .. 0) := 0;

      BEGIN
        libLinux.Poll(1, files, events, results, self.timeout, error);

        IF error /= 0 THEN
          RAISE Standard.HID.HID_Error WITH "libLinux.Poll() failed, " &
            errno.strerror(error);
      END;
    END IF;

    libHIDRaw.Send(self.fd, msg'Address, msg'Length, count, error);

    IF error /= 0 THEN
      RAISE Standard.HID.HID_Error WITH "libHIDRaw.Send() failed, " &
        errno.strerror(error);
    END IF;
  END Send;

  -- Receive a message from a HID device

  PROCEDURE Receive(self : MessengerSubclass; msg : OUT Message64.Message) IS

    error : Integer;
    count : Integer;

  BEGIN
    IF self.timeout > 0 THEN
      DECLARE

        files   : libLinux.FilesType(0 .. 0)  := self.fd;
        events  : liblinux.EventsType(0 .. 0) := libLinux.POLLIN;
        results : liblinux.EventsType(0 .. 0) := 0;

      BEGIN
        libLinux.Poll(1, files, events, results, self.timeout, error);

        IF error /= 0 THEN
          RAISE Standard.HID.HID_Error WITH "libLinux.Poll() failed, " &
            errno.strerror(error);
      END;
    END IF;

    libHIDRaw.Receive(self.fd, msg'Address, msg'Length, count, error);

    IF error /= 0 THEN
      RAISE Standard.HID.HID_Error WITH "libHIDRaw.Receive() failed, " &
        errno.strerror(error);
    END IF;
  END Receive;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(self : MessengerSubclass) RETURN Integer IS

  BEGIN
    RETURN self.fd;
  END fd;

END HID.libsimpleio;
