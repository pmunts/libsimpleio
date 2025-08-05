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

WITH Motor;

PACKAGE BuildHAT.PassiveMotor IS

  TYPE OutputSubclass IS NEW Motor.OutputInterface WITH PRIVATE;

  FUNCTION Create
   (dev      : Device;
    port     : Ports;
    velocity : Motor.Velocity := 0.0) RETURN Motor.Output;

  PROCEDURE Initialize
   (Self     : IN OUT OutputSubclass;
    dev      : Device;
    port     : Ports;
    velocity : Motor.Velocity := 0.0);

  PROCEDURE Put
   (Self     : IN OUT OutputSubclass;
    velocity : Motor.Velocity);

PRIVATE

  TYPE OutputSubclass IS NEW Motor.OutputInterface WITH RECORD
    mydev  : Device;
    myport : Ports;
  END RECORD;

END BuildHAT.PassiveMotor;
