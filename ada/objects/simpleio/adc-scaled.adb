-- Scaled ADC (Analog to Digital Converter) voltage input services

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

-- NOTE: This package requires the scale factor for the underlying Industrial
-- I/O ADC input device to be configured by supplying a voltage regulator
-- device instance to the vref-supply device tree property e.g. adding
-- "vref-supply = <&vdd_3v3_reg>;" to a device tree overlay.

WITH errno;
WITH libADC;
WITH Voltage;

USE TYPE Voltage.Volts;

PACKAGE BODY ADC.Scaled IS

  -- Voltage input object constructor

  FUNCTION Create(desg : Device.Designator) RETURN Voltage.Input IS

    Self : InputSubclass;

  BEGIN
    Self.Initialize(desg);
    RETURN NEW InputSubclass'(Self);
  END Create;

  -- Voltage input object initializer

  PROCEDURE Initialize(Self : IN OUT InputSubclass; desg : Device.Designator) IS

    scale : Long_Float;
    error : Integer;
    fd    : Integer;

  BEGIN
    Self.Destroy;

    libADC.GetScale(desg.chip, scale, error);

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.GetScale() failed, " & errno.strerror(error);
    END IF;

    libADC.Open(desg.chip, desg.chan, fd, error);

    IF error /= 0 THEN
      RAISE ADC_Error WITH "libADC.Open() failed, " & errno.strerror(error);
    END IF;

    Self := InputSubclass'(fd, Voltage.Volts(scale/1000.0));
  END Initialize;

  -- Voltage input object destroyer

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

  -- Voltage input read method

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Voltage.Volts IS

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

  PROCEDURE CheckDestroyed(Self : InputSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE ADC_Error WITH "ADC input has been destroyed";
    END IF;
  END CheckDestroyed;

END ADC.Scaled;
