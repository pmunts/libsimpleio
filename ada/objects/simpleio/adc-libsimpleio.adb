-- A/D (Analog to Digital) input services using libsimpleio

-- Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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
WITH Voltage;

USE TYPE Voltage.Volts;

PACKAGE BODY ADC.libsimpleio IS

  -- ADC sample input object constructor

  FUNCTION Create
   (desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution) RETURN Analog.Input IS

    Self : InputSubclassSample;

  BEGIN
    Self.Initialize(desg, resolution);
    RETURN NEW InputSubclassSample'(Self);
  END Create;

  -- ADC sample input object initializer

  PROCEDURE Initialize
   (Self       : IN OUT InputSubclassSample;
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

    Self := InputSubclassSample'(fd, resolution);
  END Initialize;

  -- ADC sample input object destroyer

  PROCEDURE Destroy(Self : IN OUT InputSubclassSample) IS

    error : Integer;

  BEGIN
    IF Self = DestroyedSample THEN
      RETURN;
    END IF;

    libADC.Close(Self.fd, error);

    Self := DestroyedSample;

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

  -- ADC sample input read method

  FUNCTION Get
   (Self : IN OUT InputSubclassSample) RETURN Analog.Sample IS

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

  FUNCTION GetResolution(Self : IN OUT InputSubclassSample) RETURN Positive IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.resolution;
  END GetResolution;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : InputSubclassSample) RETURN Integer IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.fd;
  END fd;

  -- Check whether ADC sample input has been destroyed

  PROCEDURE CheckDestroyed(Self : InputSubclassSample) IS

  BEGIN
    IF Self = DestroyedSample THEN
      RAISE ADC_Error WITH "Analog input has been destroyed";
    END IF;
  END CheckDestroyed;

  -- ADC voltage input object constructor for a scaled ADC input
  -- in_voltage_scale or in_voltageY_scale must be functional!

  FUNCTION Create
   (desg       : Device.Designator;
    gain       : Voltage.Volts := 1.0) RETURN Voltage.Input IS

    Self : InputSubclassVolts;

  BEGIN
    Self.Initialize(desg, gain);
    RETURN NEW InputSubclassVolts'(Self);
  END Create;

  -- ADC voltage input object constructor for an unscaled ADC input

  FUNCTION Create
   (desg       : Device.Designator;
    resolution : Positive;
    reference  : Voltage.Volts;
    gain       : Voltage.Volts := 1.0) RETURN Voltage.Input IS

    Self : InputSubclassVolts;

  BEGIN
    Self.Initialize(desg, resolution, reference, gain);
    RETURN NEW InputSubclassVolts'(Self);
  END Create;

  -- ADC voltage input object initializer for a scaled ADC input
  -- in_voltage_scale or in_voltageY_scale must be functional!

  PROCEDURE Initialize
   (Self       : IN OUT InputSubclassVolts;
    desg       : Device.Designator;
    gain       : Voltage.Volts := 1.0) IS

    scale : Long_Float;
    fd    : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    IF gain = 0.0 THEN
      RAISE ADC_Error WITH "ERROR: gain cannot be zero";
    END IF;

    libADC.GetScale(desg.chip, desg.chan, scale, error);

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.GetScale() failed, " & errno.strerror(error);
    END IF;

    libADC.Open(desg.chip, desg.chan, fd, error);

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.Open() failed, " & errno.strerror(error);
    END IF;

    Self := InputSubclassVolts'(fd, Voltage.Volts(scale)/gain);
  END Initialize;

  -- ADC voltage input object initializer for an unscaled ADC input

  PROCEDURE Initialize
   (Self       : IN OUT InputSubclassVolts;
    desg       : Device.Designator;
    resolution : Positive;
    reference  : Voltage.Volts;
    gain       : Voltage.Volts := 1.0) IS

    fd    : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    IF reference = 0.0 THEN
      RAISE ADC_Error WITH "ERROR: reference voltage cannot be zero";
    END IF;

    IF gain = 0.0 THEN
      RAISE ADC_Error WITH "ERROR: gain cannot be zero";
    END IF;

    libADC.Open(desg.chip, desg.chan, fd, error);

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.Open() failed, " & errno.strerror(error);
    END IF;

    Self := InputSubclassVolts'(fd, reference/2.0**resolution/gain);
  END Initialize;

  -- ADC voltage input object destroyer

  PROCEDURE Destroy(Self : IN OUT InputSubclassVolts) IS

    error : Integer;

  BEGIN
    IF Self = DestroyedVolts THEN
      RETURN;
    END IF;

    libADC.Close(Self.fd, error);

    Self := DestroyedVolts;

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

  -- ADC voltage input read method

  FUNCTION Get(Self : IN OUT InputSubclassVolts) RETURN Voltage.Volts IS

    sample : Integer;
    error  : Integer;

  BEGIN
    Self.CheckDestroyed;

    libADC.Read(Self.fd, sample, error);

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.Read() failed, " & errno.strerror(error);
    END IF;

    RETURN Voltage.Volts(sample)*Self.scale;
  END Get;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : InputSubclassVolts) RETURN Integer IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.fd;
  END fd;

  -- Check whether ADC voltage input has been destroyed

  PROCEDURE CheckDestroyed(Self : InputSubclassVolts) IS

  BEGIN
    IF Self = DestroyedVolts THEN
      RAISE ADC_Error WITH "ADC input has been destroyed";
    END IF;
  END CheckDestroyed;

END ADC.libsimpleio;
