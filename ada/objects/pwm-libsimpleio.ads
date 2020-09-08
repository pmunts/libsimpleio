-- PWM (Pulse Width Modulated) output services using libsimpleio

-- Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.
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

WITH Device;

PACKAGE PWM.libsimpleio IS

  -- Type definitions

  TYPE Polarities IS (ActiveLow, ActiveHigh);

  TYPE OutputSubclass IS NEW PWM.OutputInterface WITH PRIVATE;

  Destroyed : CONSTANT OutputSubclass;

  -- PWM output object constructor

  FUNCTION Create
   (desg      : Device.Designator;
    frequency : Positive;
    dutycycle : PWM.DutyCycle := PWM.MinimumDutyCycle;
    polarity  : Polarities := ActiveHigh) RETURN PWM.Output;

  -- PWM output object initializer

  PROCEDURE Initialize
   (Self      : IN OUT OutputSubclass;
    desg      : Device.Designator;
    frequency : Positive;
    dutycycle : PWM.DutyCycle := PWM.MinimumDutyCycle;
    polarity  : Polarities := ActiveHigh);

  -- PWM output object destroyer

  PROCEDURE Destroy(Self : IN OUT OutputSubclass);

  -- PWM output write methods

  PROCEDURE Put
   (Self      : IN OUT OutputSubclass;
    dutycycle : PWM.DutyCycle);

  PROCEDURE Put
   (Self      : IN OUT OutputSubclass;
    ontime    : Duration);

  -- Retrieve the configured PWM pulse period

  FUNCTION GetPeriod(Self : IN OUT OutputSubclass) RETURN Duration;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : OutputSubclass) RETURN Integer;

PRIVATE

  -- Check whether PWM output has been destroyed

  PROCEDURE CheckDestroyed(Self : OutputSubclass);

  TYPE OutputSubclass IS NEW Standard.PWM.OutputInterface WITH RECORD
    fd     : Integer  := -1;
    period : Duration := 0.0;
  END RECORD;

  Destroyed : CONSTANT OutputSubclass := OutputSubclass'(-1, 0.0);

END PWM.libsimpleio;
