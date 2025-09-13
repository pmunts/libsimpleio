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

-- The default gain value UnityGain supplied to the voltage output
-- constructors and initializers below, for IIO channel (X, Y) e.g.
-- iio:deviceX channel Y, can be overridden by environment variable
-- IIOGAIN_X_Y. Gain values other than UnityGain will NOT be overridden.

WITH Analog;
WITH Device;

PACKAGE DAC.libsimpleio IS

  -- Type definitions

  TYPE OutputSubclassSample IS NEW Analog.OutputInterface WITH PRIVATE;

  DestroyedSample : CONSTANT OutputSubclassSample;

  -- DAC sample output object constructor

  FUNCTION Create
   (desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution) RETURN Analog.Output;

  -- DAC sample output object initializer

  PROCEDURE Initialize
   (Self       : IN OUT OutputSubclassSample;
    desg       : Device.Designator;
    resolution : Positive := Analog.MaxResolution);

  -- DAC sample output object destroyer

  PROCEDURE Destroy(Self : IN OUT OutputSubclassSample);

  -- DAC sample output write method

  PROCEDURE Put
   (Self       : IN OUT OutputSubclassSample;
    sample     : Analog.Sample);

  -- Retrieve the DAC resolution

  FUNCTION GetResolution(Self : IN OUT OutputSubclassSample) RETURN Positive;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : OutputSubclassSample) RETURN Integer;

  -- Type definitions

  TYPE OutputSubclassVolts IS NEW Voltage.OutputInterface WITH PRIVATE;

  DestroyedVolts : CONSTANT OutputSubclassVolts;

  -- DAC voltage output object constructor for an unscaled DAC voltage output

  FUNCTION Create
   (desg       : Device.Designator;
    resolution : Positive;
    reference  : Voltage.Volts;
    gain       : Voltage.Volts := UnityGain) RETURN Voltage.Output;

  -- DAC voltage output object constructor for a scaled DAC voltage output
  -- out_voltage_scale or out_voltageY_scale must be functional!

  FUNCTION Create
   (desg       : Device.Designator;
    gain       : Voltage.Volts := UnityGain) RETURN Voltage.Output;

  -- DAC voltage output object initializer for a scaled DAC voltage output
  -- out_voltage_scale or out_voltageY_scale must be functional!

  PROCEDURE Initialize
   (Self       : IN OUT OutputSubclassVolts;
    desg       : Device.Designator;
    gain       : Voltage.Volts := UnityGain);

  -- DAC voltage output object initializer for an unscaled DAC voltage output

  PROCEDURE Initialize
   (Self       : IN OUT OutputSubclassVolts;
    desg       : Device.Designator;
    resolution : Positive;
    reference  : Voltage.Volts;
    gain       : Voltage.Volts := UnityGain);

  -- DAC voltage output object destroyer

  PROCEDURE Destroy(Self : IN OUT OutputSubclassVolts);

  -- DAC voltage output write method

  PROCEDURE Put
   (Self       : IN OUT OutputSubclassVolts;
    vout       : Voltage.Volts);

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : OutputSubclassVolts) RETURN Integer;

PRIVATE

  -- Check whether DAC output has been destroyed

  PROCEDURE CheckDestroyed(Self : OutputSubclassSample);

  TYPE OutputSubclassSample IS NEW Analog.OutputInterface WITH RECORD
    fd         : Integer       := -1;
    resolution : Natural       := 0;
    maxsample  : Analog.Sample := 0;
  END RECORD;

  DestroyedSample : CONSTANT OutputSubclassSample := OutputSubclassSample'(-1, 0, 0);

  -- Check whether DAC voltage output has been destroyed

  PROCEDURE CheckDestroyed(Self : OutputSubclassVolts);

  TYPE OutputSubclassVolts IS NEW Voltage.OutputInterface WITH RECORD
    fd    : Integer       := -1;
    scale : Voltage.Volts := 0.0;
  END RECORD;

  DestroyedVolts : CONSTANT OutputSubclassVolts := OutputSubclassVolts'(-1, 0.0);

END DAC.libsimpleio;
