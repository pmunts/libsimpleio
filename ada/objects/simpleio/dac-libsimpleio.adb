-- D/A (Digital to Analog) output services

-- Copyright (C)2018-2025, Philip Munts dba Munts Technologies.
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

WITH Ada.Environment_Variables;
WITH Ada.Strings.Fixed;

WITH Analog;
WITH errno;
WITH libDAC;
WITH Voltage;

USE TYPE Analog.Sample;
USE TYPE Voltage.Volts;

PACKAGE BODY DAC.libsimpleio IS

  -- Get IIO device gain from environment variable

  FUNCTION IIOgain(desg : Device.Designator) RETURN Voltage.Volts IS

    name : CONSTANT String := "IIOGAIN" &
      "_" & Ada.Strings.Fixed.Trim(desg.chip'Image, Ada.Strings.Left) &
      "_" & Ada.Strings.Fixed.Trim(desg.channel'Image, Ada.Strings.Left);

  BEGIN
    RETURN Voltage.Volts'Value(Ada.Environment_Variables.Value(name,
      UnityGain'Image));
  END IIOgain;

  -- DAC sampled data output object constructor

  FUNCTION Create
   (desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution) RETURN Analog.Output IS

    Self : OutputSubclassSample;

  BEGIN
    Self.Initialize(desg, resolution);
    RETURN NEW OutputSubclassSample'(Self);
  END Create;

  -- DAC sampled data output object initializer

  PROCEDURE Initialize
   (Self       : IN OUT OutputSubclassSample;
    desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution) IS

    fd    : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    libDAC.Open(desg.chip, desg.chan, fd, error);

    IF error /= 0 THEN
      RAISE DAC_Error WITH "libDAC.Open() failed, " & errno.strerror(error);
    END IF;

    Self := OutputSubclassSample'(fd, resolution, 2**resolution - 1);
  END Initialize;

  -- DAC sampled data output object destroyer

  PROCEDURE Destroy(Self : IN OUT OutputSubclassSample) IS

    error : Integer;

  BEGIN
    IF Self = DestroyedSample THEN
      RETURN;
    END IF;

    libDAC.Close(Self.fd, error);

    Self := DestroyedSample;

    IF error /= 0 THEN
      RAISE DAC_Error WITH "libDAC.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

  -- DAC sampled data output write method

  PROCEDURE Put
   (Self       : IN OUT OutputSubclassSample;
    sample     : Analog.Sample) IS

    error : Integer;

  BEGIN
    Self.CheckDestroyed;

    IF sample > Self.maxsample THEN
      RAISE DAC.DAC_Error WITH "Sample parameter is out of range";
    END IF;

    libDAC.Write(Self.fd, Integer(Sample), error);

    IF error /= 0 THEN
      RAISE DAC_Error WITH "libDAC.Write() failed, " & errno.strerror(error);
    END IF;
  END Put;

  -- Retrieve the DAC resolution

  FUNCTION GetResolution(Self : IN OUT OutputSubclassSample) RETURN Positive IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.resolution;
  END GetResolution;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : OutputSubclassSample) RETURN Integer IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.fd;
  END fd;

  -- Check whether DAC sampled data output has been destroyed

  PROCEDURE CheckDestroyed(Self : OutputSubclassSample) IS

  BEGIN
    IF Self = DestroyedSample THEN
      RAISE DAC_Error WITH "Analog output has been destroyed";
    END IF;
  END CheckDestroyed;

  -- DAC voltage output object constructor for an unscaled DAC voltage output

  FUNCTION Create
   (desg       : Device.Designator;
    resolution : Positive;
    reference  : Voltage.Volts;
    gain       : Voltage.Volts := UnityGain) RETURN Voltage.Output IS

    Self : OutputSubclassVolts;

  BEGIN
    Self.Initialize(desg, resolution, reference, gain);
    RETURN NEW OutputSubclassVolts'(Self);
  END Create;

  -- DAC voltage output object constructor for a scaled DAC voltage output
  -- out_voltage_scale or out_voltageY_scale must be functional!

  FUNCTION Create
   (desg       : Device.Designator;
    gain       : Voltage.Volts := UnityGain) RETURN Voltage.Output IS

    Self : OutputSubclassVolts;

  BEGIN
    Self.Initialize(desg, gain);
    RETURN NEW OutputSubclassVolts'(Self);
  END Create;

  -- DAC voltage output object initializer for an unscaled DAC voltage output

  PROCEDURE Initialize
   (Self       : IN OUT OutputSubclassVolts;
    desg       : Device.Designator;
    resolution : Positive;
    reference  : Voltage.Volts;
    gain       : Voltage.Volts := UnityGain) IS

    fd    : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    IF reference = 0.0 THEN
      RAISE DAC_Error WITH "ERROR: reference voltage cannot be zero";
    END IF;

    IF gain = 0.0 THEN
      RAISE DAC_Error WITH "ERROR: gain cannot be zero";
    END IF;

    libDAC.Open(desg.chip, desg.chan, fd, error);

    IF error /= 0 THEN
      RAISE DAC_Error WITH "libDAC.Open() failed, " & errno.strerror(error);
    END IF;

    IF gain = UnityGain THEN
      Self := OutputSubclassVolts'(fd, reference/2.0**resolution/IIOgain);
    ELSE
      Self := OutputSubclassVolts'(fd, reference/2.0**resolution/gain);
    END IF;
  END Initialize;

  -- DAC voltage output object initializer for a scaled DAC voltage output
  -- out_voltage_scale or out_voltageY_scale must be functional!

  PROCEDURE Initialize
   (Self       : IN OUT OutputSubclassVolts;
    desg       : Device.Designator;
    gain       : Voltage.Volts := UnityGain) IS

    scale : Long_Float;
    fd    : Integer;
    error : Integer;

  BEGIN
    Self.Destroy;

    IF gain = 0.0 THEN
      RAISE DAC_Error WITH "ERROR: gain cannot be zero";
    END IF;

    libDAC.GetScale(desg.chip, desg.chan, scale, error);

    IF error /= 0 THEN
      RAISE DAC_Error WITH "libDAC.GetScale() failed, " & errno.strerror(error);
    END IF;

    libDAC.Open(desg.chip, desg.chan, fd, error);

    IF error /= 0 THEN
      RAISE DAC_Error WITH "libDAC.Open() failed, " & errno.strerror(error);
    END IF;

    IF gain = UnityGain THEN
      Self := OutputSubclassVolts'(fd, Voltage.Volts(scale)/IIOgain);
    ELSE
      Self := OutputSubclassVolts'(fd, Voltage.Volts(scale)/gain);
    END IF;
  END Initialize;

  -- DAC voltage output object destroyer

  PROCEDURE Destroy(Self : IN OUT OutputSubclassVolts) IS

    error : Integer;

  BEGIN
    IF Self = DestroyedVolts THEN
      RETURN;
    END IF;

    libDAC.Close(Self.fd, error);

    Self := DestroyedVolts;

    IF error /= 0 THEN
      RAISE DAC_Error WITH "libDAC.Close() failed, " & errno.strerror(error);
    END IF;
  END Destroy;

  -- DAC voltage output write method

  PROCEDURE Put
   (Self       : IN OUT OutputSubclassVolts;
    vout       : Voltage.Volts) IS

    error : Integer;

  BEGIN
    libDAC.Write(Self.fd, Integer(vout/Self.scale), error);

    IF error /= 0 THEN
      RAISE DAC_Error WITH "libDAC.Write() failed, " & errno.strerror(error);
    END IF;
  END Put;


  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : OutputSubclassVolts) RETURN Integer IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.fd;
  END fd;

  -- Check whether DAC voltage output has been destroyed

  PROCEDURE CheckDestroyed(Self : OutputSubclassVolts) IS

  BEGIN
    IF Self = DestroyedVolts THEN
      RAISE DAC_Error WITH "DAC voltage output has been destroyed";
    END IF;
  END CheckDestroyed;END DAC.libsimpleio;
