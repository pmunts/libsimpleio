-- Servo output services using libsimpleio

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

-- Beware: Many PWM controllers impose a common PWM pulse frequency on
-- all channels.  If you attempt to configure different channels on the
-- same PWM controller to different frequencies, you may not get correct
-- output pulse trains.

PACKAGE Servo.libsimpleio IS

  -- Type definitions

  TYPE OutputSubclass IS NEW Servo.Interfaces.OutputInterface WITH PRIVATE;

  -- Servo output object constructor

  FUNCTION Create
   (chip      : Natural;
    channel   : Natural;
    frequency : Positive;
    position  : Servo.Position := Servo.NeutralPosition)
    RETURN Servo.Interfaces.Output;

  -- Servo output write method

  PROCEDURE Put
   (self      : IN OUT OutputSubclass;
    position  : Servo.Position);

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(self : OutputSubclass) RETURN Integer;

PRIVATE

  TYPE OutputSubclass IS NEW Standard.Servo.Interfaces.OutputInterface WITH RECORD
    fd     : Integer;
    period : Integer;
  END RECORD;

END Servo.libsimpleio;
