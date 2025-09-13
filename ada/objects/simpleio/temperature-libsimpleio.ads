-- Linux Industrial I/O Temperature Sensor Services

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

WITH Device;

PACKAGE Temperature.libsimpleio IS

  -- Type definitions

  TYPE InputSubclass IS NEW InputInterface WITH PRIVATE;

  Destroyed : CONSTANT InputSubclass;

  -- Temperature sensor object constructor

  FUNCTION Create(desg : Device.Designator) RETURN Input;

  -- Temperature sensor object instance initializer

  PROCEDURE Initialize(Self : IN OUT InputSubclass; desg : Device.Designator);

  -- Temperature sensor object destroyer

  PROCEDURE Destroy(Self : IN OUT InputSubclass);

  -- Temperature sensor read method

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Celsius;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : InputSubclass) RETURN Integer;

PRIVATE

  -- Check whether temperature sensor object instance has been destroyed

  PROCEDURE CheckDestroyed(Self : InputSubclass);

  TYPE InputSubclass IS NEW InputInterface WITH RECORD
    fd    : Integer  := -1;
    scale : Temperature.Celsius := Celsius'Last;
  END RECORD;

  Destroyed : CONSTANT InputSubclass := InputSubclass'(-1, Celsius'Last);

END Temperature.libsimpleio;
