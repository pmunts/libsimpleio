-- GPIO pin services using a user LED at /dev/userled

-- Copyright (C)2018-2020, Philip Munts, President, Munts AM Corp.
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
WITH Logging.libsimpleio;

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

    Self : PinSubclass;

  BEGIN
    Self.Initialize(state);
    RETURN NEW PinSubclass'(Self);
  END Create;

  -- Initializer

  PROCEDURE Initialize(Self : IN OUT PinSubclass; state : Boolean := False) IS

    fd    : Integer;
    count : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    libLinux.Open(filename & ASCII.NUL, fd, error);

    IF error /= 0 THEN
      Logging.libsimpleio.Error("libLinux.Open() failed", error);
      RAISE GPIO_Error WITH "libLinux.Open() failed, " & errno.strerror(error);
    END IF;

    IF state THEN
      libLinux.Write(fd, state_on'Address, state_on'Length, count, error);
    ELSE
      libLinux.Write(fd, state_off'Address, state_off'Length, count, error);
    END IF;

    IF error /= 0 THEN
      Logging.libsimpleio.Error("libLinux.Write() failed", error);
      RAISE GPIO_Error WITH "libLinux.Write() failed, " & errno.strerror(error);
    END IF;

    Self := PinSubclass'(myfd => fd);
  END Initialize;

  -- Destroyer

  PROCEDURE Destroy(Self : IN OUT PinSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libLinux.Close(Self.myfd, error);

    Self := Destroyed;

    IF error /= 0 THEN
      Logging.libsimpleio.Error("libLinux.Close() failed", error);
      RAISE GPIO_Error WITH "libLinux.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean IS

    buf   : String(1 .. 10);
    count : Integer;
    error : Integer;

  BEGIN
    Self.CheckDestroyed;

    lseek(Self.fd, 0, 0);

    libLinux.Read(Self.fd, buf'Address, buf'Length, count, error);

    IF error /= 0 THEN
      Logging.libsimpleio.Error("libLinux.Read() failed", error);
      RAISE GPIO_Error WITH "libLinux.Read() failed, " & errno.strerror(error);
    END IF;

    RETURN Natural'Value(Ada.Strings.Fixed.Head(buf, count - 1)) /= 0;
  END Get;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean) IS

    count : Integer;
    error : Integer;

  BEGIN
    Self.CheckDestroyed;

    IF state THEN
      libLinux.Write(Self.myfd, state_on'Address, state_on'Length, count, error);
    ELSE
      libLinux.Write(Self.myfd, state_off'Address, state_off'Length, count, error);
    END IF;

    IF error /= 0 THEN
      Logging.libsimpleio.Error("libLinux.Write() failed", error);
      RAISE GPIO_Error WITH "libLinux.Write() failed, " & errno.strerror(error);
    END IF;
  END Put;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : PinSubclass) RETURN Integer IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.myfd;
  END fd;

  -- Check whether GPIO pin object has been destroyed

  PROCEDURE CheckDestroyed(Self : PinSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      Logging.libsimpleio.Error("GPIO pin had been destroyed");
      RAISE GPIO_Error WITH "GPIO pin has been destroyed";
    END IF;
  END CheckDestroyed;

END GPIO.UserLED;
