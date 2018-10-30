-- I2C bus controller services using libsimpleio

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

WITH System;

WITH errno;
WITH libI2C;
WITH libLinux;

PACKAGE BODY I2C.libsimpleio IS

  -- I2C bus controller object constructor

  FUNCTION Create(name : String) RETURN I2C.Bus IS

    fd    : Integer;
    error : Integer;

  BEGIN
    libI2C.Open(name & ASCII.NUL, fd, error);

    IF error /= 0 THEN
      RAISE I2C_Error WITH "libI2C.Open() failed, " & errno.strerror(error);
    END IF;

    RETURN NEW I2C.libsimpleio.BusSubclass'(fd => fd);
  END Create;

  -- Read only I2C bus cycle method

  PROCEDURE Read
   (Self    : I2C.libsimpleio.BusSubclass;
    addr    : I2C.Address;
    resp    : OUT I2C.Response;
    resplen : Natural) IS

    error   : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RAISE I2C_Error WITH "I2C bus has been destroyed";
    END IF;

    libI2C.Transaction(Self.fd, Integer(addr), System.Null_Address, 0, resp'Address, resplen, error);

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
    IF Self = Destroyed THEN
      RAISE I2C_Error WITH "I2C bus has been destroyed";
    END IF;

    libI2C.Transaction(Self.fd, Integer(addr), cmd'Address, cmdlen, System.Null_Address, 0, error);

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
    IF Self = Destroyed THEN
      RAISE I2C_Error WITH "I2C bus has been destroyed";
    END IF;

    IF delayus = 0 THEN
      libI2C.Transaction(Self.fd, Integer(addr), cmd'Address, cmdlen, resp'Address, resplen, error);

      IF error /= 0 THEN
        RAISE I2C_Error WITH "libI2C.Transaction() failed, " & errno.strerror(error);
      END IF;
    ELSE
      libI2C.Transaction(Self.fd, Integer(addr), cmd'Address, cmdlen, System.Null_Address, 0, error);

      IF error /= 0 THEN
        RAISE I2C_Error WITH "libI2C.Transaction() failed, " & errno.strerror(error);
      END IF;

      libLinux.usleep(Integer(delayus), error);

      IF error /= 0 THEN
        RAISE I2C_Error WITH "libLinux.usleep() failed, " & errno.strerror(error);
      END IF;

      libI2C.Transaction(Self.fd, Integer(addr), System.Null_Address, 0, resp'Address, resplen, error);

      IF error /= 0 THEN
        RAISE I2C_Error WITH "libI2C.Transaction() failed, " & errno.strerror(error);
      END IF;
    END IF;
  END Transaction;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : BusSubclass) RETURN Integer IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE I2C_Error WITH "I2C bus has been destroyed";
    END IF;

    RETURN Self.fd;
  END fd;

END I2C.libsimpleio;
