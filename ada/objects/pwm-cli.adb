-- PWM (Pulse Width Modulated) output services using command line programs

-- Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

WITH External_Command;

PACKAGE BODY PWM.CLI IS

  -- PWM output object constructor

  FUNCTION Create
   (cmd_config : String;
    cmd_write  : String;  -- Duty cycle will be appended
    frequency  : Positive;
    dutycycle  : PWM.DutyCycle := PWM.MinimumDutyCycle) RETURN PWM.Output IS

    Self : OutputSubclass;

  BEGIN
    Self.Initialize(cmd_config, cmd_write, frequency, dutycycle);
    RETURN NEW OutputSubclass'(Self);
  END Create;

  -- PWM output object initializer

  PROCEDURE Initialize
   (Self       : IN OUT OutputSubclass;
    cmd_config : String;
    cmd_write  : String;  -- Duty cycle will be appended
    frequency  : Positive;
    dutycycle  : PWM.DutyCycle := PWM.MinimumDutyCycle) IS

  BEGIN
    Self.Destroy;

    External_Command.Run(cmd_config);

    Self.write  := To_Unbounded_String(cmd_write);
    Self.period := 1.0/frequency;
    Self.Put(dutycycle);
  END Initialize;

  -- PWM output object destroyer

  PROCEDURE Destroy(Self : IN OUT OutputSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    Self := Destroyed;
  END Destroy;

  -- Check whether PWM output has been destroyed

  PROCEDURE CheckDestroyed(Self : OutputSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE PWM_Error WITH "PWM output has been destroyed";
    END IF;
  END CheckDestroyed;

  -- PWM output write methods

  PROCEDURE Put
   (Self      : IN OUT OutputSubclass;
    dutycycle : PWM.DutyCycle) IS

  BEGIN
    Self.CheckDestroyed;

    External_Command.Run(Ada.Strings.Unbounded.To_String(Self.write) &
      PWM.DutyCycle'Image(dutycycle));
  END Put;

  PROCEDURE Put
   (Self      : IN OUT OutputSubclass;
    ontime    : Duration) IS

  BEGIN
    Self.Put(PWM.MaximumDutyCycle*PWM.DutyCycle(ontime/Self.Period));
  END Put;

  -- Retrieve the configured PWM pulse period

  FUNCTION GetPeriod(Self : IN OUT OutputSubclass) RETURN Duration IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Self.period;
  END GetPeriod;

END PWM.CLI;
