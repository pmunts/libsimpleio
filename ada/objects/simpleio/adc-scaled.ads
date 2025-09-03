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

WITH Device;
WITH Voltage;

PACKAGE ADC.Scaled IS

  -- Type definitions

  TYPE InputSubclass IS NEW Voltage.InputInterface WITH PRIVATE;

  -- Voltage input object constructor

  FUNCTION Create(desg : Device.Designator) RETURN Voltage.Input;

  -- Voltage input object initializer

  PROCEDURE Initialize(Self : IN OUT InputSubclass; desg : Device.Designator);

  -- Voltage input object destroyer

  PROCEDURE Destroy(Self : IN OUT InputSubclass);

  -- Voltage input read method

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Voltage.Volts;

PRIVATE

  -- Check whether voltage input has been destroyed

  PROCEDURE CheckDestroyed(Self : InputSubclass);

  TYPE InputSubclass IS NEW Voltage.InputInterface WITH RECORD
    fd    : Integer       := -1;
    scale : Voltage.Volts := 0.0;
  END RECORD;

  Destroyed : CONSTANT InputSubclass := InputSubclass'(-1, 0.0);

END ADC.Scaled;
