-- 64-byte message services using the raw HID services in libsimpleio
-- without heap

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
WITH libHIDRaw;
WITH libLinux;

PACKAGE BODY HID.libsimpleio.Static IS

  -- Constructor using raw HID device node name

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    name      : String;
    timeoutms : Integer := 1000) IS

    fd    : Integer;
    error : Integer;

  BEGIN
    Self := Destroyed;

    libHIDRaw.Open(name & ASCII.NUL, fd, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "libHIDRaw.Open() failed, " &
        errno.strerror(error);
    END IF;

    Self := MessengerSubclass'(fd, timeoutms);
  END Initialize;

  -- Constructor using HID vendor and product ID's

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    vid       : HID.Vendor  := HID.Munts.VID;
    pid       : HID.Product := HID.Munts.PID;
    timeoutms : Integer := 1000) IS

    fd    : Integer;
    error : Integer;

  BEGIN
    Self := Destroyed;

    libHIDRaw.OpenID(Integer(vid), Integer(pid), fd, error);

    IF error /= 0 THEN
      RAISE HID_Error WITH "libHIDRaw.OpenID() failed, " &
        errno.strerror(error);
    END IF;

    Self := MessengerSubclass'(fd, timeoutms);
  END Initialize;

  -- Constructor using open file descriptor

  PROCEDURE Initialize
   (Self      : IN OUT MessengerSubclass;
    fd        : Integer;
    timeoutms : Integer := 1000) IS

  BEGIN
    Self := Destroyed;

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

END HID.libsimpleio.Static;
