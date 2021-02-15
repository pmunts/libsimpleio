-- Motor services for LEGO Power Functions Remote Control motors, using
-- "Single Output Mode".

-- Copyright (C)2019-2021, Philip Munts, President, Munts AM Corp.
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

WITH LEGORC;

PACKAGE Motor.LEGORC IS

  TYPE MotorID IS NEW Standard.LEGORC.Command
    RANGE Standard.LEGORC.MotorA .. Standard.LEGORC.MotorB;

  TYPE Speed IS NEW Integer RANGE -7 .. 7;

  -- Map the discrete motor speeds to corresponding velocity values

  SpeedToVelocity : CONSTANT ARRAY (Speed) OF Velocity :=
   (-1.0,
    -0.8929,
    -0.7500,
    -0.6071,
    -0.4643,
    -0.3214,
    -0.1786,
    0.0,
    0.1786,
    0.3214,
    0.4643,
    0.6071,
    0.7500,
    0.8929,
    1.0);

  TYPE OutputSubclass IS NEW Motor.OutputInterface WITH PRIVATE;

  -- Constructors

  FUNCTION Create
   (ired : NOT NULL Standard.LEGORC.Output;
    chan : Standard.LEGORC.Channel;
    mot  : MotorID;
    velo : Velocity := 0.0) RETURN Motor.Output;

  -- Methods

  PROCEDURE Put
   (Self : IN OUT OutputSubclass;
    velo : Velocity);

PRIVATE

  TYPE OutputSubclass IS NEW Motor.OutputInterface WITH RECORD
    ired : Standard.LEGORC.Output;
    chan : Standard.LEGORC.Channel;
    mot  : MotorID;
  END RECORD;

END Motor.LEGORC;
