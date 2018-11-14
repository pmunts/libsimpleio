-- SPI device services using libsimpleio

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
WITH GPIO.libsimpleio;
WITH libGPIO;
WITH libSPI;

USE TYPE GPIO.libsimpleio.Designator;

PACKAGE BODY SPI.libsimpleio IS

  -- SPI device object constructor

  FUNCTION Create
   (name     : String;
    mode     : Natural;
    wordsize : Natural;
    speed    : Natural;
    cspin    : GPIO.libsimpleio.Designator := AUTOCHIPSELECT) RETURN SPI.Device IS

    fd       : Integer;
    fdcs     : Integer;
    error    : Integer;

  BEGIN
    libSPI.Open(name & ASCII.NUL, mode, wordsize, speed, fd, error);

    IF error /= 0 THEN
      RAISE SPI_Error WITH "libsimpleio.SPI.Open() failed, " &
        errno.strerror(error);
    END IF;

    IF cspin = AUTOCHIPSELECT THEN
      fdcs := libSPI.SPI_AUTO_CS;
    ELSE
      libGPIO.LineOpen(cspin.chip, cspin.chan, libGPIO.LINE_REQUEST_OUTPUT +
        libGPIO.LINE_REQUEST_ACTIVE_HIGH + libGPIO.LINE_REQUEST_PUSH_PULL,
        libGPIO.EVENT_REQUEST_NONE, 1, fdcs, error);

      IF error /= 0 THEN
        RAISE SPI_Error WITH "libGPIO.LineOpen() failed, " &
          errno.strerror(error);
      END IF;
    END IF;

    RETURN NEW DeviceSubclass'(fd => fd, fdcs => fdcs);
  END Create;

  -- Write only SPI bus cycle method

  PROCEDURE Write
   (Self   : DeviceSubclass;
    cmd    : Command;
    cmdlen : Natural) IS

    error  : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RAISE SPI_Error WITH "SPI device has been destroyed";
    END IF;

    libSPI.Transaction(Self.fd, Self.fdcs, cmd'Address, cmdlen, 0,
      System.Null_Address, 0, error);

    IF error /= 0 THEN
      RAISE SPI_Error WITH "libsimpleio.SPI.Transaction() failed, " &
        errno.strerror(error);
    END IF;
  END Write;

  -- Read only SPI bus cycle method

  PROCEDURE Read
   (Self    : DeviceSubclass;
    resp    : OUT Response;
    resplen : Natural) IS

    error   : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RAISE SPI_Error WITH "SPI device has been destroyed";
    END IF;

    libSPI.Transaction(Self.fd, Self.fdcs, System.Null_Address, 0, 0,
      resp'Address, resplen, error);

    IF error /= 0 THEN
      RAISE SPI_Error WITH "libsimpleio.SPI.Transaction() failed, " &
        errno.strerror(error);
    END IF;
  END Read;

  -- Combined Write/Read SPI bus cycle method

  PROCEDURE Transaction
   (Self    : DeviceSubclass;
    cmd     : Command;
    cmdlen  : Natural;
    resp    : OUT Response;
    resplen : Natural;
    delayus : MicroSeconds := 0) IS

    error   : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RAISE SPI_Error WITH "SPI device has been destroyed";
    END IF;

    IF delayus > 65535 THEN
      RAISE SPI_Error WITH "Invalid delay value";
    END IF;

    libSPI.Transaction(Self.fd, Self.fdcs, cmd'Address, cmdlen,
      Integer(delayus), resp'Address, resplen, error);

    IF error /= 0 THEN
      RAISE SPI_Error WITH "libsimpleio.SPI.Transaction() failed, " &
        errno.strerror(error);
    END IF;
  END Transaction;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : DeviceSubclass) RETURN Integer IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE SPI_Error WITH "SPI device has been destroyed";
    END IF;

    RETURN Self.fd;
  END fd;

END SPI.libsimpleio;
