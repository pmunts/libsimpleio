-- A/D (Analog to Digital) input services using libsimpleio

-- Copyright (C)2017-2025, Philip Munts dba Munts Technologies.
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

WITH Analog;
WITH Device;

PACKAGE ADC.libsimpleio IS

  -- Type definitions

  TYPE InputSubclassSample IS NEW Analog.InputInterface WITH PRIVATE;

  DestroyedSample : CONSTANT InputSubclassSample;

  -- ADC sample input object constructor

  FUNCTION Create
   (desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution) RETURN Analog.Input;

  -- ADC sample input object initializer

  PROCEDURE Initialize
   (Self       : IN OUT InputSubclassSample;
    desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution);

  -- ADC sample input object destroyer

  PROCEDURE Destroy(Self : IN OUT InputSubclassSample);

  -- ADC sample input read method

  FUNCTION Get(Self : IN OUT InputSubclassSample) RETURN Analog.Sample;

  -- Retrieve the ADC resolution

  FUNCTION GetResolution(Self : IN OUT InputSubclassSample) RETURN Positive;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : InputSubclassSample) RETURN Integer;

  -- Type definitions

  TYPE InputSubclassVolts IS NEW Voltage.InputInterface WITH PRIVATE;

  DestroyedVolts : CONSTANT InputSubclassVolts;

  -- ADC voltage input object constructor for a scaled ADC input
  -- in_voltage_scale or in_voltageY_scale must be functional!

  FUNCTION Create
   (desg       : Device.Designator;
    gain       : Voltage.Volts := 1.0) RETURN Voltage.Input;

  -- ADC voltage input object constructor for an unscaled ADC input

  FUNCTION Create
   (desg       : Device.Designator;
    resolution : Positive;
    reference  : Voltage.Volts;
    gain       : Voltage.Volts := 1.0) RETURN Voltage.Input;

  -- ADC voltage input object initializer for a scaled ADC input
  -- in_voltage_scale or in_voltageY_scale must be functional!

  PROCEDURE Initialize
   (Self       : IN OUT InputSubclassVolts;
    desg       : Device.Designator;
    gain       : Voltage.Volts := 1.0);

  -- ADC voltage input object initializer for an unscaled ADC input

  PROCEDURE Initialize
   (Self       : IN OUT InputSubclassVolts;
    desg       : Device.Designator;
    resolution : Positive;
    reference  : Voltage.Volts;
    gain       : Voltage.Volts := 1.0);

  -- ADC voltage input object destroyer

  PROCEDURE Destroy(Self : IN OUT InputSubclassVolts);

  -- ADC voltage input read method

  FUNCTION Get(Self : IN OUT InputSubclassVolts) RETURN Voltage.Volts;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : InputSubclassVolts) RETURN Integer;

PRIVATE

  -- Check whether ADC sample input has been destroyed

  PROCEDURE CheckDestroyed(Self : InputSubclassSample);

  TYPE InputSubclassSample IS NEW Analog.InputInterface WITH RECORD
    fd         : Integer  := -1;
    resolution : Natural  := 0;
  END RECORD;

  DestroyedSample : CONSTANT InputSubclassSample := InputSubclassSample'(-1, 0);

  -- Check whether ADC voltage input has been destroyed

  PROCEDURE CheckDestroyed(Self : InputSubclassVolts);

  TYPE InputSubclassVolts IS NEW Voltage.InputInterface WITH RECORD
    fd    : Integer       := -1;
    scale : Voltage.Volts := 0.0;
  END RECORD;

  DestroyedVolts : CONSTANT InputSubclassVolts := InputSubclassVolts'(-1, 0.0);

END ADC.libsimpleio;
