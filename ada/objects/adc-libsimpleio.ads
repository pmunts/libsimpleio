-- A/D (Analog to Digital) input services using libsimpleio

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

  TYPE Designator IS NEW Device.Designator;

  Unavailable : CONSTANT Designator := Designator(Device.Unavailable);

  TYPE InputSubclass IS NEW Analog.InputInterface WITH PRIVATE;

  -- Constant definitions

  Destroyed : CONSTANT InputSubclass;

  -- ADC input object constructors

  FUNCTION Create
   (desg       : Designator;
    resolution : Positive) RETURN Analog.Input;

  FUNCTION Create
   (chip       : Natural;
    channel    : Natural;
    resolution : Positive) RETURN Analog.Input;

  -- ADC input read method

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Analog.Sample;

  -- Retrieve the A/D converter resolution

  FUNCTION GetResolution(Self : IN OUT InputSubclass) RETURN Positive;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : InputSubclass) RETURN Integer;

PRIVATE

  TYPE InputSubclass IS NEW Analog.InputInterface WITH RECORD
    fd         : Integer;
    resolution : Positive;
  END RECORD;

  Destroyed : CONSTANT InputSubclass := InputSubClass'(-1, 1);

END ADC.libsimpleio;
