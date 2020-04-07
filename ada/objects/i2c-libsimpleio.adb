-- I2C bus controller services using libsimpleio

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
WITH System;

WITH errno;
WITH libI2C;
WITH libLinux;

PACKAGE BODY I2C.libsimpleio IS

  FUNCTION Trim
   (Source : IN String;
    Side   : IN Ada.Strings.Trim_End :=
      Ada.Strings.Both) RETURN String RENAMES Ada.Strings.Fixed.Trim;

  -- I2C bus controller object constructors

  FUNCTION Create(name : String) RETURN I2C.Bus IS

    Self : BusSubclass;

  BEGIN
    Self.Initialize(name);
    RETURN NEW BusSubclass'(Self);
  END Create;

  FUNCTION Create(desg : Device.Designator) RETURN I2C.Bus IS

    Self : BusSubclass;

  BEGIN
    Self.Initialize(desg);
    RETURN NEW BusSubclass'(Self);
  END Create;

  -- I2C bus controller object initializers

  PROCEDURE Initialize(Self : IN OUT BusSubclass; name : String) IS

    fd    : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    libI2C.Open(name & ASCII.NUL, fd, error);

    IF error /= 0 THEN
      RAISE I2C_Error WITH "libI2C.Open() failed, " & errno.strerror(error);
    END IF;

    Self := I2C.libsimpleio.BusSubclass'(fd => fd);
  END Initialize;

  PROCEDURE Initialize(Self : IN OUT BusSubclass; desg : Device.Designator) IS

  BEGIN
    Self.Destroy;

    IF desg.chip /= 0 THEN
      RAISE I2C_Error WITH "Invalid designator for I2C bus controller";
    END IF;

    Initialize(Self, "/dev/i2c-" & Trim(Natural'Image(desg.chan)));
  END Initialize;

  -- I2C bus controller object destroyer

  PROCEDURE Destroy(Self : IN OUT BusSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libI2C.Close(Self.fd, error);

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
