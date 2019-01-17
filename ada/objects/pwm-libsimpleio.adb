-- PWM (Pulse Width Modulated) output services using libsimpleio

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

WITH errno;
WITH libPWM;

PACKAGE BODY PWM.libsimpleio IS

  -- PWM output object constructors

  FUNCTION Create
   (desg      : Device.Designator;
    frequency : Positive;
    dutycycle : PWM.DutyCycle := PWM.MinimumDutyCycle;
    polarity  : Polarities := ActiveHigh) RETURN PWM.Output IS

  BEGIN
    RETURN Create(desg.chip, desg.chan, frequency, dutycycle, polarity);
  END Create;

  FUNCTION Create
   (chip      : Natural;
    channel   : Natural;
    frequency : Positive;
    dutycycle : PWM.DutyCycle := PWM.MinimumDutyCycle;
    polarity  : Polarities := ActiveHigh) RETURN PWM.Output IS

    period : Duration;
    ontime : Duration;
    error  : Integer;
    fd     : Integer;

  BEGIN
    period := 1.0/frequency;
    ontime := Duration(dutycycle/MaximumDutyCycle)*period;

    libPWM.Configure(chip, channel, Positive(period*1E9),
      Natural(ontime*1E9), Polarities'Pos(polarity), error);

    IF error /= 0 THEN
      RAISE PWM_Error WITH "libPWM.Configure() failed, " & errno.strerror(error);
    END IF;

    libPWM.Open(chip, channel, fd, error);

    IF error /= 0 THEN
      RAISE PWM_Error WITH "libPWM.Open() failed, " & errno.strerror(error);
    END IF;

    RETURN NEW OutputSubclass'(fd, period);
  END Create;

  -- PWM output write method

  PROCEDURE Put
   (Self      : IN OUT OutputSubclass;
    dutycycle : PWM.DutyCycle) IS

    ontime : Duration;
    error  : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RAISE PWM_Error WITH "PWM output has been destroyed";
    END IF;

    ontime := Duration(dutycycle/MaximumDutyCycle)*Self.period;

    libPWM.Write(Self.fd, Natural(ontime*1E9), error);

    IF error /= 0 THEN
      RAISE PWM_Error WITH "libPWM.Write() failed, " & errno.strerror(error);
    END IF;
  END Put;

  PROCEDURE Put
   (Self      : IN OUT OutputSubclass;
    ontime    : Duration) IS

    error  : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RAISE PWM_Error WITH "PWM output has been destroyed";
    END IF;

    libPWM.Write(Self.fd, Natural(ontime*1E9), error);

    IF error /= 0 THEN
      RAISE PWM_Error WITH "libPWM.Write() failed, " & errno.strerror(error);
    END IF;
  END Put;

  -- Retrieve the configured PWM pulse period

  FUNCTION GetPeriod(Self : IN OUT OutputSubclass) RETURN Duration IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE PWM_Error WITH "PWM output has been destroyed";
    END IF;

    RETURN Self.period;
  END GetPeriod;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : OutputSubclass) RETURN Integer IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE PWM_Error WITH "PWM output has been destroyed";
    END IF;

    RETURN Self.fd;
  END fd;

END PWM.libsimpleio;
