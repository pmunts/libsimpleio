-- GPIO pin services using a user LED at /dev/userled

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

WITH Ada.Directories;
WITH Ada.Strings.Fixed;

WITH errno;
WITH libLinux;

PACKAGE BODY GPIO.UserLED IS

  filename  : CONSTANT String := "/dev/userled";
  state_on  : CONSTANT String := "1";
  state_off : CONSTANT String := "0";

  -- Linux requires us to rewind the file before reading it

  PROCEDURE lseek(fd : Integer; offset : Long_Integer; whence : Integer);
    PRAGMA Import(C, lseek);

  -- Determine whether the user LED is available

  FUNCTION Available RETURN Boolean IS

  BEGIN
    RETURN Ada.Directories.Exists(filename);
  END Available;

  -- Constructor

  FUNCTION Create(state : Boolean := False) RETURN GPIO.Pin IS

    fd    : Integer;
    error : Integer;
    p     : Pin;

  BEGIN
    libLinux.Open(filename & ASCII.NUL, fd, error);

    IF error /= 0 THEN
      RAISE GPIO_Error WITH "libLinux.Open() failed, " & errno.strerror(error);
    END IF;

    p := NEW PinSubclass'(myfd => fd);

    p.Put(state);

    RETURN GPIO.Pin(p);
  END Create;

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean IS

    buf   : String(1 .. 10);
    count : Integer;
    error : Integer;

  BEGIN
    lseek(Self.fd, 0, 0);

    libLinux.Read(Self.fd, buf'Address, buf'Length, count, error);

    IF error /= 0 THEN
      RAISE GPIO_Error WITH "libLinux.Read() failed, " & errno.strerror(error);
    END IF;

    RETURN Natural'Value(Ada.Strings.Fixed.Head(buf, count - 1)) /= 0;
  END Get;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean) IS

    count : Integer;
    error : Integer;

  BEGIN
    IF state THEN
      libLinux.Write(Self.myfd, state_on'Address, state_on'Length, count, error);
    ELSE
      libLinux.Write(Self.myfd, state_off'Address, state_off'Length, count, error);
    END IF;

    IF error /= 0 THEN
      RAISE GPIO_Error WITH "libLinux.Write() failed, " & errno.strerror(error);
    END IF;
  END Put;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : PinSubclass) RETURN Integer IS

  BEGIN
    RETURN Self.myfd;
  END fd;

END GPIO.UserLED;
