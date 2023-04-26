-- Keithley 192 DMM Services

-- Copyright (C)2023, Philip Munts.
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

WITH GPIB.Slave;

PACKAGE Keithley192 IS

  OutOfRange       : EXCEPTION;

  TYPE Device IS NEW GPIB.Slave.DeviceClass WITH PRIVATE;

  -- Default GPIB slave address

  DefaultAddress : CONSTANT GPIB.Address := 8;

  -- Default configuration strings

  ConfigACVolts : CONSTANT String := "F1R0Z0T1S2W1Q0M0K0";
  ConfigDCVolts : CONSTANT String := "F0R0Z0T1S2W1Q0M0K0";
  ConfigKilohms : CONSTANT String := "F2R0Z0T1S1W1Q0M0K0";

  -- Configure DMM

  PROCEDURE Configure(Self : Device; config : String);

  -- Get one measurement (cast to Voltage.Volts or Resistance.Ohms)

  FUNCTION Get(Self : IN OUT Device) RETURN Float;

PRIVATE

  TYPE Device IS NEW GPIB.Slave.DeviceClass WITH NULL RECORD;

END Keithley192;
