-- SPI device services using libsimpleio

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

WITH Ada.Strings.Fixed;
WITH System;

WITH BeagleBone;
WITH ClickBoard.Shields;
WITH Device;
WITH errno;
WITH GPIO.libsimpleio;
WITH libGPIO;
WITH libSPI;

USE TYPE ClickBoard.Shields.Kind;
USE TYPE Device.Designator;

PACKAGE BODY SPI.libsimpleio IS

  FUNCTION Trim
   (Source : IN String;
    Side   : IN Ada.Strings.Trim_End :=
      Ada.Strings.Both) RETURN String RENAMES Ada.Strings.Fixed.Trim;

  -- SPI device object constructors

  FUNCTION Create
   (name     : String;
    mode     : Natural;
    wordsize : Natural;
    speed    : Natural;
    cspin    : Standard.Device.Designator := AUTOCHIPSELECT) RETURN SPI.Device IS

    Self : DeviceSubclass;

  BEGIN
    Self.Initialize(name, mode, wordsize, speed, cspin);
    RETURN NEW DeviceSubclass'(Self);
  END Create;

  FUNCTION Create
   (desg     : Standard.Device.Designator;
    mode     : Natural;
    wordsize : Natural;
    speed    : Natural;
    cspin    : Standard.Device.Designator := AUTOCHIPSELECT) RETURN SPI.Device IS

    Self : DeviceSubclass;

  BEGIN
    Self.Initialize(desg, mode, wordsize, speed, cspin);
    RETURN NEW DeviceSubclass'(Self);
  END Create;

  -- SPI device object initializers

  PROCEDURE Initialize
   (Self     : IN OUT DeviceSubclass;
    name     : String;
    mode     : Natural;
    wordsize : Natural;
    speed    : Natural;
    cspin    : Standard.Device.Designator := AUTOCHIPSELECT) IS

    fd       : Integer;
    error    : Integer;
    ss       : GPIO.libsimpleio.PinSubclass;
    fdcs     : Integer := libSPI.SPI_AUTO_CS;

  BEGIN
    Self.Destroy;

    libSPI.Open(name & ASCII.NUL, mode, wordsize, speed, fd, error);

    IF error /= 0 THEN
      RAISE SPI_Error WITH "libsimpleio.SPI.Open() failed, " &
        errno.strerror(error);
    END IF;

    IF cspin /= AUTOCHIPSELECT THEN
      ss.Initialize(cspin, GPIO.Output, True);
      fdcs := ss.fd;
    ELSIF ClickBoard.Shields.Detect = ClickBoard.Shields.BeagleBoneClick2 THEN
      -- Special hack for BeagleBone Click Shield (MIKROE-1596):
      -- Neither socket has the correct hardware slave select signal connected
      -- to the mikroBUS CS pin, so we have to force software slave select
      -- using the GPIO that is connected to CS instead.
      IF name = "/dev/spidev1.0" THEN
        ss.Initialize(BeagleBone.GPIO44, GPIO.Output, True);
        fdcs := ss.fd;
      ELSIF name = "/dev/spidev1.1" THEN
        ss.Initialize(BeagleBone.GPIO46, GPIO.Output, True);
        fdcs := ss.fd;
      END IF;
    END IF;

    Self := DeviceSubclass'(fd => fd, fdcs => fdcs);
  END Initialize;

  PROCEDURE Initialize
   (Self     : IN OUT DeviceSubclass;
    desg     : Standard.Device.Designator;
    mode     : Natural;
    wordsize : Natural;
    speed    : Natural;
    cspin    : Standard.Device.Designator := AUTOCHIPSELECT) IS

    name : CONSTANT String := "/dev/spidev" &
      Trim(Natural'Image(desg.chip)) & "." & Trim(Natural'Image(desg.chan));

  BEGIN
    Self.Destroy;
    Initialize(Self, name, mode, wordsize, speed, cspin);
  END Initialize;

  -- SPI device object destroyer

  PROCEDURE Destroy(Self : IN OUT DeviceSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    IF Self.fdcs /= libSPI.SPI_AUTO_CS THEN
      libGPIO.Close(Self.fdcs, error);
    END IF;

    libSPI.Close(Self.fd, error);

    Self := Destroyed;

    IF error /= 0 THEN
      RAISE SPI_Error WITH "libSPI.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

  -- Write only SPI bus cycle method

  PROCEDURE Write
   (Self   : DeviceSubclass;
    cmd    : Command;
    cmdlen : Natural) IS

    error  : Integer;

  BEGIN
    Self.CheckDestroyed;

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
    Self.CheckDestroyed;

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
    Self.CheckDestroyed;

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
    Self.CheckDestroyed;

    RETURN Self.fd;
  END fd;

  -- Check whether SPI device has been destroyed

  PROCEDURE CheckDestroyed(Self : DeviceSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE SPI_Error WITH "SPI device has been destroyed";
    END IF;
  END CheckDestroyed;

END SPI.libsimpleio;
