-- Copyright (C)2019-2026, Philip Munts dba Munts Technologies.
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

WITH PWM;

PACKAGE Servo.PWM IS

  -- Type definitions

  TYPE OutputSubclass IS NEW Servo.OutputInterface WITH PRIVATE;

  -- Servo output object constructor

  FUNCTION Create
   (pwmout   : NOT NULL Standard.PWM.Output;
    position : Servo.Position := NeutralPosition;
    minwidth : Duration := 1.0E-3;
    maxwidth : Duration := 2.0E-3)
    RETURN Output;

  -- Servo output write method

  PROCEDURE Put
   (Self     : IN OUT OutputSubclass;
    position : Servo.Position);

PRIVATE

  TYPE OutputSubclass IS NEW OutputInterface WITH RECORD
    pwmout   : Standard.PWM.Output;
    swing    : Duration;
    midpoint : Duration;
  END RECORD;

END Servo.PWM;
