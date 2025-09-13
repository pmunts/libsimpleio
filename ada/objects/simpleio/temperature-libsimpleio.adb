-- Linux Industrial I/O Temperature Sensor Services

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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
WITH libTEMP;

PACKAGE BODY Temperature.libsimpleio IS

  -- Temperature sensor object constructor

  FUNCTION Create(desg : Device.Designator) RETURN Input IS

    Self : InputSubclass;

  BEGIN
    Self.Initialize(desg);
    RETURN NEW InputSubclass'(Self);
  END Create;

  -- Temperature sensor object instance initializer

  PROCEDURE Initialize(Self : IN OUT InputSubclass; desg : Device.Designator) IS

    scale : Long_Float;
    fd    : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    libTEMP.GetScale(desg.chip, desg.chan, scale, error);

    IF error /= 0 THEN
      RAISE Temperature_Error WITH "libTEMP.GetScale() failed, " &
        errno.strerror(error);
    END IF;

    libTEMP.Open(desg.chip, desg.chan, fd, error);

    IF error /= 0 THEN
      RAISE Temperature_Error WITH "libTEMP.Open() failed, " &
        errno.strerror(error);
    END IF;

    Self := InputSubclass'(fd, Temperature.Celsius(scale)*1000.0);
  END Initialize;

  -- Temperature sensor object destroyer

  PROCEDURE Destroy(Self : IN OUT InputSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libTEMP.Close(Self.fd, error);

    Self := Destroyed;

    IF error /= 0 THEN
      RAISE Temperature_Error WITH "libTEMP.Close() failed, " &
        errno.strerror(error);
    END IF;
  END Destroy;

  -- Temperature sensor read method

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Celsius IS

    sample : Integer;
    error  : Integer;

  BEGIN
    Self.CheckDestroyed;

    libTEMP.Read(Self.fd, sample, error);

    IF error /= 0 THEN
      RAISE Temperature_Error WITH "libTEMP.Read() failed, " &
        errno.strerror(error);
    END IF;

    RETURN Temperature.Celsius(sample)*Self.scale;
  END Get;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : InputSubclass) RETURN Integer IS 

  BEGIN
    RETURN Self.fd;
  END fd;

  -- Check whether temperature sensor has been destroyed

  PROCEDURE CheckDestroyed(Self : InputSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE Temperature_Error WITH "Temperature sensor has been destroyed";
    END IF;
  END CheckDestroyed;

END Temperature.libsimpleio;
