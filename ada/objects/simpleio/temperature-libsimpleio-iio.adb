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

WITH Ada.Strings.Fixed;
WITH Ada.Strings.Maps.Constants;

WITH errno;
WITH libIIO;

PACKAGE BODY Temperature.libsimpleio.IIO IS

  -- Temperature sensor object constructor

  FUNCTION Create(desg : Device.Designator) RETURN Input IS

    Self : InputSubclass;

  BEGIN
    Self.Initialize(desg);
    RETURN NEW InputSubclass'(Self);
  END Create;

  -- Temperature sensor object instance initializer

  PROCEDURE Initialize(Self : IN OUT InputSubclass; desg : Device.Designator) IS

    fd_offset : Integer;
    fd_raw    : Integer;
    fd_scale  : Integer;
    name      : String(1 .. 256);
    fudge     : Long_Float;
    error     : Integer;

  BEGIN
    Self.Destroy;

    libIIO.Open(desg.chip, desg.chan, "in_temp" & ASCII.Nul,
      "offset" & ASCII.Nul, libIIO.O_RDONLY, fd_offset, error);

    IF error /= 0 THEN
      fd_offset := -1;
    END IF;

    libIIO.Open(desg.chip, desg.chan, "in_temp" & ASCII.Nul,
      "raw" & ASCII.Nul, libIIO.O_RDONLY, fd_raw, error);

    IF error /= 0 THEN
      Self.Destroy;

      RAISE Temperature_Error WITH "libIIO.Open() failed, " &
        errno.strerror(error);
    END IF;

    libIIO.Open(desg.chip, desg.chan, "in_temp" & ASCII.Nul,
      "scale" & ASCII.Nul, libIIO.O_RDONLY, fd_scale, error);

    IF error /= 0 THEN
      Self.Destroy;

      RAISE Temperature_Error WITH "libIIO.Open() failed, " &
        errno.strerror(error);
    END IF;

    libIIO.GetName(desg.chip, name, name'Length, error);

    IF error /= 0 THEN
      Self.Destroy;

      RAISE Temperature_Error WITH "libIIO.GetName() failed, " &
        errno.strerror(error);
    END IF;

    -- Compute scale fudge factor for certain devices

    DECLARE
      sname : String := Ada.Strings.Fixed.Trim(name,
        Ada.Strings.Maps.Constants.Control_set,
        Ada.Strings.Maps.Constants.Control_set);
    BEGIN
      IF sname = "mpl3115" THEN
        fudge := 1000.0;
      ELSE
        fudge := 1.0;
      END IF;
    END;

    Self := InputSubclass'(fd_offset, fd_raw, fd_scale, fudge);
  END Initialize;

  -- Temperature sensor object destroyer

  PROCEDURE Destroy(Self : IN OUT InputSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    IF Self.fd_offset >= 0 THEN
      libIIO.Close(Self.fd_offset, error);
    END IF;

    IF Self.fd_raw >= 0 THEN
      libIIO.Close(Self.fd_raw, error);
    END IF;

    IF Self.fd_scale >= 0 THEN
      libIIO.Close(Self.fd_scale, error);
    END IF;

    Self := Destroyed;
  END Destroy;

  -- Temperature sensor read method

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Celsius IS

    offset : Integer;
    raw    : Integer;
    scale  : Long_Float;
    error  : Integer;

  BEGIN
    Self.CheckDestroyed;

    IF Self.fd_offset >= 0 THEN
      libIIO.GetInt(Self.fd_offset, offset, error);

      IF error /= 0 THEN
        RAISE Temperature_Error WITH "libIIO.GetInt() failed, " &
          errno.strerror(error);
      END IF;
    END IF;

    libIIO.GetInt(Self.fd_raw, raw, error);

    IF error /= 0 THEN
      RAISE Temperature_Error WITH "libIIO.GetInt() failed, " &
        errno.strerror(error);
    END IF;

    libIIO.GetDouble(Self.fd_scale, scale, error);

    IF error /= 0 THEN
      RAISE Temperature_Error WITH "libIIO.GetDouble() failed, " &
        errno.strerror(error);
    END IF;

    RETURN Temperature.Celsius(Long_Float(raw + offset)*scale/1000.0*Self.fudge);
  END Get;

  -- Check whether temperature sensor has been destroyed

  PROCEDURE CheckDestroyed(Self : InputSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE Temperature_Error WITH "Temperature sensor has been destroyed";
    END IF;
  END CheckDestroyed;

END Temperature.libsimpleio.IIO;
