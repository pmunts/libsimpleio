-- D/A (Digital to Analog) output services

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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
WITH Logging;

PACKAGE DAC.libsimpleio IS

  -- Type definitions

  TYPE OutputSubclass IS NEW Analog.OutputInterface WITH PRIVATE;

  -- Constant definitions

  Destroyed : CONSTANT OutputSubclass;

  -- DAC output object constructors

  FUNCTION Create
   (desg       : Device.Designator;
    resolution : Positive) RETURN Analog.Output;

  FUNCTION Create
   (chip       : Natural;
    channel    : Natural;
    resolution : Positive) RETURN Analog.Output;

  -- DAC output write method

  PROCEDURE Put
   (Self       : IN OUT OutputSubclass;
    sample     : Analog.Sample);

  -- Retrieve the DAC resolution

  FUNCTION GetResolution(Self : IN OUT OutputSubclass) RETURN Positive;

PRIVATE

  TYPE OutputSubclass IS NEW Analog.OutputInterface WITH RECORD
    chip       : Natural;
    channel    : Natural;
    resolution : Natural;
    maxsample  : Analog.Sample;
    logger     : Logging.Logger;
  END RECORD;

  Destroyed : CONSTANT OutputSubclass :=
    OutputSubClass'(Natural'Last, Natural'Last, 0, 0, NULL);

END DAC.libsimpleio;
