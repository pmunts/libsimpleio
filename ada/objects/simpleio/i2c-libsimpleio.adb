-- I2C bus controller services using libsimpleio

-- Copyright (C)2016-2023, Philip Munts.
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

-- I2C buses are almost unique among Linux I/O resources in that many
-- peripheral devices may share the same I2C bus.  For example, the Pi 3 Click
-- Shield routes the same I2C bus to both mikroBUS sockets.  If Click Boards
-- using I2C are plugged into both sockets, then the software drivers for
-- each board will open the I2C device node /dev/i2c-1.  If that happens, we
-- want both software drivers to receive the same file descriptor for the I2C
-- bus.  The following code achieves this requirement in a thread safe manor
-- by embedding a table of I2C bus file descriptors inside a protected object.

WITH Ada.Strings.Fixed;
WITH System;

WITH Device;
WITH errno;
WITH libI2C;
WITH libLinux;
WITH Reference_Counted_Table;

USE TYPE Device.Designator;

PACKAGE BODY I2C.libsimpleio IS

  FUNCTION Trim
   (Source : IN String;
    Side   : IN Ada.Strings.Trim_End :=
      Ada.Strings.Both) RETURN String RENAMES Ada.Strings.Fixed.Trim;

  PROCEDURE Create_fd
   (desg  : Device.Designator;
    fd    : OUT Integer;
    error : OUT Integer) IS

  BEGIN
    IF desg = Device.Unavailable OR desg.chip /= 0 THEN
      fd    := -1;
      error := errno.EINVAL;
      RETURN;
    END IF;

    libI2C.Open("/dev/i2c-" & Trim(Natural'Image(desg.chan)) & ASCII.NUL, fd, error);
  END Create_fd;

  PROCEDURE Destroy_fd(fd : integer; error : OUT Integer) IS

  BEGIN
    IF fd < 0 THEN
      error := errno.EINVAL;
      RETURN;
    END IF;

    libI2C.Close(fd, error);
  END Destroy_fd;

  PACKAGE fdtable IS NEW Reference_Counted_Table
   (Element => Integer,
    Key             => Device.Designator,
    Null_Element    => -1,
    Null_Key        => Device.Unavailable,
    Max_Elements    => 100,
    Create_Element  => Create_fd,
    Destroy_Element => Destroy_fd);

  -- I2C bus controller object constructor

  FUNCTION Create(desg : Device.Designator) RETURN I2C.Bus IS

    Self : BusSubclass;

  BEGIN
    Self.Initialize(desg);
    RETURN NEW BusSubclass'(Self);
  END Create;

  -- I2C bus controller object initializer

  PROCEDURE Initialize(Self : IN OUT BusSubclass; desg : Device.Designator) IS

    error : Integer;

  BEGIN
    Self.Destroy;

    IF desg = Device.Unavailable OR desg.chip /= 0 THEN
      RAISE I2C_Error WITH "Invalid designator for I2C bus controller";
    END IF;

    fdtable.Create(desg, Self.fd, error);

    IF error /= 0 THEN
      Self.Destroy;
      RAISE I2C_Error WITH "libI2C.Open() failed, " & errno.strerror(error);
    END IF;
  END Initialize;

  -- I2C bus controller object destroyer

  PROCEDURE Destroy(Self : IN OUT BusSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    fdtable.Destroy(Self.fd, error);

    Self := Destroyed;

    IF error /= 0 THEN
      RAISE I2C_Error WITH "libI2C.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

  -- Read only I2C bus cycle method

  PROCEDURE Read
   (Self    : I2C.libsimpleio.BusSubclass;
    addr    : I2C.Address;
    resp    : OUT I2C.Response;
    resplen : Natural) IS

    error   : Integer;

  BEGIN
    Self.CheckDestroyed;

    libI2C.Transaction(Self.fd, Integer(addr), System.Null_Address, 0,
      resp'Address, resplen, error);

    IF error /= 0 THEN
      RAISE I2C_Error WITH "libI2C.Transaction() failed, " & errno.strerror(error);
    END IF;
  END Read;

  -- Write only I2C bus cycle method

  PROCEDURE Write
   (Self    : I2C.libsimpleio.BusSubclass;
    addr    : I2C.Address;
    cmd     : I2C.Command;
    cmdlen  : Natural) IS

    error   : Integer;

  BEGIN
    Self.CheckDestroyed;

    libI2C.Transaction(Self.fd, Integer(addr), cmd'Address, cmdlen,
      System.Null_Address, 0, error);

    IF error /= 0 THEN
      RAISE I2C_Error WITH "libI2C.Transaction() failed, " & errno.strerror(error);
    END IF;
  END Write;

  -- Combined Write/Read I2C bus cycle method

  PROCEDURE Transaction
   (Self    : I2C.libsimpleio.BusSubclass;
    addr    : I2C.Address;
    cmd     : I2C.Command;
    cmdlen  : Natural;
    resp    : OUT I2C.Response;
    resplen : Natural;
    delayus : MicroSeconds := 0) IS

    error   : Integer;

  BEGIN
    Self.CheckDestroyed;

    IF delayus = 0 THEN
      libI2C.Transaction(Self.fd, Integer(addr), cmd'Address, cmdlen,
        resp'Address, resplen, error);

      IF error /= 0 THEN
        RAISE I2C_Error WITH "libI2C.Transaction() failed, " & errno.strerror(error);
      END IF;
    ELSE
      libI2C.Transaction(Self.fd, Integer(addr), cmd'Address, cmdlen,
        System.Null_Address, 0, error);

      IF error /= 0 THEN
        RAISE I2C_Error WITH "libI2C.Transaction() failed, " & errno.strerror(error);
      END IF;

      libLinux.usleep(Integer(delayus), error);

      IF error /= 0 THEN
        RAISE I2C_Error WITH "libLinux.usleep() failed, " & errno.strerror(error);
      END IF;

      libI2C.Transaction(Self.fd, Integer(addr), System.Null_Address, 0,
        resp'Address, resplen, error);

      IF error /= 0 THEN
        RAISE I2C_Error WITH "libI2C.Transaction() failed, " & errno.strerror(error);
      END IF;
    END IF;
  END Transaction;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : BusSubclass) RETURN Integer IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.fd;
  END fd;

  -- Check whether I2C bus has been destroyed

  PROCEDURE CheckDestroyed(Self : BusSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE I2C_Error WITH "I2C bus has been destroyed";
    END IF;
  END CheckDestroyed;

END I2C.libsimpleio;
