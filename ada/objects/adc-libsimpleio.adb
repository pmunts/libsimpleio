-- A/D (Analog to Digital) input services using libsimpleio

-- Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.
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
WITH libADC;

PACKAGE BODY ADC.libsimpleio IS

  -- ADC input object constructor

  FUNCTION Create
   (desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution) RETURN Analog.Input IS

    Self : InputSubclass;

  BEGIN
    Self.Initialize(desg, resolution);
    RETURN NEW InputSubclass'(Self);
  END Create;

  -- ADC input object initializer

  PROCEDURE Initialize
   (Self       : IN OUT InputSubclass;
    desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution) IS

    fd    : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    libADC.Open(desg.chip, desg.chan, fd, error);

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.Open() failed, " & errno.strerror(error);
    END IF;

    Self := InputSubclass'(fd, resolution);
  END Initialize;

  -- ADC input object destroyer

  PROCEDURE Destroy(Self : IN OUT InputSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    libADC.Close(Self.fd, error);

    Self := Destroyed;

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

  -- ADC input read method

  FUNCTION Get
   (Self : IN OUT InputSubclass) RETURN Analog.Sample IS

    sample : Integer;
    error  : Integer;

  BEGIN
    Self.CheckDestroyed;

    libADC.Read(Self.fd, sample, error);

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.Read() failed, " & errno.strerror(error);
    END IF;

    RETURN Analog.Sample(sample);
  END Get;

  -- Retrieve the ADC resolution

  FUNCTION GetResolution(Self : IN OUT InputSubclass) RETURN Positive IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.resolution;
  END GetResolution;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : InputSubclass) RETURN Integer IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.fd;
  END fd;

  -- Check whether ADC input has been destroyed

  PROCEDURE CheckDestroyed(Self : InputSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE ADC_Error WITH "Analog input has been destroyed";
    END IF;
  END CheckDestroyed;

END ADC.libsimpleio;
