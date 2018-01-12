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

WITH ADC;

PACKAGE ADC.libsimpleio IS

  -- Type definitions

  TYPE InputSubclass IS NEW ADC.Interfaces.InputInterface WITH PRIVATE;

  -- ADC input object constructor

  FUNCTION Create
   (chip    : Natural;
    channel : Natural) RETURN ADC.Interfaces.Input;

  -- ADC input read method

  FUNCTION Get
   (self    : IN OUT InputSubclass) RETURN ADC.Sample;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(self : InputSubclass) RETURN Integer;

PRIVATE

  TYPE InputSubclass IS NEW Standard.ADC.Interfaces.InputInterface WITH RECORD
    fd : Integer;
  END RECORD;

END ADC.libsimpleio;
